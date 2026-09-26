# LLM Wiki Phase 5 — Retrieval Optimization Test Report

- **Date:** 2026-09-26
- **Phase:** Phase 5 (Retrieval Optimization)
- **Agent Environment:** Antigravity / Gemini 3.8 Flash (Linux x86_64)
- **Prompt Reference:** [`error-tracking/phase-5-testing-prompt.md`](file:///c/Data/llm-wiki3/error-tracking/phase-5-testing-prompt.md)
- **Vault Root:** `/c/Data/llm-wiki3`
- **Objective:** "Improve retrieval only after the Markdown-first solution reaches measured limits."

---

## Test 1: Vault safety pre-check

### Result: **PASS**

### Observations:
1. **`bash scripts/verify-vault.sh`**:
   The verification script ran and passed cleanly across 11 printed sections with exit code 0:
   ```text
   VAULT VERIFICATION
   Vault:  /c/Data/llm-wiki3
   Commit: 34a5075
   Agent:  unset   (set VAULT_AGENT to record which agent ran this)

   -- enforcement --
   ok    core.hooksPath = .githooks
   ok    pre-commit hook present and executable

   -- evidence integrity (raw/) --
   ok    no modification to 20 tracked file(s)
   ok    no content drift against recorded source_id

   -- OS-level lock (raw/) --
   ok    all committed evidence is read-only

   -- structural lint --
   ok    wiki-lint: no findings

   -- policy single-sourcing --
   ok    CLAUDE.md imports AGENTS.md, which holds every invariant rule

   -- command pointer integrity --
   ok    command files are thin pointers with adequate tool permissions

   -- schema conformance --
   ok    every page matches the approved metadata schema

   -- duplicate candidates (advisory) --
   ok    no duplicate candidates

   -- OKF semantic protection --
   ok    no unauthorized change to an accepted decision, a completed experiment, or a project's protected fields

   -- governance lint (Phase 4, advisory) --
   note  governance findings — review, never auto-fix:
         okf-review-overdue             okf/projects/LLM Wiki Pilot.md review_date 2026-09-24 has passed (today 2026-09-26)
         okf-review-overdue             okf/decisions/Select Initial Retrieval Approach.md review_date 2026-09-24 has passed (today 2026-09-26)
         project-on-disputed-knowledge  okf/projects/LLM Wiki Pilot.md -> [[Markdown-First Retrieval vs Early Semantic Search for Small Pilot Vaults]] -> [[Markdown-First Retrieval]] is disputed (one hop via based_on)
         project-on-disputed-knowledge  okf/projects/LLM Wiki Pilot.md -> [[Markdown-First Retrieval vs Early Semantic Search for Small Pilot Vaults]] -> [[Semantic Search Enablement Timing]] is disputed (one hop via based_on)
         knowledge-changed-since-decision okf/decisions/Select Initial Retrieval Approach.md (accepted 2026-08-24) rests on [[Markdown-First Retrieval vs Early Semantic Search for Small Pilot Vaults]], updated 2026-08-30 — review, never auto-reopen
     fix policy per finding type: docs/phase-4/lint-layers.md

   -- retrieval benchmark integrity --
   ok    Benchmark sound: 24 questions, all 8 categories present, every expected page exists.

   All clear.
   ```
2. **Git pre-commit hook**:
   `git config core.hooksPath` returned `.githooks`. The pre-commit hook is active and executable.
3. **OS-level permissions on `raw/`**:
   Files under `raw/articles/` (e.g., `raw/articles/01-markdown-first-retrieval.md`) have permissions `-r--r--r--` (mode 444), confirming write protection at the OS level.
4. **Declared phase and automation level**:
   `AGENTS.md` line 6 declares:
   > `Phase: **5 (retrieval optimization)**. Automation level: **2** — the agent proposes plans and executes approved ones.`

### Discrepancies from plan:
None.

---

## Test 2: Query benchmark existence and structure (Plan §5.1)

### Result: **PASS**

### Observations:
1. **Benchmark file & schema**:
   `docs/phase-5/query-benchmark.md` contains 24 YAML-fenced questions. Each block contains all required fields: `id`, `category`, `question`, `expected_pages`, `expected_answer_elements`, `must_identify_uncertainty`, and `must_identify_conflict`.
2. **Category distribution**:
   There are exactly 8 categories matching the plan specification, with 3 questions per category:
   - Direct factual lookup (`factual`): `Q01`, `Q02`, `Q03`
   - Concept explanation (`concept`): `Q04`, `Q05`, `Q06`
   - Comparison (`comparison`): `Q07`, `Q08`, `Q09`
   - Cross-source synthesis (`cross-source`): `Q10`, `Q11`, `Q12`
   - Decision traceability (`traceability`): `Q13`, `Q14`, `Q15`
   - Project impact (`impact`): `Q16`, `Q17`, `Q18`
   - Contradiction detection (`contradiction`): `Q19`, `Q20`, `Q21`
   - Missing-evidence recognition (`missing-evidence`): `Q22`, `Q23`, `Q24`
3. **Page existence validation**:
   Running `bash scripts/retrieval-bench.sh --validate` confirmed:
   `Benchmark sound: 24 questions, all 8 categories present, every expected page exists.`
4. **Deliberately unanswerable questions**:
   `Q23` and `Q24` explicitly define `expected_pages: []`:
   - `Q23`: "What does a query cost in tokens per answer at production scale?" (`expected_pages: []`)
   - `Q24`: "Which vendor's embedding model performs best for this vault's content?" (`expected_pages: []`)

### Discrepancies from plan:
None.

---

## Test 3: Retrieval measurement tooling (Plan §5.2)

### Result: **PASS**

### Observations:
1. **Mapping of 9 metrics**:
   `docs/phase-5/retrieval-stages.md` §5.2 maps all nine plan metrics to their measurement mechanisms:
   - Precision of selected pages: script (`R-precision`)
   - Recall of expected pages: script (`recall@N`)
   - Number of files read: script (`pages read to cover`)
   - Query latency: script (per-question ms and median for lexical proxy)
   - Percentage of answers starting from index: human (proxy has no index step)
   - Citation correctness: human
   - Unsupported-claim rate: human
   - Token consumption: human (agent accounting)
   - Human usefulness score: human (1–5 scale)
2. **Script execution**:
   `scripts/retrieval-bench.sh` is runnable and executed cleanly with `--validate` (exit 0).
3. **Read-only verification**:
   Analysis of `scripts/retrieval-bench.sh` confirmed it creates no files, executes no file redirects (`>`, `>>`), and performs all ranking/computations strictly in memory/stdout.
4. **Section 10 gating**:
   Section 10 of `scripts/verify-vault.sh` runs `retrieval-bench.sh --validate` as a gating check (any benchmark defect causes `verify-vault.sh` to fail and block write operations).

### Discrepancies from plan:
None.

---

## Test 4: Benchmark results baseline (Plan §5.2)

### Result: **PASS**

### Observations:
1. **Baseline run recorded**:
   `docs/phase-5/benchmark-results.md` records "Run 1 — 2026-08-31 · baseline · commit 34a5075" with Stage A tools only.
2. **Read budget sweep**:
   Baseline records a sweep across top-N read budgets $\{3, 5, 10\}$:
   - $N=3$: mean R-prec 0.61, mean recall@3 0.79, full recall 15/22 (68%), pages read 46, median latency 23 ms
   - $N=5$ (default): mean R-prec 0.61, mean recall@5 0.92, full recall 18/22 (82%), pages read 59, median latency 22 ms
   - $N=10$: mean R-prec 0.61, mean recall@10 0.96, full recall 20/22 (91%), pages read 74, median latency 23 ms
3. **Honest human metrics**:
   Human review columns in `benchmark-results.md` use em-dashes `—`, indicating they are intentionally left unfilled until a human review occurs.
4. **Diagnosed findings**:
   Finding 1 explains that both remaining misses across all budgets (`Q08`, `Q13`) trace to `Markdown-First Retrieval vs Early Semantic Search for Small Pilot Vaults`, which lacks decision vocabulary (`decision`, `basis`, `accepted`, `approach`, `initial`). Finding 2 documents R-precision 0.00 at recall 1.00 as a ranking observation. Finding 3 notes the false-confidence surface of unanswerable questions (12 and 13 page matches).
5. **Live benchmark run**:
   `bash scripts/retrieval-bench.sh` produced:
   - mean R-precision: 0.61
   - mean recall@5: 0.92
   - full recall@5: 18 of 22 (82%)
   - pages read to cover: 59
   - median latency: 25 ms (consistent with baseline ~22 ms)
   - unanswerable false-confidence matches: Q23 matched 12 pages, Q24 matched 13 pages.

### Discrepancies from plan:
None.

---

## Test 5: Stage ladder and triggers (Plan §5.3)

### Result: **PASS**

### Observations:
1. **Documented stages**:
   `docs/phase-5/retrieval-stages.md` §5.3 defines the 4-stage progression:
2. **Stage A (curated routing)**:
   Marked as current and only enabled stage. Tools: `wiki/index.md`, domain descriptions, wikilinks, filename search, `grep`.
3. **Stage B (local Markdown indexing)**:
   Marked as "not implemented". Trigger requires two consecutive runs below 80% full recall@5, misses unexplained by missing index entries or aliases, and vault size > ~100 pages. Cheaper alternatives listed in order: add missing index entry $\rightarrow$ add alias $\rightarrow$ split overloaded page.
4. **Stage C (metadata-oriented retrieval)**:
   Marked as "not implemented". Trigger requires a 3rd or 4th recurring metadata question (since `scripts/lint-governance.sh` handles the first two without needing a database engine).
5. **Stage D (semantic retrieval)**:
   Marked as "not implemented, and the highest bar". Trigger requires Stage B in place and persistent semantic misses. Non-negotiables enforced: Markdown remains source of truth, index is disposable, embeddings select candidates only, embedding hits are never evidence.
6. **Operating policy pointer**:
   `AGENTS.md` lines 23-27 point to `retrieval-stages.md` and explicitly prohibit adding retrieval tooling without a triggered failure.

### Discrepancies from plan:
None.

---

## Test 6: Retrieval fallback logic (Plan §5.4)

### Result: **PASS**

### Observations:
1. **8-step retrieval order**:
   `prompts/wiki-query.md` defines the operative retrieval order:
   1. `wiki/index.md` — start here, always
   2. Follow explicit Wiki links from whatever the index points at
   3. Filter on frontmatter when the question is about metadata (`grep` on field)
   4. Search the Wiki full-text for terms from question, including `aliases`
   5. Semantic retrieval — not available in this vault
   6. Read a small number of the best candidates
   7. Expand into `raw/` only when the Wiki is insufficient or critical claims need verification
   8. Answer with citations
2. **Fallback status mapping**:
   `docs/phase-5/retrieval-stages.md` §5.4 maps each step to tooling status (Step 3 falls back to `grep` on frontmatter; Step 5 falls back to "the vault does not know" + settling source).
3. **Single source of truth**:
   `retrieval-stages.md` explicitly avoids duplicating the retrieval order to prevent policy drift.
4. **Prohibition on model knowledge**:
   `prompts/wiki-query.md` lines 25-28 mandate stating "the vault does not know" rather than answering from model knowledge.

### Discrepancies from plan:
None.

---

## Test 7: Run the full 24-question benchmark via `/wiki-query`

### Result: **PASS**

All 24 questions were executed following the retrieval order in `prompts/wiki-query.md`:

```text
### Q01 — factual
Question: Below what page count does markdown-first retrieval claim to hold?
Retrieval path: Step 1 (Index: wiki/index.md) -> Step 2 (Follow link: Markdown-First Retrieval) -> Step 6 (Read document)
Pages found: wiki/concepts/Markdown-First Retrieval.md
Expected pages found: yes (Markdown-First Retrieval)
Answer elements covered: yes ("roughly 100 pages", "the source declines to give an exact number")
Uncertainty identified: not required
Conflict identified: not required
Result: PASS
Notes: Grounded in [[Markdown-First Retrieval]] Definition and Open questions sections.

### Q02 — factual
Question: What median retrieval time did the native retrieval benchmark experiment record?
Retrieval path: Step 1 (Index: okf/ pointer) -> Step 4 (Full-text search: "Native Retrieval Benchmark") -> Step 6 (Read document)
Pages found: okf/experiments/Native Retrieval Benchmark.md
Expected pages found: yes (Native Retrieval Benchmark)
Answer elements covered: yes ("11 seconds", "synthetic test data")
Uncertainty identified: not required
Conflict identified: not required
Result: PASS
Notes: Grounded in [[Native Retrieval Benchmark]] Metrics and Conclusion.

### Q03 — factual
Question: Where does operational history belong, and where does it not belong?
Retrieval path: Step 1 (Index: wiki/index.md) -> Step 2 (Follow link: Wiki Index as Routing Layer) -> Step 6 (Read document)
Pages found: wiki/concepts/Wiki Index as Routing Layer.md
Expected pages found: yes (Wiki Index as Routing Layer)
Answer elements covered: yes ("wiki/log.md holds operational history", "the index is navigation, not history")
Uncertainty identified: not required
Conflict identified: not required
Result: PASS
Notes: Grounded in [[Wiki Index as Routing Layer]] Definition and Key points.

### Q04 — concept
Question: What is the index meant to contain as a routing layer, and what does it exclude?
Retrieval path: Step 1 (Index: wiki/index.md) -> Step 2 (Follow link: Wiki Index as Routing Layer) -> Step 6 (Read document)
Pages found: wiki/concepts/Wiki Index as Routing Layer.md
Expected pages found: yes (Wiki Index as Routing Layer)
Answer elements covered: yes ("wikilink plus one-sentence description", "not every page, not full summaries")
Uncertainty identified: not required
Conflict identified: not required
Result: PASS
Notes: Grounded in [[Wiki Index as Routing Layer]] Key points.

### Q05 — concept
Question: How do structural lint findings differ from semantic lint findings?
Retrieval path: Step 1 (Index: wiki/index.md) -> Step 2 (Follow link: Wiki Maintenance and Lint Layers) -> Step 6 (Read document)
Pages found: wiki/concepts/Wiki Maintenance and Lint Layers.md
Expected pages found: yes (Wiki Maintenance and Lint Layers)
Answer elements covered: yes ("structural may eventually be auto-repaired", "semantic contradictions and merges escalate to a human")
Uncertainty identified: not required
Conflict identified: not required
Result: PASS
Notes: Grounded in [[Wiki Maintenance and Lint Layers]] Definition and Key points.

### Q06 — concept
Question: What position does semantic search enablement timing take, and what evidence backs it?
Retrieval path: Step 1 (Index: wiki/index.md) -> Step 2 (Follow link: Semantic Search Enablement Timing) -> Step 6 (Read document)
Pages found: wiki/concepts/Semantic Search Enablement Timing.md
Expected pages found: yes (Semantic Search Enablement Timing)
Answer elements covered: yes ("embeddings from day one, unconditionally", "no benchmark, cost model, or size threshold")
Uncertainty identified: not required
Conflict identified: not required
Result: PASS
Notes: Grounded in [[Semantic Search Enablement Timing]] Definition and Key points.

### Q07 — comparison
Question: For a pilot vault under 100 pages, curated navigation or embeddings from day one?
Retrieval path: Step 1 (Index: wiki/index.md) -> Step 2 (Follow links: Markdown-First Retrieval, Markdown-First Retrieval vs Early Semantic Search for Small Pilot Vaults) -> Step 6 (Read documents)
Pages found: wiki/syntheses/Markdown-First Retrieval vs Early Semantic Search for Small Pilot Vaults.md, wiki/concepts/Markdown-First Retrieval.md
Expected pages found: yes (Markdown-First Retrieval vs Early Semantic Search for Small Pilot Vaults, Markdown-First Retrieval)
Answer elements covered: yes ("start with curated navigation and text search", "add embeddings after a measured failure")
Uncertainty identified: not required
Conflict identified: yes (conflict between Markdown-First Retrieval and Semantic Search Enablement Timing identified; both disputed)
Result: PASS
Notes: Grounded in [[Markdown-First Retrieval vs Early Semantic Search for Small Pilot Vaults]] and [[Markdown-First Retrieval]].

### Q08 — comparison
Question: How do the two retrieval positions differ in the evidence each one offers?
Retrieval path: Step 1 (Index: wiki/index.md) -> Step 2 (Follow links: Markdown-First Retrieval, Semantic Search Enablement Timing, Markdown-First Retrieval vs Early Semantic Search for Small Pilot Vaults) -> Step 6 (Read documents)
Pages found: wiki/syntheses/Markdown-First Retrieval vs Early Semantic Search for Small Pilot Vaults.md, wiki/concepts/Semantic Search Enablement Timing.md, wiki/concepts/Markdown-First Retrieval.md
Expected pages found: yes (all 3 pages found via Index entry routing)
Answer elements covered: yes ("one side has a scale condition, a trigger condition, and a benchmark", "the other side has none of the three")
Uncertainty identified: not required
Conflict identified: yes (disputed status and opposing claims surfaced)
Result: PASS
Notes: While the mechanical proxy ranked the synthesis low, human/agent navigation via `wiki/index.md` found all 3 expected pages directly.

### Q09 — comparison
Question: What are the strengths and weaknesses of enabling embeddings on day one?
Retrieval path: Step 1 (Index: wiki/index.md) -> Step 2 (Follow links: Semantic Search Enablement Timing, Markdown-First Retrieval vs Early Semantic Search for Small Pilot Vaults) -> Step 6 (Read documents)
Pages found: wiki/concepts/Semantic Search Enablement Timing.md, wiki/syntheses/Markdown-First Retrieval vs Early Semantic Search for Small Pilot Vaults.md
Expected pages found: yes (Semantic Search Enablement Timing, Markdown-First Retrieval vs Early Semantic Search for Small Pilot Vaults)
Answer elements covered: yes ("may catch phrasing mismatches lexical search misses", "reliability is undefined and unmeasured")
Uncertainty identified: not required
Conflict identified: not required
Result: PASS
Notes: Grounded in comparison table in [[Markdown-First Retrieval vs Early Semantic Search for Small Pilot Vaults]] and [[Semantic Search Enablement Timing]].

### Q10 — cross-source
Question: How many independent sources support the markdown-first claim, and what was measured?
Retrieval path: Step 1 (Index: wiki/index.md) -> Step 2 (Follow link: Markdown-First Retrieval -> Source - Pilot Experiment - Native Retrieval Benchmark) -> Step 6 (Read documents)
Pages found: wiki/concepts/Markdown-First Retrieval.md, wiki/sources/Source - Pilot Experiment - Native Retrieval Benchmark.md
Expected pages found: yes (Markdown-First Retrieval, Source - Pilot Experiment - Native Retrieval Benchmark)
Answer elements covered: yes ("two independent sources plus one benchmark", "18 of 20 questions retrieved all expected pages at 42 pages")
Uncertainty identified: not required
Conflict identified: not required
Result: PASS
Notes: Grounded in [[Markdown-First Retrieval]] and [[Source - Pilot Experiment - Native Retrieval Benchmark]].

### Q11 — cross-source
Question: What retrieval evidence does this vault hold in total, across sources and experiments?
Retrieval path: Step 1 (Index: wiki/index.md) -> Step 2 (Follow links: Markdown-First Retrieval, Markdown-First Retrieval vs Early Semantic Search for Small Pilot Vaults) -> Step 4 (Full-text/link: Native Retrieval Benchmark) -> Step 6 (Read documents)
Pages found: wiki/syntheses/Markdown-First Retrieval vs Early Semantic Search for Small Pilot Vaults.md, wiki/concepts/Markdown-First Retrieval.md, okf/experiments/Native Retrieval Benchmark.md
Expected pages found: yes (Markdown-First Retrieval vs Early Semantic Search for Small Pilot Vaults, Markdown-First Retrieval, Native Retrieval Benchmark)
Answer elements covered: yes ("four source pages, one benchmark experiment", "all of it synthetic pilot fixtures")
Uncertainty identified: yes (explicitly noted that all evidence is synthetic pilot fixtures and not real production data)
Conflict identified: not required
Result: PASS
Notes: Grounded in sources listed across synthesis, concept, and experiment pages.

### Q12 — cross-source
Question: Why is the retrieval synthesis confidence medium rather than high?
Retrieval path: Step 1 (Index: wiki/index.md) -> Step 2 (Follow link: Markdown-First Retrieval vs Early Semantic Search for Small Pilot Vaults) -> Step 6 (Read document)
Pages found: wiki/syntheses/Markdown-First Retrieval vs Early Semantic Search for Small Pilot Vaults.md
Expected pages found: yes (Markdown-First Retrieval vs Early Semantic Search for Small Pilot Vaults)
Answer elements covered: yes ("all four inputs are synthetic test fixtures", "internal consistency does not raise it above medium")
Uncertainty identified: not required
Conflict identified: not required
Result: PASS
Notes: Grounded in [[Markdown-First Retrieval vs Early Semantic Search for Small Pilot Vaults]] Confidence section.

### Q13 — traceability
Question: What knowledge basis supports the accepted decision on the initial retrieval approach?
Retrieval path: Step 1 (Index: okf/ pointer) -> Step 4 (Search decision: Select Initial Retrieval Approach) -> Step 2 (Follow knowledge_basis link: Markdown-First Retrieval vs Early Semantic Search for Small Pilot Vaults) -> Step 6 (Read documents)
Pages found: okf/decisions/Select Initial Retrieval Approach.md, wiki/syntheses/Markdown-First Retrieval vs Early Semantic Search for Small Pilot Vaults.md
Expected pages found: yes (Select Initial Retrieval Approach, Markdown-First Retrieval vs Early Semantic Search for Small Pilot Vaults)
Answer elements covered: yes ("one synthesis as knowledge_basis", "traceable through source pages to raw files")
Uncertainty identified: not required
Conflict identified: not required
Result: PASS
Notes: Grounded in [[Select Initial Retrieval Approach]] and [[Markdown-First Retrieval vs Early Semantic Search for Small Pilot Vaults]].

### Q14 — traceability
Question: Which experiment validates the retrieval decision, and what did it conclude?
Retrieval path: Step 1 (Index: okf/ pointer) -> Step 4 (Search decision: Select Initial Retrieval Approach) -> Step 2 (Follow validated_by link: Native Retrieval Benchmark) -> Step 6 (Read documents)
Pages found: okf/experiments/Native Retrieval Benchmark.md, okf/decisions/Select Initial Retrieval Approach.md
Expected pages found: yes (Native Retrieval Benchmark, Select Initial Retrieval Approach)
Answer elements covered: yes ("Native Retrieval Benchmark, status complete", "sufficient at this pilot's scale, not a general capacity claim")
Uncertainty identified: not required
Conflict identified: not required
Result: PASS
Notes: Grounded in [[Select Initial Retrieval Approach]] validated_by field and [[Native Retrieval Benchmark]] Conclusion.

### Q15 — traceability
Question: When is the retrieval decision due for review, and what would trigger an early review?
Retrieval path: Step 1 (Index: okf/ pointer) -> Step 3 (Filter frontmatter: okf/decisions/Select Initial Retrieval Approach.md) -> Step 6 (Read document)
Pages found: okf/decisions/Select Initial Retrieval Approach.md
Expected pages found: yes (Select Initial Retrieval Approach)
Answer elements covered: yes ("2026-09-24", "repeated retrieval failures that naming fixes do not resolve")
Uncertainty identified: not required
Conflict identified: not required
Result: PASS
Notes: Grounded in [[Select Initial Retrieval Approach]] Review date section.

### Q16 — impact
Question: Which project is informed by the retrieval synthesis?
Retrieval path: Step 1 (Index: okf/ pointer) -> Step 3 (Filter frontmatter: informed_by in okf/projects/) -> Step 6 (Read document)
Pages found: okf/projects/LLM Wiki Pilot.md
Expected pages found: yes (LLM Wiki Pilot)
Answer elements covered: yes ("LLM Wiki Pilot, via informed_by")
Uncertainty identified: not required
Conflict identified: not required
Result: PASS
Notes: Grounded in [[LLM Wiki Pilot]] frontmatter and Knowledge basis section.

### Q17 — impact
Question: If markdown-first retrieval were superseded, which OKF records would need review?
Retrieval path: Step 1 (Index: okf/ pointer) -> Step 2/3/4 (Follow OKF links referencing the retrieval synthesis/decision) -> Step 6 (Read documents)
Pages found: okf/decisions/Select Initial Retrieval Approach.md, okf/projects/LLM Wiki Pilot.md, okf/experiments/Native Retrieval Benchmark.md
Expected pages found: yes (Select Initial Retrieval Approach, LLM Wiki Pilot, Native Retrieval Benchmark)
Answer elements covered: yes ("the accepted decision, the project informed by the synthesis, the validating experiment", "propose review, never change status")
Uncertainty identified: not required
Conflict identified: not required
Result: PASS
Notes: Grounded in [[Select Initial Retrieval Approach]], [[LLM Wiki Pilot]], [[Native Retrieval Benchmark]], and vault bridge policy.

### Q18 — impact
Question: What is the pilot project's goal, and what does its status note record?
Retrieval path: Step 1 (Index: okf/ pointer) -> Step 4 (Search: LLM Wiki Pilot) -> Step 6 (Read document)
Pages found: okf/projects/LLM Wiki Pilot.md
Expected pages found: yes (LLM Wiki Pilot)
Answer elements covered: yes ("prove one safe complete knowledge-to-action cycle", "Phase 1 walkthrough with 7 synthetic sources")
Uncertainty identified: not required
Conflict identified: not required
Result: PASS
Notes: Grounded in [[LLM Wiki Pilot]] Goal and Status notes sections.

### Q19 — contradiction
Question: Does this vault agree on when semantic search should be enabled?
Retrieval path: Step 1 (Index: wiki/index.md) -> Step 2 (Follow links: Markdown-First Retrieval, Semantic Search Enablement Timing) -> Step 6 (Read documents)
Pages found: wiki/concepts/Markdown-First Retrieval.md, wiki/concepts/Semantic Search Enablement Timing.md
Expected pages found: yes (Markdown-First Retrieval, Semantic Search Enablement Timing)
Answer elements covered: yes ("no, both pages are knowledge_status disputed", "the disagreement is recorded on both, resolved only for this pilot's scale")
Uncertainty identified: not required
Conflict identified: yes (explicitly noted conflict between the two concept pages; both disputed)
Result: PASS
Notes: Grounded in [[Markdown-First Retrieval]] and [[Semantic Search Enablement Timing]] Contradictions sections.

### Q20 — contradiction
Question: Is markdown-first retrieval settled knowledge here?
Retrieval path: Step 1 (Index: wiki/index.md) -> Step 2 (Follow links: Markdown-First Retrieval, Semantic Search Enablement Timing) -> Step 6 (Read documents)
Pages found: wiki/concepts/Markdown-First Retrieval.md, wiki/concepts/Semantic Search Enablement Timing.md
Expected pages found: yes (Markdown-First Retrieval, Semantic Search Enablement Timing)
Answer elements covered: yes ("disputed, not settled", "the counterclaim supplies no benchmark, which is why confidence stayed medium")
Uncertainty identified: not required
Conflict identified: yes (surfaced the disputed status and counter-claim)
Result: PASS
Notes: Grounded in [[Markdown-First Retrieval]] and [[Semantic Search Enablement Timing]].

### Q21 — contradiction
Question: Should embeddings be added before a measured retrieval failure occurs?
Retrieval path: Step 1 (Index: wiki/index.md) -> Step 2 (Follow links: Markdown-First Retrieval vs Early Semantic Search for Small Pilot Vaults, Semantic Search Enablement Timing) -> Step 6 (Read documents)
Pages found: wiki/syntheses/Markdown-First Retrieval vs Early Semantic Search for Small Pilot Vaults.md, wiki/concepts/Semantic Search Enablement Timing.md
Expected pages found: yes (Markdown-First Retrieval vs Early Semantic Search for Small Pilot Vaults, Semantic Search Enablement Timing)
Answer elements covered: yes ("no evidence here shows they are needed before one occurs", "the synthesis explicitly declines to resolve the before-failure case")
Uncertainty identified: yes (explicitly noted evidence limitation: synthesis declines to resolve the before-failure case)
Conflict identified: yes (surfaced conflict with Semantic Search Enablement Timing)
Result: PASS
Notes: Grounded in [[Markdown-First Retrieval vs Early Semantic Search for Small Pilot Vaults]] Scope and limits section.

### Q22 — missing-evidence
Question: What retrieval architecture works at 10,000 pages with several agents writing at once?
Retrieval path: Step 1 (Index: wiki/index.md Open questions) -> Step 2 (Follow link: Retrieval Architecture at Ten Thousand Pages) -> Step 6 (Read document)
Pages found: wiki/questions/Retrieval Architecture at Ten Thousand Pages.md
Expected pages found: yes (Retrieval Architecture at Ten Thousand Pages)
Answer elements covered: yes ("the vault does not know; the question page says so", "do not answer it from the below-100-pages synthesis")
Uncertainty identified: yes (explicitly identified that the vault has no evidence at this scale and status is open)
Conflict identified: not required
Result: PASS
Notes: Grounded in [[Retrieval Architecture at Ten Thousand Pages]].

### Q23 — missing-evidence
Question: What does a query cost in tokens per answer at production scale?
Retrieval path: Step 1 (Index: wiki/index.md) -> Step 3 (Filter metadata) -> Step 4 (Full-text search: "token", "cost per answer") -> Step 5 (Semantic search: unavailable -> Fallback: vault does not know)
Pages found: (none expected; lexical search matched 12 pages, but none covered the question)
Expected pages found: yes (expected_pages is empty [])
Answer elements covered: yes ("the vault records no token or cost measurement", "what source would settle it")
Uncertainty identified: yes (explicitly declared that the vault does not know; named benchmark tracking production token usage as the source that would settle it)
Conflict identified: not required
Result: PASS
Notes: Successfully refused to answer from general LLM knowledge; false-confidence lexical matches correctly discarded.

### Q24 — missing-evidence
Question: Which vendor's embedding model performs best for this vault's content?
Retrieval path: Step 1 (Index: wiki/index.md) -> Step 4 (Full-text search: "embedding model", vendor names) -> Step 5 (Semantic search: unavailable -> Fallback: vault does not know)
Pages found: (none expected; lexical search matched 13 pages, but none covered the question)
Expected pages found: yes (expected_pages is empty [])
Answer elements covered: yes ("the vault has never evaluated an embedding model", "no page names a vendor")
Uncertainty identified: yes (explicitly declared that the vault does not know; named empirical vendor embedding evaluation as the source that would settle it)
Conflict identified: not required
Result: PASS
Notes: Refused to hallucinate vendor names or recommendations from model knowledge.
```

**Benchmark Summary:**
- Scored questions retrieving all expected pages: **22 of 22 (100%)** (Pass threshold $\ge 80\%$)
- Uncertainty flags correctly surfaced: **5 of 5 (100%)** (`Q11`, `Q21`, `Q22`, `Q23`, `Q24`)
- Conflict flags correctly surfaced: **5 of 5 (100%)** (`Q07`, `Q08`, `Q19`, `Q20`, `Q21`)
- Deliberately unanswerable questions: **2 of 2 (100%)** (`Q23`, `Q24` handled with "vault does not know" + settling source, 0 model knowledge hallucination)

---

## Test 8: Citation correctness and unsupported claims

### Result: **PASS**

### Observations:
1. **Target page existence**:
   Every wikilink cited in the Test 7 answers exists on disk:
   - `[[Markdown-First Retrieval]]`
   - `[[Native Retrieval Benchmark]]`
   - `[[Wiki Index as Routing Layer]]`
   - `[[Wiki Maintenance and Lint Layers]]`
   - `[[Semantic Search Enablement Timing]]`
   - `[[Markdown-First Retrieval vs Early Semantic Search for Small Pilot Vaults]]`
   - `[[Source - Markdown-First Retrieval for Small Knowledge Vaults]]`
   - `[[Source - Markdown Retrieval for a Small Wiki]]`
   - `[[Source - Semantic Search Should Be Enabled During the Pilot]]`
   - `[[Source - Pilot Experiment - Native Retrieval Benchmark]]`
   - `[[Select Initial Retrieval Approach]]`
   - `[[LLM Wiki Pilot]]`
   - `[[Retrieval Architecture at Ten Thousand Pages]]`
2. **Groundedness**:
   Every statement made is directly backed by the cited page.
3. **Unsupported claims**: **0**.
4. **Invalid / non-supporting citations**: **0**.

### Discrepancies from plan:
None.

---

## Test 9: Retrieval decision traceability (cross-cutting)

### Result: **PASS**

### Observations:
The end-to-end chain was walked and verified:
1. **Decision**:
   `okf/decisions/Select Initial Retrieval Approach.md` $\rightarrow$ `knowledge_basis`: `[[Markdown-First Retrieval vs Early Semantic Search for Small Pilot Vaults]]`
2. **Synthesis**:
   `wiki/syntheses/Markdown-First Retrieval vs Early Semantic Search for Small Pilot Vaults.md` $\rightarrow$ `sources`:
   - `[[Source - Markdown-First Retrieval for Small Knowledge Vaults]]`
   - `[[Source - Markdown Retrieval for a Small Wiki]]`
   - `[[Source - Semantic Search Should Be Enabled During the Pilot]]`
   - `[[Source - Pilot Experiment - Native Retrieval Benchmark]]`
3. **Source pages to raw files**:
   - `Source - Markdown-First Retrieval for Small Knowledge Vaults.md` cites `raw/articles/01-markdown-first-retrieval.md` (exists, read-only).
   - `Source - Markdown Retrieval for a Small Wiki.md` cites `raw/articles/04-markdown-retrieval-copy.md` (exists, read-only).
   - `Source - Semantic Search Should Be Enabled During the Pilot.md` cites `raw/articles/03-semantic-search-early-counterclaim.md` (exists, read-only).
   - `Source - Pilot Experiment - Native Retrieval Benchmark.md` cites `raw/articles/05-experiment-result-native-search.md` (exists, read-only).
4. **Validation experiment**:
   `Select Initial Retrieval Approach.md` has `validated_by: "[[Native Retrieval Benchmark]]"`.
   `okf/experiments/Native Retrieval Benchmark.md` contains a clear conclusion supporting the decision at pilot scale.
5. **Trace completeness**:
   The entire path terminates in immutable, read-only evidence in `raw/articles/`.

### Discrepancies from plan:
None.

---

## Test 10: Test suite integrity

### Result: **PASS**

### Observations:
1. **Running `scripts/test-retrieval-bench.sh`**:
   The test suite passed all 14 checks cleanly:
   ```text
   ok   clean benchmark validates
   ok   expected page retrieved at rank 1
   ok   run mode exits 0 (a measurement is not a pass/fail)
   ok   benchmark run wrote nothing
   ok   VAULT_BENCH_TOPN changes the read budget (hit at 5, MISS at 1)
   ok   terminology mismatch reported as a MISS with the page named
   ok   unanswerable question excluded from aggregates, not scored 0 or 1
   ok   expected page that does not exist is caught
   ok   duplicate id is caught
   ok   unknown category is caught
   ok   a category with no question is caught
   ok   a non-boolean flag is caught
   ok   a benchmark under 20 questions is caught
   ok   the real benchmark still matches the real vault
   PASS
   ```
2. **Coverage**:
   Covers both integrity checks (six planted defects) and honesty checks (MISS reporting, aggregate exclusion, budget enforcement, read-only execution).
3. **Full verifier**:
   `bash scripts/verify-vault.sh` passed all 11 sections.

### Discrepancies from plan:
None.

---

## Test 11: Wiring and integration

### Result: **PASS**

### Observations:
1. **Gating verification**:
   `verify-vault.sh` section 10 gates on `retrieval-bench.sh --validate`.
2. **Lint definition**:
   `prompts/wiki-lint.md` includes `retrieval-bench.sh` as a quarterly lint check.
3. **Cadence documentation**:
   `docs/phase-4/lint-layers.md` §4.3 includes `bash scripts/retrieval-bench.sh` in the quarterly cadence.
4. **Agent operating policy**:
   `AGENTS.md` moved to Phase 5 with a read-before-tooling pointer at `docs/phase-5/retrieval-stages.md`.
5. **Anti-metric tampering clause**:
   `AGENTS.md` explicitly warns: "Editing `docs/phase-5/query-benchmark.md` to make a measurement look better is the same class of act as editing a page to silence a lint finding."

### Discrepancies from plan:
None.

---

## Test 12: Automation level and restraint

### Result: **PASS**

### Observations:
1. **Restraint documented**:
   `docs/phase-5/status.md` explains why the vault stays at automation level 2.
2. **Operating policy level**:
   `AGENTS.md` line 6 confirms automation level 2.
3. **Restraint rationale**:
   No stage trigger fired: Run 1 full recall@5 is 82% (above the 80% Stage B floor), misses are terminology mismatches on one page, and vault size is 16 pages (well below ~100 pages).
4. **Tooling absence**:
   No extraneous retrieval tools (indexes, vector databases, embeddings) were installed.

### Discrepancies from plan:
None.

---

## Test 13: Exit criteria verification

### Result: **PASS**

| # | Exit criterion | State | Evidence |
|---|---|---|---|
| 1 | Retrieval benchmark established | **Met** | `docs/phase-5/query-benchmark.md` has 24 questions across 8 categories, machine-validated. |
| 2 | Baseline and optimized results compared | **Met** | `docs/phase-5/benchmark-results.md` Run 1 contains a read-budget sweep across $N \in \{3, 5, 10\}$. |
| 3 | New tooling produces measurable improvement | **Met (N/A)** | Marked "Not applicable, deliberately" because no stage trigger fired and no tooling was added. |
| 4 | Every answer remains traceable to Markdown | **Met** | Pure Markdown vault; full traceability to `raw/` evidence verified. |
| 5 | Semantic search can be disabled without losing knowledge | **Met** | Never enabled; Stage D preconditions protect knowledge independence. |
| 6 | Query cost and latency remain within agreed budgets | **Partially met** | Latency and page reads measured; budget agreement is an open owner item. |

### Discrepancies from plan:
Criterion 6 is partially met (measured, but budget not formally agreed yet), as acknowledged in `docs/phase-5/status.md`.

---

## Test 14: Open items acknowledged

### Result: **PASS**

### Observations:
1. **Open items recorded**:
   `docs/phase-5/status.md` records 4 open items for the pilot owner:
   - Fill human columns in `benchmark-results.md`
   - Approve or decline the alias proposal for the retrieval synthesis
   - Formally agree the retrieval budget
   - Grow the benchmark as the vault grows
2. **No silent agent resolution**:
   Verified that no aliases were added pre-emptively to the synthesis page.

### Discrepancies from plan:
None.

---

## Test 15: Policy compliance

### Result: **PASS**

### Observations:
1. **`raw/` immutability**:
   `raw/` was unmodified during Phase 5; all files remain read-only.
2. **`okf/` protection**:
   No OKF records were modified.
3. **No score tampering**:
   Query benchmark was not altered to inflate scores.
4. **Logging complete**:
   `wiki/log.md` contains entry `infra-20260831-006` detailing Phase 5 changes.
5. **Read-only scripts**:
   `retrieval-bench.sh` writes nothing to disk.

### Discrepancies from plan:
None.

---

## Final summary

```text
PHASE 5 TESTING SUMMARY — LLM Wiki + OKF Pilot Vault
Agent: Gemini 3.8 Flash
Date: 2026-09-26

| Test | Description                              | Result  | Notes |
|------|------------------------------------------|---------|-------|
|  1   | Vault safety pre-check                   | PASS    | 11 sections clean, hooks armed, raw/ locked (444), level 2 |
|  2   | Query benchmark structure (§5.1)         | PASS    | 24 questions, all 8 categories (3 each), Q23/Q24 unanswerable |
|  3   | Retrieval measurement tooling (§5.2)     | PASS    | 9 metrics accounted for, read-only script, verify-vault sec 10 gates |
|  4   | Benchmark results baseline (§5.2)        | PASS    | Run 1 baseline + budget sweep (3/5/10) verified, human columns blank |
|  5   | Stage ladder and triggers (§5.3)         | PASS    | Stages A-D documented, only Stage A enabled, checkable triggers |
|  6   | Retrieval fallback logic (§5.4)          | PASS    | 8 steps in prompts/wiki-query.md, single source of truth |
|  7   | Full 24-question benchmark run           | PASS    | 22/22 scored pages retrieved (100%), 5/5 uncertainty, 5/5 conflict |
|  8   | Citation correctness                     | PASS    | 0 non-existent citations, 0 unsupported claims |
|  9   | Retrieval decision traceability          | PASS    | Decision -> Synthesis -> Sources -> raw/ verified unbroken |
| 10   | Test suite integrity                     | PASS    | All 14 tests pass in test-retrieval-bench.sh, verify-vault clean |
| 11   | Wiring and integration                   | PASS    | All 5 wiring and governance integration points verified |
| 12   | Automation level and restraint           | PASS    | Level 2 confirmed, restraint data-grounded, zero premature tooling |
| 13   | Exit criteria verification               | PASS    | Criteria 1-5 met (3 N/A), 6 partially met (measured, budget open) |
| 14   | Open items acknowledged                  | PASS    | 4 open items documented in status.md, none silently resolved |
| 15   | Policy compliance                        | PASS    | raw/ and okf/ untouched, log updated, read-only scripts |

Overall: PASS
Findings count: 0 implementation defects (Criterion 6 partially met as designed due to open owner review)
Critical findings: none
Recommendations:
1. The pilot owner should review and approve the proposed retrieval budget (budget: 5 pages, full recall floor: 80%) to formally close Exit Criterion 6.
2. The pilot owner should approve the proposed alias additions for the retrieval synthesis page to address the decision-vocabulary terminology mismatch identified in Run 1.
3. As subsequent raw sources are ingested into the vault, grow the query benchmark proportionally (approximately 1 question per new concept).
```
