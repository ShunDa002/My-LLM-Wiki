# Agent Documentation Map

This directory contains detailed policies and procedures referenced by the root `AGENTS.md`.

## Loading rule

Do not read this directory recursively. Start with the root `AGENTS.md`, classify the current operation, then open only the required and triggered documents.

## Policy documents

- `approval-protocol.md`: Load before planning, approving, or executing any write.
- `git-policy.md`: Load before issuing any Git command.
- `operation-manifests.md`: Load for every Ingest; otherwise only when a manifest is included in the plan.
- `validation-and-concurrency.md`: Load before every approved write.
- `failure-and-recovery.md`: Load when an operation stops, fails, or partially completes.
- `final-reporting.md`: Load after any approved write.

## Workflow documents

- `workflows/ingest.md`: One-source Stage 1 Ingest.
- `workflows/query.md`: Read-only Query and separately approved Query file-back.
- `workflows/lint.md`: Read-only Lint and separately approved lint-report writing.

## Reference documents

- `reference/knowledge-model.md`: Zones, provenance, canonical concepts, index, and log semantics.
- `reference/metadata-schema.md`: Frontmatter, filenames, links, and page-type rules.

## Templates

Templates are loaded only when producing the corresponding artifact:

- `templates/file-level-plan.md`
- `templates/operation-manifest.md`
- `templates/final-report.md`
