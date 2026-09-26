# Phase 5 query benchmark

Plan §5.1. The fixed question set retrieval quality is measured against. Read-only data: nothing
in this file is a claim about the world, it is a claim about what *this vault* should be able to
retrieve.

Run it with `bash scripts/retrieval-bench.sh`. Results per run go in
[benchmark-results.md](benchmark-results.md); what each metric means and which ones a script
cannot measure is in [retrieval-stages.md](retrieval-stages.md#52-what-is-measured-and-by-what).

## Why 24 questions and not 50

The plan says 20 to 50. This vault holds 16 retrievable pages — 4 concepts, 1 synthesis, 1
question, 7 sources, 3 OKF records, plus `wiki/index.md` and `wiki/log.md`, which are routing and
history rather than answers and are excluded from the corpus. Fifty questions over 16 pages measures the question writer's patience, not retrieval: every page
would carry three questions and the expected-page sets would overlap so heavily that a single
badly-named page could swing the aggregate. 24 is three per category — enough that one bad
question cannot dominate its category, small enough that every question is about content that
actually exists.

**Grow this file when the vault grows.** The benchmark is only a benchmark against the vault it
was written for; a page added without a question is a page the benchmark cannot see, and the
20-source criterion in Phase 2 will add plenty. Two of the questions below (`Q23`, `Q24`) are
deliberately unanswerable and must stay that way — see the last category.

## Format

One fenced `yaml` block per question, parsed by `scripts/retrieval-bench.sh`. Fields are the
plan's, plus `id` and `category` so findings can be attributed.

- `expected_pages` — page **titles** (the basename, no folder, no `.md`). Every one must exist in
  the vault; `--validate` fails if it does not, because a benchmark that cites a deleted page
  reports a retrieval failure that is really a benchmark defect.
- `expected_answer_elements` — what a correct answer must contain. **Human-checked.** No script
  reads the agent's answer.
- `must_identify_uncertainty` / `must_identify_conflict` — the answer has to say "the vault does
  not know" or "the vault records both sides". Also human-checked; the script only counts how many
  questions carry the flag, so a reviewer knows how many answers to read for it.

## Direct factual lookup

```yaml
id: Q01
category: factual
question: Below what page count does markdown-first retrieval claim to hold?
expected_pages:
  - Markdown-First Retrieval
expected_answer_elements:
  - roughly 100 pages
  - the source declines to give an exact number
must_identify_uncertainty: false
must_identify_conflict: false
```

```yaml
id: Q02
category: factual
question: What median retrieval time did the native retrieval benchmark experiment record?
expected_pages:
  - Native Retrieval Benchmark
expected_answer_elements:
  - 11 seconds
  - synthetic test data
must_identify_uncertainty: false
must_identify_conflict: false
```

```yaml
id: Q03
category: factual
question: Where does operational history belong, and where does it not belong?
expected_pages:
  - Wiki Index as Routing Layer
expected_answer_elements:
  - wiki/log.md holds operational history
  - the index is navigation, not history
must_identify_uncertainty: false
must_identify_conflict: false
```

## Concept explanation

```yaml
id: Q04
category: concept
question: What is the index meant to contain as a routing layer, and what does it exclude?
expected_pages:
  - Wiki Index as Routing Layer
expected_answer_elements:
  - wikilink plus one-sentence description
  - not every page, not full summaries
must_identify_uncertainty: false
must_identify_conflict: false
```

```yaml
id: Q05
category: concept
question: How do structural lint findings differ from semantic lint findings?
expected_pages:
  - Wiki Maintenance and Lint Layers
expected_answer_elements:
  - structural may eventually be auto-repaired
  - semantic contradictions and merges escalate to a human
must_identify_uncertainty: false
must_identify_conflict: false
```

```yaml
id: Q06
category: concept
question: What position does semantic search enablement timing take, and what evidence backs it?
expected_pages:
  - Semantic Search Enablement Timing
expected_answer_elements:
  - embeddings from day one, unconditionally
  - no benchmark, cost model, or size threshold
must_identify_uncertainty: false
must_identify_conflict: false
```

## Comparison

```yaml
id: Q07
category: comparison
question: For a pilot vault under 100 pages, curated navigation or embeddings from day one?
expected_pages:
  - Markdown-First Retrieval vs Early Semantic Search for Small Pilot Vaults
  - Markdown-First Retrieval
expected_answer_elements:
  - start with curated navigation and text search
  - add embeddings after a measured failure
must_identify_uncertainty: false
must_identify_conflict: true
```

```yaml
id: Q08
category: comparison
question: How do the two retrieval positions differ in the evidence each one offers?
expected_pages:
  - Markdown-First Retrieval vs Early Semantic Search for Small Pilot Vaults
  - Semantic Search Enablement Timing
  - Markdown-First Retrieval
expected_answer_elements:
  - one side has a scale condition, a trigger condition, and a benchmark
  - the other side has none of the three
must_identify_uncertainty: false
must_identify_conflict: true
```

```yaml
id: Q09
category: comparison
question: What are the strengths and weaknesses of enabling embeddings on day one?
expected_pages:
  - Semantic Search Enablement Timing
  - Markdown-First Retrieval vs Early Semantic Search for Small Pilot Vaults
expected_answer_elements:
  - may catch phrasing mismatches lexical search misses
  - reliability is undefined and unmeasured
must_identify_uncertainty: false
must_identify_conflict: false
```

## Cross-source synthesis

```yaml
id: Q10
category: cross-source
question: How many independent sources support the markdown-first claim, and what was measured?
expected_pages:
  - Markdown-First Retrieval
  - Source - Pilot Experiment - Native Retrieval Benchmark
expected_answer_elements:
  - two independent sources plus one benchmark
  - 18 of 20 questions retrieved all expected pages at 42 pages
must_identify_uncertainty: false
must_identify_conflict: false
```

```yaml
id: Q11
category: cross-source
question: What retrieval evidence does this vault hold in total, across sources and experiments?
expected_pages:
  - Markdown-First Retrieval vs Early Semantic Search for Small Pilot Vaults
  - Markdown-First Retrieval
  - Native Retrieval Benchmark
expected_answer_elements:
  - four source pages, one benchmark experiment
  - all of it synthetic pilot fixtures
must_identify_uncertainty: true
must_identify_conflict: false
```

```yaml
id: Q12
category: cross-source
question: Why is the retrieval synthesis confidence medium rather than high?
expected_pages:
  - Markdown-First Retrieval vs Early Semantic Search for Small Pilot Vaults
expected_answer_elements:
  - all four inputs are synthetic test fixtures
  - internal consistency does not raise it above medium
must_identify_uncertainty: false
must_identify_conflict: false
```

## Decision traceability

```yaml
id: Q13
category: traceability
question: What knowledge basis supports the accepted decision on the initial retrieval approach?
expected_pages:
  - Select Initial Retrieval Approach
  - Markdown-First Retrieval vs Early Semantic Search for Small Pilot Vaults
expected_answer_elements:
  - one synthesis as knowledge_basis
  - traceable through source pages to raw files
must_identify_uncertainty: false
must_identify_conflict: false
```

```yaml
id: Q14
category: traceability
question: Which experiment validates the retrieval decision, and what did it conclude?
expected_pages:
  - Native Retrieval Benchmark
  - Select Initial Retrieval Approach
expected_answer_elements:
  - Native Retrieval Benchmark, status complete
  - sufficient at this pilot's scale, not a general capacity claim
must_identify_uncertainty: false
must_identify_conflict: false
```

```yaml
id: Q15
category: traceability
question: When is the retrieval decision due for review, and what would trigger an early review?
expected_pages:
  - Select Initial Retrieval Approach
expected_answer_elements:
  - 2026-09-24
  - repeated retrieval failures that naming fixes do not resolve
must_identify_uncertainty: false
must_identify_conflict: false
```

## Project impact

```yaml
id: Q16
category: impact
question: Which project is informed by the retrieval synthesis?
expected_pages:
  - LLM Wiki Pilot
expected_answer_elements:
  - LLM Wiki Pilot, via informed_by
must_identify_uncertainty: false
must_identify_conflict: false
```

```yaml
id: Q17
category: impact
question: If markdown-first retrieval were superseded, which OKF records would need review?
expected_pages:
  - Select Initial Retrieval Approach
  - LLM Wiki Pilot
  - Native Retrieval Benchmark
expected_answer_elements:
  - the accepted decision, the project informed by the synthesis, the validating experiment
  - propose review, never change status
must_identify_uncertainty: false
must_identify_conflict: false
```

```yaml
id: Q18
category: impact
question: What is the pilot project's goal, and what does its status note record?
expected_pages:
  - LLM Wiki Pilot
expected_answer_elements:
  - prove one safe complete knowledge-to-action cycle
  - Phase 1 walkthrough with 7 synthetic sources
must_identify_uncertainty: false
must_identify_conflict: false
```

## Contradiction detection

```yaml
id: Q19
category: contradiction
question: Does this vault agree on when semantic search should be enabled?
expected_pages:
  - Markdown-First Retrieval
  - Semantic Search Enablement Timing
expected_answer_elements:
  - no, both pages are knowledge_status disputed
  - the disagreement is recorded on both, resolved only for this pilot's scale
must_identify_uncertainty: false
must_identify_conflict: true
```

```yaml
id: Q20
category: contradiction
question: Is markdown-first retrieval settled knowledge here?
expected_pages:
  - Markdown-First Retrieval
  - Semantic Search Enablement Timing
expected_answer_elements:
  - disputed, not settled
  - the counterclaim supplies no benchmark, which is why confidence stayed medium
must_identify_uncertainty: false
must_identify_conflict: true
```

```yaml
id: Q21
category: contradiction
question: Should embeddings be added before a measured retrieval failure occurs?
expected_pages:
  - Markdown-First Retrieval vs Early Semantic Search for Small Pilot Vaults
  - Semantic Search Enablement Timing
expected_answer_elements:
  - no evidence here shows they are needed before one occurs
  - the synthesis explicitly declines to resolve the before-failure case
must_identify_uncertainty: true
must_identify_conflict: true
```

## Missing-evidence recognition

The category that catches the failure mode this vault fears most: a confident answer assembled
from pages whose scope does not cover the question. `Q23` and `Q24` have **no** expected pages on
purpose. They are not broken entries — a retrieval score against them is only interesting as a
measure of how much false confidence lexical search offers.

```yaml
id: Q22
category: missing-evidence
question: What retrieval architecture works at 10,000 pages with several agents writing at once?
expected_pages:
  - Retrieval Architecture at Ten Thousand Pages
expected_answer_elements:
  - the vault does not know; the question page says so
  - do not answer it from the below-100-pages synthesis
must_identify_uncertainty: true
must_identify_conflict: false
```

```yaml
id: Q23
category: missing-evidence
question: What does a query cost in tokens per answer at production scale?
expected_pages: []
expected_answer_elements:
  - the vault records no token or cost measurement
  - what source would settle it
must_identify_uncertainty: true
must_identify_conflict: false
```

```yaml
id: Q24
category: missing-evidence
question: Which vendor's embedding model performs best for this vault's content?
expected_pages: []
expected_answer_elements:
  - the vault has never evaluated an embedding model
  - no page names a vendor
must_identify_uncertainty: true
must_identify_conflict: false
```
