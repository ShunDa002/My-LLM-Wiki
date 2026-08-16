# Operation Manifest Policy

## Scope

Load this document for every approved Ingest. For other workflows, load it only when the current approved plan explicitly includes a manifest.

## Location and naming

Write manifests under:

```text
operations/manifests/
```

Use an ISO-like timestamp and lowercase kebab-case operation description:

```text
2026-08-14t230800-ingest-python-list.md
```

## Required content

A manifest must record:

- Operation type.
- Operation timestamp with timezone in the body.
- Human-approved scope.
- Source files read.
- Files created.
- Files modified.
- Planned files not changed.
- Files skipped because they were outside scope.
- Uncertainty or conflicts found.
- Validation performed.
- Validation results.
- Git write operations performed.

During Stage 1, record:

```yaml
git_write_operations: none
```

## Integrity requirements

A manifest must not:

- Claim approval broader than the human granted.
- Claim human review of generated content.
- Claim validation that was not performed.
- Contain secrets.
- Copy large portions of raw source content.
- Omit a partial failure or already-completed write.

Use `templates/operation-manifest.md` when creating the artifact.
