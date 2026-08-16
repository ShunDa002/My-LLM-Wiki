# File-Level Approval Protocol

## Scope

Load this document only when a task may create or modify a file. It does not apply to a normal read-only Query or read-only Lint.

## Separation of phases

Planning and execution are distinct phases. Do not write while exploring or planning. Showing a plan does not grant permission to execute it.

## Required plan contents

A file-level plan must state:

1. Operation type.
2. Source files to be read.
3. Every file proposed for creation.
4. Every file proposed for modification.
5. The exact intended change to each target.
6. Proposed metadata for new or metadata-changing Wiki pages.
7. Source and internal links to add or change.
8. Information that remains uncertain.
9. Contradictions or decisions requiring human judgment.
10. Validation to run after writing.
11. Any necessary work that is not permitted or not included.

Use `templates/file-level-plan.md` when a structured plan is useful.

## Valid approval

Approval must clearly refer to the current displayed plan or explicitly identify its approved subset. Examples:

- "Approve the proposed ingest plan."
- "Approve creation of the two proposed Wiki pages."
- "Approve the plan except the optional Concept page."
- "Apply only the approved changes listed above."

## Invalid approval

The following are not approval:

- Silence or no response.
- "Looks interesting."
- "Continue explaining."
- "What happens next?"
- A request to revise or clarify the plan.
- Approval of a previous or different plan.
- Approval given before the current plan was shown.

When uncertain, treat the response as non-approval and continue in conversation only.

## Closed scope

The approved file list and operations are closed boundaries. Do not create or modify an extra file because it appears useful.

If new work is discovered:

1. Stop before performing it.
2. Report the requirement.
3. Produce a revised plan or a separate plan.
4. Obtain explicit approval.

If the human changes scope, restate the final scope or issue a revised plan before execution.

Approval applies only to the current operation. It does not authorize future Ingest, Query file-back, lint fixes, reports, promotion, or cleanup.

## Approval levels

### Standard file-level approval

Required for low-risk, permitted writes such as:

- Creating a draft Source, Concept, or Synthesis page.
- Updating an approved AI-owned draft.
- Updating an approved navigation section of `wiki/index.md`.
- Appending one approved entry to `wiki/log.md`.
- Creating an approved manifest or lint report.
- Fixing an obvious YAML formatting defect in an approved AI-owned draft.

### Enhanced file-level approval

Required for a permitted medium-risk change such as:

- Rewriting a substantial part of an existing draft Wiki page.
- Modifying multiple Concept pages.
- Changing `status` or `confidence`.
- Updating a human-reviewed page without changing a reviewed conclusion.

An enhanced plan must additionally include:

- A before-and-after summary for every affected file.
- The exact reviewed text or metadata that might be affected.
- Why the change cannot be handled as a smaller additive update.
- Expected impact on incoming links and canonical meaning.
- Human-operated recovery steps if the outcome is rejected.
- An explicit statement that no reviewed conclusion will be altered.

Approval must name or unmistakably include the medium-risk action.

### High-risk actions

High-risk actions are not executable by the agent during Stage 1, including deletion, canonical-page merging, reversal of reviewed conclusions, accepted ADR replacement, approved runbook modification, bulk moves, bulk rewrites, and canonical Concept ID changes.

The agent may explain the impact and present exact human-operated steps, but it must not execute them.

## Reviewed-page boundary

An approved Stage 1 update to a reviewed page may add sources, links, or clearly separated supplementary information only when the approved plan identifies those additions.

The agent must not remove, rewrite, weaken, or reverse a reviewed conclusion. Such a change is high-risk and must be performed by the human.
