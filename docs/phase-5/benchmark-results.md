# Retrieval benchmark results

One section per run. Plan §5.2. Script numbers come from `bash scripts/retrieval-bench.sh`; the
human columns are blank until a person fills them, deliberately — an estimated usefulness score is
worth less than an empty cell, the same reasoning that keeps the human-review-time column in
[phase-4/maintenance-log.md](../phase-4/maintenance-log.md) blank.

Cadence: quarterly, with the controls review
([phase-4/lint-layers.md §4.3](../phase-4/lint-layers.md#43-review-cadences)), plus any time the
retrieval decision is up for review or a Stage trigger looks close.

---

## Run 1 — 2026-08-31 · baseline · commit `34a5075`

First run. **This is the Phase 5 baseline**: Stage A only, nothing installed, no tuning applied.
Benchmark: 24 questions, 16 retrievable pages, corpus unchanged since Phase 4.

### Script measurements

| Read budget (top-N) | mean R-precision | mean recall@N | full recall@N | pages read to cover | median latency |
|---:|---:|---:|---:|---:|---:|
| 3 | 0.61 | 0.79 | 15 of 22 (68%) | 46 | 23 ms |
| **5 (default)** | **0.61** | **0.92** | **18 of 22 (82%)** | **59** | **22 ms** |
| 10 | 0.61 | 0.96 | 20 of 22 (91%) | 74 | 23 ms |

22 of 24 questions are scored; `Q23` and `Q24` have no expected pages by design and are excluded
rather than scored (see below). R-precision is budget-independent by definition, which is why it
does not move down the column.

**The budget sweep is the one baseline-vs-alternative comparison this run can honestly make**, and
it is a real one: going from 5 to 10 pages costs 15 extra page reads to convert 2 more questions,
while 3 to 5 converts 3 questions for 13. The default of 5 sits at the knee. No retrieval *tooling*
comparison exists yet, because no new tooling has been installed — which is the intended state, not
a gap: Stage B's trigger has not fired.

### Findings

1. **One page causes both remaining misses at every budget** — the synthesis
   `Markdown-First Retrieval vs Early Semantic Search for Small Pilot Vaults`, expected by `Q08`
   and `Q13`, ranks 12th and 13th of 16. Diagnosed rather than guessed: of `Q13`'s eight
   significant terms, the synthesis contains two (`knowledge`, `retrieval`) and never uses
   `decision`, `basis`, `accepted`, `approach`, or `initial`. It is reachable from the decision
   only through `knowledge_basis` and the index — which is Stage A working as designed, but it
   means a lexical-only agent would not find the vault's single most load-bearing conclusion when
   asked in decision vocabulary.

   This is the **terminology-mismatch** class, not a method limit — the same failure the pilot's own
   experiment `[[Native Retrieval Benchmark]]` recorded as one of its two, with the same recommended
   fix (add an alias). It is explicitly **not** a Stage B trigger.

   *Proposed, not applied* (a `wiki/` write, medium risk, needs a plan and approval): add aliases
   covering decision vocabulary to that synthesis, then re-run and record the before/after here.
   Nothing was edited to improve this number — tuning the vault to flatter its own first baseline
   would destroy the value of having a baseline.

2. **`Q04`, `Q06`, `Q15`, `Q22` score R-precision 0.00 with recall 1.00.** The expected page is
   found within the budget but is not the top hit. At R = 1 that metric is all-or-nothing, so this
   is a ranking observation, not a retrieval failure. Worth watching for a systematic pattern; four
   scattered cases at 16 pages is not one.

3. **The false-confidence surface is large.** The two deliberately unanswerable questions matched
   12 and 13 pages respectively, and their top hits (`Markdown-First Retrieval`,
   `Select Initial Retrieval Approach`) are plausible-looking and wrong. Lexical retrieval offers
   no signal at all that a question is unanswerable. Every defence here is in the query workflow's
   rules and the reviewer, none of it in retrieval — which is the argument for keeping the
   missing-evidence category in the benchmark permanently.

### Human-checked — not filled in

The script cannot score these; they need a reviewer running `/wiki-query` against the 24 questions
and reading the answers.

| Metric | Value | Notes |
|---|---|---|
| Citation correctness | — | every cited page exists *and* supports the sentence citing it |
| Unsupported-claim rate | — | claims with no cited page behind them |
| Answers correctly identifying uncertainty | — of 5 | `Q11`, `Q21`, `Q22`, `Q23`, `Q24` |
| Answers correctly identifying a conflict | — of 5 | `Q07`, `Q08`, `Q19`, `Q20`, `Q21` |
| Answers starting from the index | — of 24 | the retrieval step the proxy cannot see |
| Token consumption | — | the agent's own accounting |
| Human usefulness (1–5) | — | |
| Reviewer / date | — | |

Machine time for the full run: under 1 second per budget setting (3 runs, ~0.8 s each). Recording
it for the same reason Phase 4 records lint time: a measurement nobody can afford stops happening.
