# Knowledge Model and Canonicalization

## Scope

Load this document when a task concerns zone ownership, provenance, evidence classification, canonical Concepts, source relationships, `wiki/index.md`, or `wiki/log.md`.

## Knowledge zones

### `raw/`: evidence layer

`raw/` is immutable human-owned source evidence. A raw file may be cited or summarized into the Wiki but never changed by the agent.

A raw link identifies evidence. Copying raw content into a Wiki page is not a substitute for a source link.

### `dev/`: human working layer

`dev/` contains learning notes, projects, experiments, ADRs, debriefs, troubleshooting records, runbooks, and snippets. During Stage 1 it is read-only and cannot be promoted automatically.

Personal observations from `dev/` must remain recognizable as observations. Do not restate them as verified facts.

### `wiki/`: canonical layer

`wiki/` contains agent-maintained knowledge under human direction. Wiki content must preserve source traceability, uncertainty, and contradictions.

## Knowledge categories

When analyzing or writing, distinguish:

- **Verified fact:** directly supported by identified evidence.
- **Synthesis:** a reasoned combination of supported facts from one or more sources.
- **Personal observation:** a human-authored experience, opinion, or tentative conclusion.
- **Uncertainty:** a claim whose evidence is incomplete, ambiguous, or unverified.
- **Contradiction:** sources or pages that make incompatible claims.
- **Open question:** a matter the available evidence does not resolve.

Do not fabricate certainty, citations, resources, or consensus.

## Source traceability

Every factual Wiki page must contain source links. A short Stage 1 page may list them under `## Sources and citations`. When several sources support different claims, place the relevant source link near the supported claim when practical.

A Concept link expresses a knowledge relationship. It is not evidence unless that Concept itself traces the claim to sources.

## One Concept, one canonical page

Before creating a Concept page:

1. Read `wiki/index.md`.
2. Search existing Wiki filenames.
3. Search frontmatter titles.
4. Search tags.
5. Search relevant Wiki body text.
6. Inspect related Concept pages.
7. Test capitalization, singular/plural, abbreviation, synonym, and punctuation variants.
8. Prefer updating the existing page when it represents the same concept.
9. Create a new page only when no canonical page exists.

During Stage 1, identify suspected duplicates but do not merge, delete, rename, move, or create redirects for canonical pages.

## Reviewed knowledge

Prefer reviewed pages when answering. State when an important page is not human-reviewed.

Never silently change a reviewed conclusion. If new evidence conflicts with one, stop any affected write, preserve both positions in the analysis, and request human judgment.

## `wiki/index.md`

This is a human-initialized management file. With explicit approval, the agent may:

- Add an approved navigation entry.
- Update an approved navigation description required by the operation.
- Keep navigation concise.

It must not change ownership metadata or reviewed state, copy full Wiki content into the index, add unapproved entries, or remove entries without enhanced approval.

## `wiki/log.md`

This file is append-only. With explicit approval, the agent may append one concise operation entry.

It must not rewrite, reorder, delete, or alter previous entries, ownership metadata, or reviewed state.
