#!/usr/bin/env bash
# Phase 5 retrieval benchmark: measure whether lexical retrieval finds the pages the benchmark
# says a question needs. Read-only; writes nothing anywhere, ever.
#
# What this measures, and what it does not:
#
#   It runs a MECHANICAL PROXY for Stage A retrieval — significant words from the question,
#   case-insensitive fixed-string match across wiki/ and okf/ pages, ranked by how many distinct
#   question terms a page matches. That is the "full-text search" step of the retrieval order in
#   prompts/wiki-query.md, with the index and wikilink hops removed.
#
#   The agent does better than this by design: it reads wiki/index.md first and follows links,
#   which is exactly the part a shell script cannot reproduce. So these numbers are a FLOOR, not
#   a score for the query workflow. A page this script cannot reach lexically is a page that
#   depends entirely on the index and links being right — which is the interesting finding, and
#   the reason the proxy is worth having: it isolates the one retrieval layer that can be measured
#   without a model in the loop, run to run, for free.
#
#   Citation correctness, unsupported-claim rate, and usefulness are NOT measurable here — no
#   script reads an answer. Those stay human columns in docs/phase-5/benchmark-results.md.
#
# Usage:
#   bash scripts/retrieval-bench.sh              # validate, then run and report
#   bash scripts/retrieval-bench.sh --validate   # benchmark integrity only, no retrieval
# Exit: 0 benchmark is sound (run mode always, since a measurement is not a pass/fail),
#       1 the benchmark itself is broken — a cited page that does not exist, a duplicate id.
#
# Env: VAULT_BENCH_FILE (default docs/phase-5/query-benchmark.md)
#      VAULT_BENCH_TOPN (default 5 — the read budget recall is measured at)
set -uo pipefail
cd "$(dirname "$0")/.."
# shellcheck source=lib-vault.sh
. scripts/lib-vault.sh

BENCH="${VAULT_BENCH_FILE:-docs/phase-5/query-benchmark.md}"
TOPN="${VAULT_BENCH_TOPN:-5}"
CATEGORIES="factual concept comparison cross-source traceability impact contradiction missing-evidence"

mode=run
case "${1:-}" in
  --validate) mode=validate ;;
  "") ;;
  *) echo "unknown argument: $1" >&2; exit 2 ;;
esac

[ -f "$BENCH" ] || { printf 'MISSING: %s\n' "$BENCH" >&2; exit 2; }

# Retrievable pages. wiki/index.md and wiki/log.md are excluded: the index is a routing hop, not
# an answer, and the log is history. wiki/sources/ IS included — a source page is a legitimate
# retrieval target, and the benchmark cites one.
bench_pages() { notes | grep -E '^(wiki|okf)/' | grep -vE '^wiki/(index|log)\.md$'; }

# Grammar words only. Nothing domain-bearing: dropping "vault" or "retrieval" here would quietly
# turn the proxy into a measurement of this stopword list instead of the vault.
STOP='^(what|when|where|which|does|this|that|from|with|have|been|will|would|should|about|there|their|than|then|into|over|much|many|more|most|some|only|also|just|does|each|both|between|after|before|because|while|whether|being|were)$'

# Milliseconds since epoch. EPOCHREALTIME is bash 5; date +%s%N is GNU; BSD date has neither, so
# the last fallback loses sub-second resolution rather than the whole run. Same both-dialects
# reasoning as stale_cutoff() in lint-governance.sh.
now_ms() {
  if [ -n "${EPOCHREALTIME:-}" ]; then
    printf '%s\n' "${EPOCHREALTIME/,/.}" | awk -F. '{printf "%d\n", $1*1000 + substr($2 "000",1,3)}'
  else
    local n; n=$(date +%s%N 2>/dev/null)
    case "$n" in *N|"") echo $(( $(date +%s) * 1000 )) ;; *) echo $(( n / 1000000 )) ;; esac
  fi
}

# --- parse the benchmark ---------------------------------------------------
# One record per question, fields separated by US (0x1f): id, category, question, expected titles
# joined by '|', unc, conf. Not tab — tab is IFS whitespace, so bash's read collapses two of them
# and an empty expected_pages field silently shifts every later field left. That bug shipped once
# in this script's first run.
# Only the fenced yaml blocks are read, so surrounding prose can say anything.
parse_bench() {
  awk '
    /^```yaml$/ { inb=1; id=cat=q=ep=unc=conf=""; next }
    /^```$/ {
      if (inb && id != "") printf "%s\037%s\037%s\037%s\037%s\037%s\n", id, cat, q, ep, unc, conf
      inb=0; next
    }
    !inb { next }
    /^id:/            { sub(/^id:[ \t]*/,""); id=$0; next }
    /^category:/      { sub(/^category:[ \t]*/,""); cat=$0; next }
    /^question:/      { sub(/^question:[ \t]*/,""); q=$0; next }
    /^expected_pages:/ {
      rest=$0; sub(/^expected_pages:[ \t]*/,"",rest)
      inexp = (rest == "" ? 1 : 0)          # "[]" or a value ends the list here
      next
    }
    /^must_identify_uncertainty:/ { sub(/^[^:]*:[ \t]*/,""); unc=$0; inexp=0; next }
    /^must_identify_conflict:/    { sub(/^[^:]*:[ \t]*/,""); conf=$0; inexp=0; next }
    inexp && /^[ \t]*-[ \t]*/ {
      sub(/^[ \t]*-[ \t]*/,""); gsub(/^["'"'"']|["'"'"']$/,"")
      ep = (ep == "" ? $0 : ep "|" $0); next
    }
    /^[a-z_]+:/ { inexp=0 }
  ' "$BENCH"
}

problems=0
report() { printf 'PROBLEM: %s\n' "$1"; problems=$((problems + 1)); }

# --- validate -------------------------------------------------------------
# A benchmark that cites a page which no longer exists reports a retrieval failure that is really
# a benchmark defect. That misdiagnosis is the whole reason this check exists as a gate before the
# run rather than a note after it.
rows=$(parse_bench)
[ -n "$rows" ] || { echo "PROBLEM: no question blocks parsed from $BENCH" >&2; exit 1; }

titles=$(existing_titles)
seen_ids=""
n_q=0
while IFS=$'\037' read -r id cat q exp unc conf; do
  n_q=$((n_q + 1))
  [ -n "$id" ]  || report "a block has no id"
  [ -n "$q" ]   || report "$id has no question"
  case " $seen_ids " in *" $id "*) report "duplicate id: $id" ;; esac
  seen_ids="$seen_ids $id"
  case " $CATEGORIES " in *" $cat "*) ;; *) report "$id has unknown category '$cat'" ;; esac
  case "$unc" in true|false) ;; *) report "$id must_identify_uncertainty is '$unc', want true/false" ;; esac
  case "$conf" in true|false) ;; *) report "$id must_identify_conflict is '$conf', want true/false" ;; esac
  if [ -n "$exp" ]; then
    IFS='|' read -r -a want <<< "$exp"
    for t in "${want[@]}"; do
      grep -qxF -- "$t" <<< "$titles" || report "$id expects page '$t', which does not exist in the vault"
    done
  fi
done <<< "$rows"

for c in $CATEGORIES; do
  awk -F'\037' -v c="$c" '$2 == c { found=1 } END { exit !found }' <<< "$rows" ||
    report "no question in category '$c'"
done
if [ "$n_q" -lt 20 ]; then
  report "$n_q questions; the plan asks for 20 to 50"
fi

if [ "$problems" -gt 0 ]; then
  echo
  echo "$problems problem(s) in the benchmark itself. Fix $BENCH before trusting a measurement."
  exit 1
fi
if [ "$mode" = validate ]; then
  echo "Benchmark sound: $n_q questions, all $(printf '%s' "$CATEGORIES" | wc -w | tr -d ' ') categories present, every expected page exists."
  exit 0
fi

# --- run ------------------------------------------------------------------
mapfile -t FILES < <(bench_pages)
[ "${#FILES[@]}" -gt 0 ] || { echo "no retrievable pages under wiki/ or okf/" >&2; exit 2; }

echo "RETRIEVAL BENCHMARK (mechanical Stage A proxy — a floor, not a score for /wiki-query)"
echo "Vault:     $(pwd)"
echo "Commit:    $(git rev-parse --short HEAD 2>/dev/null || echo 'no commit yet')"
echo "Benchmark: $BENCH   ($n_q questions)"
echo "Corpus:    ${#FILES[@]} retrievable pages    read budget (top-N): $TOPN"
echo

printf '%-5s %-15s %9s %9s %9s %7s\n' id category R-prec "recall@$TOPN" worst-rank ms
misses=""
sum_rp=0; sum_rc=0; scored=0; full=0; lat_all=""; reads=0
noexp_q=0; noexp_hits=""
flag_unc=0; flag_conf=0

while IFS=$'\037' read -r id cat q exp unc conf; do
  [ "$unc" = true ] && flag_unc=$((flag_unc + 1))
  [ "$conf" = true ] && flag_conf=$((flag_conf + 1))

  terms=$(printf '%s\n' "$q" | tr 'A-Z' 'a-z' | tr -cs 'a-z0-9' '\n' |
          awk 'length($0) >= 4' | grep -vE "$STOP" | sort -u)

  t0=$(now_ms)
  hits=""
  while IFS= read -r term; do
    [ -n "$term" ] || continue
    hits="$hits$(grep -lFi -- "$term" "${FILES[@]}" 2>/dev/null)"$'\n'
  done <<< "$terms"
  # Ranked page titles, best first. Ties break on path so a run is reproducible.
  ranked=$(printf '%s' "$hits" | grep -v '^$' | sort | uniq -c | sort -k1,1nr -k2 |
           sed 's/^ *[0-9]* //; s#.*/##; s#\.md$##')
  t1=$(now_ms)
  ms=$((t1 - t0)); lat_all="$lat_all$ms"$'\n'

  if [ -z "$exp" ]; then
    # No expected pages by design. Precision and recall are undefined, so this question is
    # excluded from the aggregates instead of being scored 0 or 1 — either would be a lie. What
    # is reported is how many pages lexical search offered anyway: the false-confidence surface.
    top_n=$(printf '%s\n' "$ranked" | grep -c . || true)
    noexp_q=$((noexp_q + 1))
    noexp_hits="$noexp_hits  $id  $top_n page(s) matched, top: $(printf '%s\n' "$ranked" | head -1 | sed 's/^$/(none)/')"$'\n'
    printf '%-5s %-15s %9s %9s %9s %7s\n' "$id" "$cat" "n/a" "n/a" "n/a" "$ms"
    continue
  fi

  IFS='|' read -r -a want <<< "$exp"
  R=${#want[@]}
  topR=$(printf '%s\n' "$ranked" | head -"$R")
  topN=$(printf '%s\n' "$ranked" | head -"$TOPN")
  rp_hits=0; rc_hits=0; worst=0; missing=""
  for t in "${want[@]}"; do
    grep -qxF -- "$t" <<< "$topR" && rp_hits=$((rp_hits + 1))
    if grep -qxF -- "$t" <<< "$topN"; then
      rc_hits=$((rc_hits + 1))
      rank=$(printf '%s\n' "$ranked" | grep -nxF -- "$t" | head -1 | cut -d: -f1)
      [ "$rank" -gt "$worst" ] && worst=$rank
    else
      rank=$(printf '%s\n' "$ranked" | grep -nxF -- "$t" | head -1 | cut -d: -f1)
      missing="$missing    $id  '$t' $([ -n "$rank" ] && echo "ranked $rank, outside top-$TOPN" || echo 'not retrieved at all')"$'\n'
    fi
  done
  rp=$(awk -v h="$rp_hits" -v r="$R" 'BEGIN{printf "%.2f", h/r}')
  rc=$(awk -v h="$rc_hits" -v r="$R" 'BEGIN{printf "%.2f", h/r}')
  sum_rp=$(awk -v s="$sum_rp" -v v="$rp" 'BEGIN{print s+v}')
  sum_rc=$(awk -v s="$sum_rc" -v v="$rc" 'BEGIN{print s+v}')
  scored=$((scored + 1))
  if [ "$rc_hits" -eq "$R" ]; then
    full=$((full + 1)); reads=$((reads + worst))
    printf '%-5s %-15s %9s %9s %9s %7s\n' "$id" "$cat" "$rp" "$rc" "$worst" "$ms"
  else
    reads=$((reads + TOPN))
    printf '%-5s %-15s %9s %9s %9s %7s  MISS\n' "$id" "$cat" "$rp" "$rc" "-" "$ms"
    misses="$misses$missing"
  fi
done <<< "$rows"

echo
echo "-- aggregate (scored questions only: $scored of $n_q) --"
awk -v rp="$sum_rp" -v rc="$sum_rc" -v n="$scored" -v f="$full" -v topn="$TOPN" 'BEGIN{
  printf "  mean R-precision      %.2f\n", (n ? rp/n : 0)
  printf "  mean recall@%-9s %.2f\n", topn, (n ? rc/n : 0)
  printf "  full recall@%-9s %d of %d (%.0f%%)\n", topn, f, n, (n ? 100*f/n : 0)
}'
printf '  median latency        %s ms\n' "$(printf '%s' "$lat_all" | grep -v '^$' | sort -n |
  awk '{a[NR]=$1} END{ if (NR) print (NR%2 ? a[(NR+1)/2] : int((a[NR/2]+a[NR/2+1])/2)) }')"
printf '  pages read to cover   %s (budget %s per question)\n' "$reads" "$TOPN"

if [ -n "$misses" ]; then
  echo
  echo "-- expected pages the lexical proxy did not reach --"
  printf '%s' "$misses"
  echo "  These depend on the index and wikilinks, which this proxy deliberately skips. Check"
  echo "  the index entry and aliases before concluding retrieval is at its limit — that is what"
  echo "  both failures in the pilot's own benchmark turned out to be."
fi

if [ "$noexp_q" -gt 0 ]; then
  echo
  echo "-- questions with no expected page (unanswerable by design) --"
  printf '%s' "$noexp_hits"
  echo "  A high match count here is not a retrieval success. It is the size of the false-"
  echo "  confidence surface: pages an answer could be assembled from that do not cover the"
  echo "  question. The answer must say the vault does not know — human-checked, not scored here."
fi

echo
echo "-- human-checked, not measured above --"
printf '  %s questions require the answer to identify uncertainty\n' "$flag_unc"
printf '  %s questions require the answer to identify a conflict\n' "$flag_conf"
echo "  citation correctness, unsupported-claim rate, usefulness: read the answers and record"
echo "  them in docs/phase-5/benchmark-results.md. No script can score these."
exit 0
