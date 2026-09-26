# Phase 5 status — retrieval optimization

Date: 2026-08-31. Automation level: **2**, deliberately not the 3 the plan permits — see below.

Objective (plan §5): "improve retrieval only after the Markdown-first solution reaches measured
limits." Read literally, that objective is mostly a prohibition. The deliverable is therefore not
new retrieval tooling — it is the **measurement that decides whether any is warranted**, plus a
trigger per stage so the decision is not made by enthusiasm.

Full detail: [query-benchmark.md](query-benchmark.md) (the questions),
[retrieval-stages.md](retrieval-stages.md) (metrics, stages, fallback),
[benchmark-results.md](benchmark-results.md) (the runs).

## What was built

| Plan task | Delivered |
|---|---|
| 5.1 Establish a query benchmark | [query-benchmark.md](query-benchmark.md) — 24 questions, 3 in each of the plan's 8 categories, in the plan's own `question / expected_pages / expected_answer_elements / must_identify_uncertainty / must_identify_conflict` shape, plus `id` and `category` so a finding can be attributed. Machine-parsed, not just prose. |
| 5.2 Measure retrieval quality | `scripts/retrieval-bench.sh` — recall@N, R-precision, pages-read-to-cover, per-question latency, all read-only. [retrieval-stages.md §5.2](retrieval-stages.md#52-what-is-measured-and-by-what) maps each of the plan's nine metrics to *who* can measure it; the five no script can touch are human columns in [benchmark-results.md](benchmark-results.md), left blank rather than estimated. |
| 5.3 Apply retrieval upgrades progressively | [retrieval-stages.md §5.3](retrieval-stages.md#53-stage-ladder-and-where-this-vault-actually-is) — Stage A is current and the only stage enabled; B, C, and D are **not implemented**, each with a named, checkable trigger and a cheaper thing to try first. |
| 5.4 Add retrieval fallback logic | `prompts/wiki-query.md`'s retrieval order, extended from 5 steps to the plan's 8. [retrieval-stages.md §5.4](retrieval-stages.md#54-the-fallback-order) maps each plan step to its tooling status and does **not** restate the order — a retrieval order in two files is the drift this vault removed everywhere else. |

Wiring: `verify-vault.sh` gained section 10 (benchmark integrity, **gating**), `prompts/wiki-lint.md`
gained the quarterly benchmark run, `.claude/commands/wiki-lint.md`'s `allowed-tools` gained the new
script, `docs/phase-4/lint-layers.md`'s quarterly cadence now runs it, and `AGENTS.md` moved to
Phase 5 with a read-before-tooling pointer at `retrieval-stages.md`.

## Why section 10 gates while section 9 is advisory

Phase 4 made the split explicit: a governance finding is a question about *meaning*, so it must not
block write work. A benchmark that expects a page which no longer exists is not a question — it is a
broken reference, the same class as the `broken-link` check that already gates. The failure it causes
is a misdiagnosis: next quarter's run reports a retrieval regression that is really a stale
benchmark, and a wrong measurement is worse than a loud failure on the day a page is renamed.
`--validate` runs no retrieval, so the gate costs milliseconds.

## Why no new retrieval tooling was installed

Because the trigger has not fired, and the trigger is the deliverable. Concretely, from run 1:

- Full `recall@5` is 82% (18 of 22 scored questions). Stage B's trigger needs **two consecutive**
  runs below 80% *and* misses not explained by a missing index entry or alias *and* a vault above
  ~100 pages. One run, above the floor, 16 pages, and both remaining misses are a textbook
  terminology mismatch.
- Both misses at every read budget trace to **one page** — the synthesis — which never uses the
  words `decision`, `basis`, `accepted`, `approach`, or `initial`, so a decision-vocabulary question
  cannot reach it lexically. The pilot's own experiment recorded exactly this failure mode with
  exactly this fix: add an alias. That is a `wiki/` edit needing approval, not infrastructure.
- Stage C's reporting need was already met by `lint-governance.sh`, a read-only script, which is why
  its trigger is a *third or fourth* recurring metadata question rather than the first.

Installing an index or embeddings now would satisfy the plan's §5.3 heading while violating its
opening sentence, plan §2.6, and the accepted decision the vault is running on.

## Verified, not asserted

- `scripts/test-retrieval-bench.sh` — **14 checks**, in two halves. Integrity: a nonexistent
  expected page, a duplicate id, an unknown category, a category with no question, a non-boolean
  flag, and a benchmark under the plan's 20-question floor are each planted separately and caught.
  Honesty: a page the proxy genuinely cannot reach is reported as a `MISS` with its name and rank
  (not rounded up), a question with no expected page is *excluded* from the aggregates rather than
  scored 0 or 1, `VAULT_BENCH_TOPN` really changes the read budget (a rank-2 hit at N=5 becomes a
  MISS at N=1), and a run leaves every file byte-identical.
- The last check runs `--validate` against the **real** benchmark and the **real** vault, so a page
  renamed in `wiki/` fails the suite instead of quietly degrading the next measurement.
- All six suites pass: portability 42, schema 23, lint-governance 20, retrieval-bench 14,
  wiki-lint 11, baseline-metrics 8 — **118 automated checks**.
- `verify-vault.sh` all clear, 11 printed sections. `check-policy-sync.sh` and
  `check-command-pointers.sh` clean after the phase bump and the new tool permission.
- One measurement bug was found by running the script rather than reading it: with tab-separated
  records, `read` collapsed two adjacent tabs (tab is IFS whitespace), so a question with an empty
  `expected_pages` shifted every later field left and `must_identify_conflict` silently became
  empty. Records now use `0x1f`. Same family as the Phase 0 `xargs` split — a parse that looks
  right on the common case and is wrong on the edge that matters.
- Evidence untouched: no modification to the 20 tracked files under the evidence directory, no
  content drift, every tracked file still read-only. `okf/` untouched — this phase read it and wrote
  nothing under it.

## Why automation level stays at 2

The plan puts Phase 5 at level 3. Nothing here needs it: the benchmark is read-only, and every
action it might recommend (add an alias, add an index entry, install an index) is either a `wiki/`
write that already requires a plan or an infrastructure change that requires the owner. Level 3
would mean the agent executing low-risk operations autonomously, and Phase 4's reason for declining
it has not changed — the auto-fix candidates are still conditioned on an observation period with one
data point.

## Exit criteria

| Criterion | State |
|---|---|
| Retrieval benchmark established | **Met.** 24 questions, all 8 plan categories, machine-parsed, integrity-gated by `verify-vault.sh` section 10, and re-validated against live vault state by its own test suite. |
| Baseline and optimized results compared | **Met in the only form available, and that form is real.** Run 1 records the baseline and a read-budget sweep: 68% full recall at 3 pages read per question, 82% at 5, 91% at 10 — 3 questions converted for 13 extra reads, then 2 for 15. The default sits at the knee. A *tooling* comparison does not exist because no stage trigger has fired, and manufacturing one to fill this row is the overengineering the phase exists to prevent. |
| New tooling produces measurable improvement | **Not applicable, deliberately.** No new tooling was introduced. This becomes a hard gate the day any stage is enabled: [retrieval-stages.md §5.3](retrieval-stages.md#53-stage-ladder-and-where-this-vault-actually-is) requires a recorded before/after run around every change, including a change to the measurement proxy itself. |
| Every answer remains traceable to Markdown | **Met, structurally rather than by policy.** There is no derived index of any kind; the corpus the benchmark searches *is* the Markdown, and `/wiki-trace` walks a claim from a page to a read-only evidence file. |
| Semantic search can be disabled without losing knowledge | **Met trivially, and protected for later.** Never enabled. The four non-negotiables (Markdown is the source of truth, the index is disposable, embeddings select candidates only, an embedding hit is never evidence) are written into Stage D as preconditions, so the criterion is testable the day it is built rather than remembered. |
| Query cost and latency remain within agreed budgets | **Half met — measured, not yet agreed.** Latency and read cost are measured (median 22 ms for the lexical proxy; 59 page reads to cover 22 questions at a budget of 5). No budget has ever been *agreed*, and setting a threshold is a policy act, not an agent judgement: a proposal is in the open items below. Token cost per answer is unmeasured — no script sees it. |

## Open items for the pilot owner

1. **Run the 24 questions through `/wiki-query` and fill the human columns** in
   [benchmark-results.md](benchmark-results.md). Citation correctness, unsupported-claim rate,
   uncertainty/conflict identification (5 questions each), and usefulness are the metrics that
   decide whether retrieval is *good*; the script only decides whether pages are *reachable*. The
   agent can run the queries; the reviewing is the part only a person can do — same shape as Phase
   2's 8 manual schema cases.
2. **Approve or decline the alias proposal.** The synthesis
   `Markdown-First Retrieval vs Early Semantic Search for Small Pilot Vaults` is lexically
   unreachable in decision vocabulary, which is finding 1 of run 1. Adding aliases is a `wiki/`
   write, medium risk, plan-gated — and nothing was edited pre-emptively, because tuning the vault
   to flatter its own first baseline would destroy the baseline.
3. **Agree the retrieval budget**, which turns the last exit criterion from measured into met.
   Proposed, on one run's evidence and therefore weakly: read budget **5 pages per question**
   (the knee of the sweep), full `recall@5` floor **80%**, benchmark validation always green. Two
   consecutive runs under the floor is already Stage B's trigger, so agreeing this number is what
   makes that trigger operational.
4. **Grow the benchmark when the vault grows.** A page added without a question is invisible to the
   measurement. This is bound to the decision on the 12 uningested evidence files
   ([session-summary open item 2](../session-summary.md#open-items-for-the-pilot-owner)): ingesting
   them would roughly double the corpus and should add roughly a question per new concept, not per
   new file.
