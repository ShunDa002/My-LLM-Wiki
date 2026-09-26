# Phase 5 retrieval: what is measured, what is enabled, and what falls back to what

Plan §5.2, §5.3, §5.4. Companion to [query-benchmark.md](query-benchmark.md) (the question set)
and [benchmark-results.md](benchmark-results.md) (the runs).

The one rule this phase exists to enforce: **retrieval tooling is added against a measured
failure, never on a schedule.** That is not a Phase 5 invention — it is the accepted decision
[[Select Initial Retrieval Approach]], whose review trigger is literally "repeated retrieval
failures that naming fixes do not resolve". Phase 5's job is to make that trigger observable
instead of rhetorical.

## 5.2 What is measured, and by what

| Metric (plan §5.2) | How | Who |
|---|---|---|
| Recall of expected pages | `recall@N` in `scripts/retrieval-bench.sh` — expected pages inside the top-N ranked candidates, N = read budget, default 5 | script |
| Precision of selected pages | `R-precision` — expected pages inside the top-R, where R is how many pages that question expects. Not precision@5, which would cap at 0.20 for a one-page question and measure the budget rather than the ranking | script |
| Number of files read | "pages read to cover" — the rank of the deepest expected page, or the full budget when a question misses | script |
| Query latency | per-question milliseconds and the median, for the lexical proxy only | script |
| Percentage of answers starting from the index | not measured by script, by construction: the proxy has no index step. It is the answer-log question in [benchmark-results.md](benchmark-results.md) | human |
| Citation correctness | every cited page must exist and must actually support the sentence citing it | human |
| Unsupported-claim rate | claims in the answer with no cited page behind them | human |
| Token consumption | the agent's own accounting for the run; no script sees it | human |
| Human usefulness score | 1–5, recorded per run | human |

### What the script measures is a floor, not a score

`retrieval-bench.sh` runs one layer: significant words from the question, fixed-string
case-insensitive match across the 16 retrievable pages, ranked by how many distinct question terms
each page matches. That is the *full-text search* step of the retrieval order — with the index and
wikilink hops deliberately removed, because those are the steps no shell script can reproduce.

So a `MISS` does not mean the query workflow would fail the question. It means that question's
answer depends entirely on the index entry and the wikilinks being right. That is a useful thing
to know per question, cheap, and identical run to run.

Two honest limits of the proxy, recorded so its numbers are not over-read:

- **It does not weight titles.** Real full-text search ranks a title match above a body match.
  Title weighting is the first Stage B candidate below, and it must be measured as a change (run
  before, run after, both recorded) rather than folded into the proxy — a proxy tuned until its
  own score rises measures the tuner.
- **It does not read `aliases`.** It does match them, since they sit in the frontmatter of the file
  being grepped, but it has no notion that an alias is a retrieval affordance. A page found only
  through its alias is indistinguishable here from one found through its body.

## 5.3 Stage ladder, and where this vault actually is

### Stage A — curated routing (**current, and the only stage enabled**)

`wiki/index.md`, domain descriptions, wikilinks, filename search, `grep`. All of it exists and all
of it is in use. Nothing was installed for Phase 5; the measurement was.

### Stage B — local Markdown indexing (not implemented)

A lightweight local full-text index with ranking (qmd or equivalent).

**Trigger, all of which must hold:** the benchmark's full-`recall@5` rate falls below 80% across
two consecutive quarterly runs, *and* the misses are not explained by a missing index entry or a
missing alias (the two causes that account for every retrieval failure this vault has recorded so
far, including both failures in its own pilot experiment), *and* the vault is above roughly 100
pages — the scope limit the accepted decision rests on.

**Cheaper thing to try first, in this order:** add the missing index entry; add an alias for the
terminology the question actually used; split an overloaded page. Each is a lint finding with an
owner, not an infrastructure change.

### Stage C — metadata-oriented retrieval (not implemented)

Obsidian Bases, Dataview, or SQLite over the frontmatter.

**Trigger:** a metadata question is asked repeatedly and answered by an ad-hoc script each time —
"which active pages rest on disputed knowledge", "which decisions are overdue for review". Note
that `scripts/lint-governance.sh` already answers both of those, which is exactly why this stage
is not needed yet: the reporting need was met by a 245-line read-only script instead of a query
engine. The trigger is a *third or fourth* such question, not the first.

### Stage D — semantic retrieval (not implemented, and the highest bar)

Embeddings and a vector index.

**Trigger:** Stage B is in place and the benchmark still shows repeated misses on questions whose
expected pages are semantically related but lexically disjoint — the failure mode
[[Semantic Search Enablement Timing]] asserts without evidence, which the benchmark would then be
supplying. Enabling it before that point is the exact move the accepted decision rejected, and the
counterclaim's own page records that it supplied no benchmark, cost model, or size threshold.

Non-negotiable if it is ever enabled, from plan §5.3:

- Markdown stays the source of truth.
- The vector index is disposable and rebuildable from Markdown alone.
- Semantic retrieval selects *candidates*; the answer still cites readable Wiki and source pages.
- An embedding hit is never evidence by itself.
- Deleting the index must lose no knowledge — that is the Phase 5 exit criterion "semantic search
  can be disabled without losing knowledge", and it is testable the day it is built.

### Why three of the four stages are empty, on purpose

Same restraint as Phase 2's deferred taxonomy folders and Phase 3's six deferred OKF types: a
folder, a field, or an index built ahead of the failure it answers is a thing to maintain, not a
capability. Each stage above has a named, checkable trigger instead of a date. The plan's own
§2.6 and §7's "tool overengineering" risk say the same thing.

## 5.4 The fallback order

**The operative order lives in [`prompts/wiki-query.md`](../../prompts/wiki-query.md).** It is not
restated here — a retrieval order in two files is the drift this vault removed everywhere else.
What follows is only the mapping from the plan's eight steps to their tooling status today.

| Plan §5.4 step | Status here |
|---|---|
| 1. Read index | Enabled. Step 1 of the workflow, unconditional. |
| 2. Follow explicit Wiki links | Enabled. |
| 3. Use metadata filters | Stage C, absent. Falls back to `grep` on the frontmatter field, which is what the lint scripts do. |
| 4. Use full-text search | Enabled — and it is the layer the benchmark measures. |
| 5. Use semantic retrieval if necessary | Stage D, absent. The fallback is to say the vault does not know and name the source that would settle it, which the query workflow already requires. |
| 6. Read selected documents | Enabled, bounded by the read budget the benchmark measures (`VAULT_BENCH_TOPN`). |
| 7. Verify against raw evidence for critical claims | Enabled, and `raw/` is read-only at the OS level, so verification cannot become mutation. `/wiki-trace` walks a claim to evidence. |
| 8. Answer with citations | Enabled, and the requirement predates Phase 5. |

A step whose tooling does not exist must degrade to the next thing that does exist and say so in
the answer. It must never degrade into the model's own knowledge — that failure is invisible in a
benchmark score, which is why steps 3 and 5 name their fallback explicitly here rather than
leaving it to judgement.

## Running it

```bash
bash scripts/retrieval-bench.sh              # validate, then measure and report
bash scripts/retrieval-bench.sh --validate   # integrity of the benchmark only
VAULT_BENCH_TOPN=3 bash scripts/retrieval-bench.sh   # tighter read budget
```

Read-only. `verify-vault.sh` section 10 runs `--validate` on every verification, so a page renamed
in `wiki/` breaks the benchmark loudly instead of showing up as a retrieval regression next
quarter. Quarterly cadence: [phase-4/lint-layers.md §4.3](../phase-4/lint-layers.md#43-review-cadences).
