# Workflow: answer a question from vault knowledge

Agent-neutral definition. Claude Code users have `/wiki-query`; other agents read this file.

**Input:** a question.
**Minimum tools:** read files, search text. **No write tools.** This workflow is read-only by
design; the file-back step below only *proposes*.

Answer from what the vault records — not from what the model knows. If the vault does not contain
it, say so. That is a useful answer, and inventing one destroys the point of a cited knowledge
base.

## Retrieval order

Fall through it in order. Stop as soon as the answer is grounded — the order is a fallback chain,
not a checklist to complete.

1. `wiki/index.md` — start here, always
2. Follow wikilinks from whatever the index points at
3. Filter on frontmatter when the question is about metadata rather than content
   (`knowledge_status`, `status`, `review_date`, `type`) — `grep` on the field. There is no query
   engine; Stage C in [docs/phase-5/retrieval-stages.md](../docs/phase-5/retrieval-stages.md) says
   why not, and what would justify one.
4. Search the Wiki full-text for terms from the question, including `aliases`
5. Semantic retrieval — **not available in this vault.** No embeddings, no vector index, by an
   accepted decision. When steps 1-4 come up short, the answer is "the vault does not know" plus
   the source that would settle it. It is never the model's own knowledge dressed as a recorded
   claim; that failure is invisible in every benchmark score, which is why it is named here.
6. Read a small number of the best candidates, not everything that matched
7. Expand into `raw/` only when the Wiki is insufficient, or a critical claim needs verification
   against original evidence
8. Answer with citations

If a question needed step 4 or later, say so — a query that routes through the index and links
alone is the retrieval approach working, and one that repeatedly falls to full-text search is the
signal [docs/phase-5/retrieval-stages.md](../docs/phase-5/retrieval-stages.md) measures. Repeated
failures that naming and index fixes do not resolve are the documented trigger for reviewing the
retrieval decision, so they are worth reporting rather than absorbing.

Create no files.

## Answer conventions

Label where each part of the answer comes from:

```text
Recorded knowledge:
Per [[Knowledge Compilation]], ...

Cross-source inference:
Inferring from [[Concept A]] and [[Concept B]], ...     <- your reasoning, not a recorded claim

Evidence limitation:
The vault does not currently contain evidence for ...

Contradiction:
[[Source A]] supports X, while [[Source B]] supports Y. Not resolved in the vault.
```

Rules:

- Cite every supporting page with a wikilink.
- Mark inference as inference. A conclusion you drew is not a claim the vault makes.
- Surface contradictions rather than picking a winner.
- If the honest answer is "the vault does not know", give it, and say what source would settle it.

## After answering — classify the result

State which one, and why:

```text
Ephemeral   — a lookup, answered and done. Do not save.
Reusable    — a durable comparison, trade-off, or cross-source conclusion. Propose a synthesis.
Actionable  — reusable, and it bears on live work. Propose a synthesis plus an OKF link.
```

Most answers are ephemeral. Saving them all recreates the clipping archive the Wiki exists to
replace.

For `Reusable` or `Actionable`, propose — do not create:

```text
FILE-BACK PROPOSAL

Create:
- wiki/syntheses/<Title>.md

Question it answers:
- <the durable question>

Based on:
- [[Concept A]], [[Concept B]]

Sources:
- [[Source - A]], [[Source - B]]        <- two or more, or it is a summary not a synthesis

Confidence: low | medium | high
Scope limit: <where this stops holding>

OKF relevance (Actionable only):
- [[<project / decision / experiment>]]

Index: <entry to add>
Log:   <operation-id to append>

Approval required.
```

On approval: write the synthesis from `templates/synthesis.md`, add the index entry, append to
`wiki/log.md`, and report the files changed.
