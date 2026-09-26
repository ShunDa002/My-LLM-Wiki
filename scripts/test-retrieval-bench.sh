#!/usr/bin/env bash
# Self-check for retrieval-bench.sh. Two halves, same shape as test-lint-governance.sh:
#
#   1. Benchmark integrity — a broken benchmark must be caught before it is measured, because a
#      benchmark that cites a deleted page reports a retrieval failure that is really a benchmark
#      defect. Each defect is planted one at a time against a known-good fixture.
#   2. Measurement honesty — a page the lexical proxy cannot reach must be reported as a MISS, and
#      a question with no expected page must be excluded from the aggregates rather than scored.
#      A benchmark that rounds its own failures up is worse than none.
#
# The last check runs --validate against the REAL benchmark and the real vault, so a page renamed
# in wiki/ breaks this suite instead of quietly degrading the next measurement.
# Run: bash scripts/test-retrieval-bench.sh
set -uo pipefail
here=$(cd "$(dirname "$0")" && pwd)
fail=0
ok()   { echo "ok   $1"; }
bad()  { echo "FAIL $1"; fail=1; }

# A fixture vault with three pages and a full 24-question benchmark: 8 categories x 3, which is
# what the plan's minimum (20 questions, all 8 categories) requires to validate at all.
mk() { # <root>
  local r="$1" c q
  mkdir -p "$r/scripts" "$r/wiki/concepts" "$r/wiki/syntheses" "$r/okf/projects" "$r/raw" "$r/docs/phase-5"
  cp "$here/retrieval-bench.sh" "$here/lib-vault.sh" "$r/scripts/"
  printf -- '---\ntitle: Wiki Index\n---\n# Index\n' > "$r/wiki/index.md"
  printf -- '---\ntitle: Operation Log\n---\n# Log\n' > "$r/wiki/log.md"
  printf -- '---\ntitle: Alpha Concept\n---\nThe alpha concept covers widget calibration.\n' \
    > "$r/wiki/concepts/Alpha Concept.md"
  printf -- '---\ntitle: Beta Concept\n---\nBeta discusses sprocket tolerance and widget wear.\n' \
    > "$r/wiki/concepts/Beta Concept.md"
  # Deliberately shares no vocabulary with the question that expects it: the terminology-mismatch
  # failure mode the pilot's own benchmark hit twice, reproduced on purpose.
  printf -- '---\ntitle: Gamma Synthesis\n---\nNothing here uses the asking vocabulary.\n' \
    > "$r/wiki/syntheses/Gamma Synthesis.md"

  : > "$r/docs/phase-5/query-benchmark.md"
  local n=0
  for c in factual concept comparison cross-source traceability impact contradiction missing-evidence; do
    for q in 1 2 3; do
      n=$((n + 1))
      cat >> "$r/docs/phase-5/query-benchmark.md" <<EOF
\`\`\`yaml
id: Q$(printf '%02d' "$n")
category: $c
question: Which page covers widget calibration for the alpha concept?
expected_pages:
  - Alpha Concept
expected_answer_elements:
  - widget calibration
must_identify_uncertainty: false
must_identify_conflict: false
\`\`\`

EOF
    done
  done
  # Q24 is replaced below in the fixture that needs it; the two special cases are appended as
  # edits to specific ids so the counts stay at 24.
}

run() { (cd "$1" && bash scripts/retrieval-bench.sh "${2:-}" 2>&1); }

# ============================ 1. clean fixture =============================
clean=$(mktemp -d); mk "$clean"
out=$(run "$clean" --validate); rc=$?
[ "$rc" -eq 0 ] && grep -q 'Benchmark sound' <<< "$out" \
  && ok "clean benchmark validates" || bad "clean benchmark rejected: $out"

# --- retrieval actually finds the page it should
out=$(run "$clean"); rc=$?
if grep -qE '^Q01 +factual +1\.00 +1\.00 +1' <<< "$out"; then
  ok "expected page retrieved at rank 1"
else
  bad "Q01 did not score 1.00/1.00 at rank 1"; printf '%s\n' "$out" | sed -n '7,9p'
fi
[ "$rc" -eq 0 ] && ok "run mode exits 0 (a measurement is not a pass/fail)" \
                || bad "run mode exit code was $rc, want 0"

# --- read-only by construction
before=$(cd "$clean" && find wiki okf docs -type f -exec sha256sum {} + | sort)
run "$clean" >/dev/null
after=$(cd "$clean" && find wiki okf docs -type f -exec sha256sum {} + | sort)
[ "$before" = "$after" ] && ok "benchmark run wrote nothing" || bad "benchmark run modified files"

# --- top-N budget is honoured: at N=1, a rank-2 expected page must become a MISS
tight=$(mktemp -d); mk "$tight"
python3 - "$tight/docs/phase-5/query-benchmark.md" <<'PY'
import sys
p = sys.argv[1]; s = open(p).read()
# Q02 expects the page that ranks second for its question wording.
s = s.replace("""id: Q02
category: factual
question: Which page covers widget calibration for the alpha concept?
expected_pages:
  - Alpha Concept""", """id: Q02
category: factual
question: Which page covers widget wear and calibration?
expected_pages:
  - Beta Concept""", 1)
open(p, 'w').write(s)
PY
wide=$(cd "$tight" && VAULT_BENCH_TOPN=5 bash scripts/retrieval-bench.sh 2>&1)
narrow=$(cd "$tight" && VAULT_BENCH_TOPN=1 bash scripts/retrieval-bench.sh 2>&1)
if ! grep -qE '^Q02 .*MISS' <<< "$wide" && grep -qE '^Q02 .*MISS' <<< "$narrow"; then
  ok "VAULT_BENCH_TOPN changes the read budget (hit at 5, MISS at 1)"
else
  bad "top-N budget not honoured"; grep -E '^Q02' <<< "$wide$narrow"
fi

# --- an unreachable expected page is reported, not rounded up
mism=$(mktemp -d); mk "$mism"
python3 - "$mism/docs/phase-5/query-benchmark.md" <<'PY'
import sys
p = sys.argv[1]; s = open(p).read()
s = s.replace("""id: Q03
category: factual
question: Which page covers widget calibration for the alpha concept?
expected_pages:
  - Alpha Concept""", """id: Q03
category: factual
question: Which page covers widget calibration for the alpha concept?
expected_pages:
  - Gamma Synthesis""", 1)
open(p, 'w').write(s)
PY
out=$(run "$mism")
if grep -qE '^Q03 .*MISS' <<< "$out" && grep -q "'Gamma Synthesis'" <<< "$out"; then
  ok "terminology mismatch reported as a MISS with the page named"
else
  bad "unreachable expected page was not reported"; printf '%s\n' "$out" | grep -E 'Q03|Gamma'
fi

# --- a question with no expected page is excluded, not scored
noexp=$(mktemp -d); mk "$noexp"
python3 - "$noexp/docs/phase-5/query-benchmark.md" <<'PY'
import sys
p = sys.argv[1]; s = open(p).read()
s = s.replace("""id: Q24
category: missing-evidence
question: Which page covers widget calibration for the alpha concept?
expected_pages:
  - Alpha Concept""", """id: Q24
category: missing-evidence
question: Which vendor sells the cheapest flux capacitor?
expected_pages: []""", 1)
open(p, 'w').write(s)
PY
out=$(run "$noexp")
if grep -qE '^Q24 .*n/a' <<< "$out" && grep -q 'scored questions only: 23 of 24' <<< "$out"; then
  ok "unanswerable question excluded from aggregates, not scored 0 or 1"
else
  bad "no-expected-page question mishandled"; grep -E 'Q24|scored questions' <<< "$out"
fi

# ============================ 2. planted benchmark defects =================
plant() { # <label> <python-edit> <expected-problem-substring>
  local root; root=$(mktemp -d); mk "$root"
  python3 -c "$2" "$root/docs/phase-5/query-benchmark.md"
  local o rc; o=$(run "$root" --validate); rc=$?
  if [ "$rc" -eq 1 ] && grep -qF "$3" <<< "$o"; then ok "$1"
  else bad "$1 -- rc=$rc, output: $(head -3 <<< "$o")"; fi
  rm -r -- "$root"
}

plant "expected page that does not exist is caught" \
  'import sys;p=sys.argv[1];s=open(p).read();open(p,"w").write(s.replace("  - Alpha Concept","  - Deleted Page",1))' \
  "expects page 'Deleted Page', which does not exist"

plant "duplicate id is caught" \
  'import sys;p=sys.argv[1];s=open(p).read();open(p,"w").write(s.replace("id: Q02","id: Q01",1))' \
  "duplicate id: Q01"

plant "unknown category is caught" \
  'import sys;p=sys.argv[1];s=open(p).read();open(p,"w").write(s.replace("category: factual","category: vibes",1))' \
  "unknown category 'vibes'"

plant "a category with no question is caught" \
  'import sys;p=sys.argv[1];s=open(p).read();open(p,"w").write(s.replace("category: contradiction","category: factual"))' \
  "no question in category 'contradiction'"

plant "a non-boolean flag is caught" \
  'import sys;p=sys.argv[1];s=open(p).read();open(p,"w").write(s.replace("must_identify_conflict: false","must_identify_conflict: maybe",1))' \
  "must_identify_conflict is 'maybe'"

# Below the plan's own floor of 20 questions.
short=$(mktemp -d); mk "$short"
head -90 "$short/docs/phase-5/query-benchmark.md" > "$short/docs/phase-5/short.md"
out=$(cd "$short" && VAULT_BENCH_FILE=docs/phase-5/short.md bash scripts/retrieval-bench.sh --validate 2>&1); rc=$?
[ "$rc" -eq 1 ] && grep -q 'the plan asks for 20 to 50' <<< "$out" \
  && ok "a benchmark under 20 questions is caught" || bad "short benchmark accepted: $out"

# ============================ 3. the real thing ============================
# The live benchmark against the live vault. A renamed or deleted wiki page must break here,
# loudly, rather than show up as a retrieval regression in the next measurement.
out=$(cd "$here/.." && bash scripts/retrieval-bench.sh --validate 2>&1); rc=$?
[ "$rc" -eq 0 ] && ok "the real benchmark still matches the real vault" \
  || bad "live benchmark is broken: $out"

rm -r -- "$clean" "$tight" "$mism" "$noexp" "$short"
if [ "$fail" -eq 0 ]; then echo "PASS"; else echo "FAILED"; fi
exit "$fail"
