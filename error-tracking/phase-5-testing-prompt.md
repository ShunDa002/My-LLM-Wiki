# Phase 5: Retrieval Optimization — Comprehensive Testing Prompt

**Target agent:** Gemini 3.8 Flash  
**Vault under test:** LLM Wiki + OKF pilot vault (`llm-wiki3`)  
**Phase being tested:** Phase 5 — Retrieval Optimization  
**Date:** 2026-09-26

---

> [!IMPORTANT]
> This prompt is designed to be given to Gemini 3.8 Flash operating inside the LLM Wiki vault.
> The agent must read `GEMINI.md` → `AGENTS.md` first. All tasks are **read-only** unless
> explicitly marked as requiring a plan + approval. The agent must never commit, push, or
> modify `raw/`.

---

## Instructions for the testing agent

You are testing whether Phase 5 (Retrieval Optimization) of the LLM Wiki + OKF pilot vault has
been implemented correctly. Phase 5's objective is: "improve retrieval only after the
Markdown-first solution reaches measured limits."

Read `GEMINI.md` and `AGENTS.md` before doing anything. Then read these Phase 5 documents:

- `docs/phase-5/status.md`
- `docs/phase-5/retrieval-stages.md`
- `docs/phase-5/query-benchmark.md`
- `docs/phase-5/benchmark-results.md`

Execute every test section below **in order**. For each test, state:

- **PASS**, **FAIL**, or **PARTIAL** with explanation
- What you observed (quote file contents, script output, or page frontmatter)
- Any discrepancies from the plan

Produce a final summary table at the end.

---

## Test 1: Vault safety pre-check

Before any testing, confirm the operating environment is safe.

1. Run `bash scripts/verify-vault.sh` and report whether it passes all sections (expect 11 sections).
2. Confirm the Git pre-commit hook is armed by checking `git config core.hooksPath`.
3. Confirm `raw/` files are read-only at the OS level (check file permissions on a few files under `raw/`).
4. Confirm `AGENTS.md` declares the vault is at Phase 5, automation level 2.

**Pass criteria:** All four checks clean. If the pre-commit hook is not armed, report it as a
safety finding before proceeding, per `GEMINI.md`.

---

## Test 2: Query benchmark existence and structure (Plan §5.1)

The plan requires 20–50 representative questions across 8 categories.

1. Read `docs/phase-5/query-benchmark.md`. Count the total questions and verify each has the
   plan-required fields: `id`, `category`, `question`, `expected_pages`,
   `expected_answer_elements`, `must_identify_uncertainty`, `must_identify_conflict`.
2. Verify there are exactly **8 categories** as specified in the plan:
   - Direct factual lookup
   - Concept explanation
   - Comparison
   - Cross-source synthesis
   - Decision traceability
   - Project impact
   - Contradiction detection
   - Missing-evidence recognition
3. Verify each category has at least 2 questions (the plan says the minimum is 20 total across 8).
4. Verify that every page listed in `expected_pages` actually exists in the vault (run
   `bash scripts/retrieval-bench.sh --validate` to confirm).
5. Verify that `Q23` and `Q24` have empty `expected_pages` (deliberately unanswerable questions).

**Pass criteria:** ≥20 questions, all 8 categories covered, all expected pages exist, fields
match the plan's schema, unanswerable questions are properly marked.

---

## Test 3: Retrieval measurement tooling (Plan §5.2)

The plan requires tracking 9 metrics. Verify each is either measured by script or explicitly
assigned to human review.

1. Read `docs/phase-5/retrieval-stages.md` section 5.2. List all 9 plan metrics and confirm
   each has a documented measurement method:

   | Metric | Measured by |
   |--------|-------------|
   | Precision of selected pages | script (R-precision) |
   | Recall of expected pages | script (recall@N) |
   | Citation correctness | human |
   | Unsupported-claim rate | human |
   | Query latency | script |
   | Token consumption | human |
   | Number of files read | script (pages read to cover) |
   | Percentage of answers starting from the index | human |
   | Human usefulness score | human |

2. Confirm `scripts/retrieval-bench.sh` exists, is runnable, and produces output.
   Run: `bash scripts/retrieval-bench.sh --validate`
3. Verify the script is **read-only** — it writes no files, modifies no vault content.
4. Confirm that `verify-vault.sh` section 10 runs benchmark validation as a gate.

**Pass criteria:** All 9 metrics accounted for, script runs without errors on `--validate`,
script is confirmed read-only, section 10 gating confirmed.

---

## Test 4: Benchmark results baseline (Plan §5.2)

A baseline measurement must exist.

1. Read `docs/phase-5/benchmark-results.md`. Confirm at least one run is recorded.
2. Verify the baseline run includes:
   - Read budget sweep (at least 2 different top-N values)
   - Mean R-precision
   - Mean recall@N
   - Full recall@N (count of questions with perfect recall)
   - Pages read to cover
   - Median latency
3. Verify the human-checked section exists but is marked as **not filled in** (no fabricated
   scores).
4. Verify findings are recorded with diagnosis (not just numbers).
5. Run the benchmark yourself: `bash scripts/retrieval-bench.sh` and confirm the script
   output is consistent with the recorded results (note: exact numbers may vary if vault
   content has changed since baseline).

**Pass criteria:** Baseline run exists with all script-measurable metrics, human metrics are
honestly blank, findings are diagnosed.

---

## Test 5: Stage ladder and triggers (Plan §5.3)

The plan defines 4 progressive retrieval stages (A through D). Verify each is documented with
a trigger condition.

1. Read `docs/phase-5/retrieval-stages.md` section 5.3.
2. Verify **Stage A** (curated routing) is marked as current and enabled. Confirm these tools
   are available: `wiki/index.md`, domain overview pages, wikilinks, filename search, grep.
3. Verify **Stage B** (local Markdown indexing) is marked as **not implemented**. Confirm it
   has:
   - A named, checkable trigger (all conditions must hold)
   - A "cheaper thing to try first" list
   - No installed tooling
4. Verify **Stage C** (metadata-oriented retrieval) is marked as **not implemented**. Confirm
   it has:
   - A named trigger
   - An explanation of why it's not needed yet (the `lint-governance.sh` argument)
5. Verify **Stage D** (semantic retrieval) is marked as **not implemented**. Confirm it has:
   - A trigger that depends on Stage B being in place first
   - The 4 non-negotiable preconditions from the plan (Markdown is source of truth, vector
     index is disposable, semantic retrieval selects candidates only, embedding hit is never
     evidence)
6. Verify `AGENTS.md` contains a read-before-tooling pointer at `retrieval-stages.md`.

**Pass criteria:** All 4 stages documented, only Stage A enabled, each later stage has a named
trigger, no premature tooling installed, non-negotiables for Stage D recorded.

---

## Test 6: Retrieval fallback logic (Plan §5.4)

The plan specifies an 8-step fallback order.

1. Read `prompts/wiki-query.md` and find the retrieval order. Verify it contains all 8 plan
   steps:
   1. Read index
   2. Follow explicit Wiki links
   3. Use metadata filters
   4. Use full-text search
   5. Use semantic retrieval if necessary
   6. Read selected documents
   7. Verify against raw evidence for critical claims
   8. Answer with citations
2. Read `docs/phase-5/retrieval-stages.md` section 5.4. Confirm it maps each plan step to its
   current tooling status and names the fallback for disabled steps (3 → grep on frontmatter,
   5 → say "vault does not know").
3. Verify the retrieval order exists in **one authoritative location** (`prompts/wiki-query.md`),
   not duplicated in `retrieval-stages.md` — the "drift this vault removed everywhere else"
   design.
4. Verify the query workflow explicitly states that semantic retrieval is not available and
   must not be filled by the model's own knowledge.

**Pass criteria:** All 8 steps present in the query workflow, fallback mapping documented,
single source of truth for the retrieval order, model-knowledge prohibition stated.

---

## Test 7: Run the full 24-question benchmark via `/wiki-query`

This is the core Phase 5 test. Run each of the 24 benchmark questions through the query
workflow defined in `prompts/wiki-query.md`.

For each question:

1. Follow the retrieval order in `prompts/wiki-query.md` exactly.
2. Record which retrieval step produced the answer (index → links → metadata → full-text →
   "vault does not know").
3. Check: did you find all the `expected_pages` listed for that question?
4. Check: does your answer contain the `expected_answer_elements`?
5. If `must_identify_uncertainty` is true: did you identify uncertainty?
6. If `must_identify_conflict` is true: did you surface the conflict?

### Questions to run

Run all 24 questions from `docs/phase-5/query-benchmark.md`:

**Direct factual lookup:** Q01, Q02, Q03  
**Concept explanation:** Q04, Q05, Q06  
**Comparison:** Q07, Q08, Q09  
**Cross-source synthesis:** Q10, Q11, Q12  
**Decision traceability:** Q13, Q14, Q15  
**Project impact:** Q16, Q17, Q18  
**Contradiction detection:** Q19, Q20, Q21  
**Missing-evidence recognition:** Q22, Q23, Q24

For each answer, produce a structured report:

```text
### Q<id> — <category>
Question: <the question>
Retrieval path: <which steps were used>
Pages found: <list>
Expected pages found: <yes/no, which missed>
Answer elements covered: <yes/no, which missed>
Uncertainty identified: <yes/no/not required>
Conflict identified: <yes/no/not required>
Result: PASS / FAIL / PARTIAL
Notes: <any observations>
```

**Special attention for missing-evidence questions (Q22–Q24):**

- Q22 must point to the existing question page and say the vault does not know the answer.
- Q23 and Q24 have no expected pages — the correct answer is "the vault does not know" plus
  what source would settle it. An answer that invents information from the model's knowledge
  is a **FAIL**.

**Pass criteria:** ≥80% of the 22 scored questions (Q01–Q22) retrieve all expected pages.
All 5 uncertainty flags correctly handled. All 5 conflict flags correctly handled. Q23 and
Q24 correctly identified as unanswerable.

---

## Test 8: Citation correctness and unsupported claims

For each answer produced in Test 7:

1. Verify every cited page **actually exists** in the vault.
2. Verify every cited page **actually supports** the sentence citing it (not just topically
   related — the specific claim must appear on that page).
3. Count any claims in the answer that have **no citation** behind them.
4. Count any claims where the cited page does **not** support the specific claim made.

**Pass criteria:** Zero citations to nonexistent pages. Zero unsupported claims that could have
been cited. Every factual statement has a wikilink citation.

---

## Test 9: Retrieval decision traceability (cross-cutting)

This tests whether the vault's central knowledge claim — "markdown-first retrieval is sufficient
at this scale" — is fully traceable.

1. Start from `okf/decisions/Select Initial Retrieval Approach.md`. Read its `knowledge_basis`.
2. Follow the `knowledge_basis` link to the synthesis. Read its `based_on` and `sources`.
3. Follow each source page to its `raw_file`. Confirm the raw file exists.
4. Read `validated_by` on the decision. Follow it to the experiment page. Confirm the
   experiment has a conclusion.
5. Verify the chain: Decision → Synthesis → Source pages → Raw files is complete and
   unbroken.
6. Check: does `/wiki-trace` (or manually following the chain) reach `raw/` evidence files
   at the end?

**Pass criteria:** Full traceability from decision to raw evidence with no broken links.

---

## Test 10: Test suite integrity

Verify the Phase 5 test infrastructure is sound.

1. Run `bash scripts/test-retrieval-bench.sh` and confirm all tests pass (expect 14 checks).
2. Verify the test suite covers:
   - Integrity checks (nonexistent expected page, duplicate ID, unknown category, category
     with no question, non-boolean flag, benchmark below 20-question floor)
   - Honesty checks (unreachable page reported as MISS, no-expected-page questions excluded
     from aggregates, `VAULT_BENCH_TOPN` changes the read budget, run leaves files
     byte-identical)
   - Live validation against the real vault and real benchmark
3. Run the full test suite: `bash scripts/verify-vault.sh` and confirm all 11 sections pass.

**Pass criteria:** All 14 retrieval bench tests pass, verify-vault all clear.

---

## Test 11: Wiring and integration

Verify Phase 5 is wired into the existing governance framework.

1. Confirm `verify-vault.sh` section 10 runs `retrieval-bench.sh --validate` as a **gating**
   check (failures block, not merely warn).
2. Confirm `prompts/wiki-lint.md` includes `retrieval-bench.sh` as a quarterly lint tool.
3. Confirm `docs/phase-4/lint-layers.md` quarterly cadence includes the benchmark run.
4. Confirm `AGENTS.md` has been updated to Phase 5 with a read-before-tooling pointer at
   `docs/phase-5/retrieval-stages.md`.
5. Confirm `AGENTS.md` states: "Editing `docs/phase-5/query-benchmark.md` to make a
   measurement look better is the same class of act as editing a page to silence a lint
   finding."

**Pass criteria:** All 5 integration points confirmed.

---

## Test 12: Automation level and restraint

Verify the vault correctly stays at automation level 2, not the level 3 the plan permits.

1. Read `docs/phase-5/status.md` "Why automation level stays at 2" section.
2. Confirm `AGENTS.md` declares automation level 2.
3. Verify the reasoning: no new retrieval tooling was installed because no stage trigger has
   fired.
4. Verify the status page explains **why** each stage trigger has not fired, with evidence
   from Run 1:
   - Full recall@5 is 82% (above the 80% Stage B floor)
   - Both remaining misses are terminology mismatches (not method limits)
   - The vault is at 16 pages (below Stage B's ~100-page threshold)
5. Verify no retrieval tooling beyond Stage A's tools (grep, filename search, wikilinks,
   index) exists in the vault.

**Pass criteria:** Level 2 confirmed, restraint reasoning documented with data, no premature
tooling installed.

---

## Test 13: Exit criteria verification

Verify each Phase 5 exit criterion from the implementation plan (§5 Exit criteria).

| # | Exit criterion | How to verify |
|---|---|---|
| 1 | Retrieval benchmark established | `query-benchmark.md` exists with ≥20 questions across 8 categories |
| 2 | Baseline and optimized results compared | `benchmark-results.md` Run 1 exists with read-budget sweep |
| 3 | New tooling produces measurable improvement | Verify this is marked "not applicable, deliberately" — no new tooling installed because no trigger fired |
| 4 | Every answer remains traceable to Markdown | No derived index exists; the corpus is the Markdown. `/wiki-trace` walks claims to raw evidence |
| 5 | Semantic search can be disabled without losing knowledge | Never enabled. Stage D preconditions written as testable requirements |
| 6 | Query cost and latency remain within agreed budgets | Verify latency is measured (median ~22ms). Note: budget has not been formally agreed yet (open item) |

For each criterion, state **Met**, **Partially met**, or **Not met** with evidence.

**Pass criteria:** Criteria 1, 2, 4, 5 fully met. Criterion 3 correctly marked N/A. Criterion
6 partially met (measured but budget not agreed — expected, it's an open item).

---

## Test 14: Open items acknowledged

Verify that known gaps are documented transparently, not hidden.

1. Read `docs/phase-5/status.md` "Open items for the pilot owner" section.
2. Confirm these 4 items are documented:
   - Human columns in benchmark-results.md need to be filled
   - Alias proposal for the synthesis page needs approval
   - Retrieval budget needs to be agreed
   - Benchmark should grow when vault grows
3. Verify none of these items were silently resolved by the agent (e.g., aliases were NOT
   pre-emptively added to the synthesis page).

**Pass criteria:** All 4 open items documented, none silently resolved.

---

## Test 15: Policy compliance

Verify the Phase 5 implementation respects all vault policies.

1. Confirm no files under `raw/` were modified during Phase 5 (check `wiki/log.md` for Phase 5
   operations, verify none target `raw/`).
2. Confirm no OKF records were modified during Phase 5 (`status.md` says "okf/ untouched").
3. Confirm the query benchmark does not edit measurements to improve scores (the
   `AGENTS.md` prohibition).
4. Confirm `wiki/log.md` has entries for any Phase 5 write operations.
5. Confirm the benchmark script cannot write files (read-only by design).

**Pass criteria:** All 5 policy checks clean.

---

## Final summary

After all tests, produce a summary table:

```text
PHASE 5 TESTING SUMMARY — LLM Wiki + OKF Pilot Vault
Agent: Gemini 3.8 Flash
Date: <date>

| Test | Description                              | Result  | Notes |
|------|------------------------------------------|---------|-------|
|  1   | Vault safety pre-check                   |         |       |
|  2   | Query benchmark structure (§5.1)         |         |       |
|  3   | Retrieval measurement tooling (§5.2)     |         |       |
|  4   | Benchmark results baseline (§5.2)        |         |       |
|  5   | Stage ladder and triggers (§5.3)         |         |       |
|  6   | Retrieval fallback logic (§5.4)          |         |       |
|  7   | Full 24-question benchmark run           |         |       |
|  8   | Citation correctness                     |         |       |
|  9   | Retrieval decision traceability          |         |       |
| 10   | Test suite integrity                     |         |       |
| 11   | Wiring and integration                   |         |       |
| 12   | Automation level and restraint           |         |       |
| 13   | Exit criteria verification               |         |       |
| 14   | Open items acknowledged                  |         |       |
| 15   | Policy compliance                        |         |       |

Overall: PASS / FAIL / PARTIAL
Findings count: <n>
Critical findings: <list or "none">
Recommendations: <list>
```

Report any findings, discrepancies, or observations that don't fit the test categories.
If any test produces a FAIL, note whether it is a Phase 5 implementation defect or a
pre-existing vault issue.
