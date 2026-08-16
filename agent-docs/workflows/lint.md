# Lint Workflow

## Scope

Load this document when the human asks to inspect Wiki quality, consistency, metadata, provenance, or links.

## Read-only authorization

A request to run Lint authorizes read-only analysis only. It does not authorize writing a report or applying fixes.

Lint may list raw paths and validate their existence but must not read all raw file contents unless the human explicitly approves that read-only scope.

## Checks

When applicable to the approved scope, check:

- Invalid YAML.
- Missing required metadata.
- Invalid metadata values.
- Non-list `tags` or `source_notes`.
- Broken internal links.
- Absolute or host-specific links.
- Duplicate Concepts.
- Orphan Wiki pages.
- Missing source notes or source links.
- Unsupported factual claims.
- Index omissions.
- Missing log entries.
- Inconsistent filenames and titles.
- AI-created pages marked `reviewed: true`.
- Manifest entries that do not match observable file changes.

Report findings in conversation unless report writing is separately approved.

## Writing a lint report

To write a report:

1. Propose one path under `operations/lint-reports/`.
2. Load `approval-protocol.md`, `validation-and-concurrency.md`, and `final-reporting.md`.
3. Show a file-level plan specifying that the report is the only target.
4. Obtain explicit approval.
5. Verify the target path does not exist unless the approved plan explicitly updates an existing report.
6. Write only the approved report.
7. Validate the report path and content.
8. Provide the final report.

Do not create or modify any other file unless a separate fix plan is approved. Do not automatically apply medium-risk or high-risk fixes.

A lint-report operation does not require a manifest unless the approved plan explicitly includes one.
