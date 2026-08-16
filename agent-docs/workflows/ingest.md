# Stage 1 Ingest Workflow

## Scope and trigger

Load this document only when the human asks to ingest a source into the Wiki. Stage 1 processes exactly one explicitly selected source per Ingest.

Also load the documents listed for Ingest in the root `AGENTS.md`.

## Phase 1: Exploration, read-only

1. Confirm the exact selected source.
2. Read only that source under `raw/` or the exact approved source location.
3. Read `wiki/index.md`.
4. Search relevant files under `wiki/`.
5. Identify related canonical Concepts.
6. Identify claims directly supported by the source.
7. Separate facts, synthesis, observations, uncertainty, contradictions, and open questions.
8. Determine whether the source is readable enough to ingest.

Do not modify files during exploration.

## Phase 2: Planning

Produce a file-level plan under `approval-protocol.md` that includes:

- The single source file.
- One proposed source-summary page under `wiki/sources/`.
- Existing Concepts proposed for update.
- New Concepts proposed for creation.
- Approved navigation section changes in `wiki/index.md`.
- One proposed append-only entry for `wiki/log.md`.
- One manifest path under `operations/manifests/`.
- Proposed metadata and links.
- Uncertainty, contradictions, and human decisions required.
- Validation steps.

Prefer updating an existing canonical Concept over creating a duplicate.

## Phase 3: Approval

Wait for explicit approval of the current plan. Approval applies only to listed paths and operations.

## Phase 4: Preflight

Follow `validation-and-concurrency.md` before writing anything. Re-read all existing targets as one preflight pass and verify all new paths do not exist.

If a target changed or a path exists unexpectedly, stop without beginning the write phase.

## Phase 5: Execution

Within the approved scope:

1. Create the approved source-summary page.
2. Update approved existing Concepts before creating approved new Concepts.
3. Preserve uncertainty and contradictions.
4. Add traceable source links.
5. Update only approved navigation sections of `wiki/index.md`.
6. Append exactly one approved entry to `wiki/log.md`.
7. Create exactly one operation manifest.
8. Do not perform additional useful work outside the plan.

If new work becomes necessary, stop before performing it and request a revised plan.

## Phase 6: Validation

At minimum:

- Parse YAML frontmatter in every created or modified Wiki page.
- Check required fields and allowed values.
- Confirm `tags` and `source_notes` are lists.
- Validate created or modified relative links.
- Confirm every factual page has source traceability.
- Confirm new filenames use lowercase kebab-case.
- Compare manifest entries with actual changed paths.
- Use read-only Git inspection if available and permitted.

A failed required validation stops the operation. Follow `failure-and-recovery.md`.

## Phase 7: Final report

Follow `final-reporting.md` and recommend that the human inspect `git status` and `git diff`.
