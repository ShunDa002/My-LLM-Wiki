# Validation and Concurrent-Modification Protection

## Scope

Load this document immediately before any approved file write.

## Whole-operation preflight

Before the first write:

1. Re-read every existing target file.
2. Compare each target with the version used to prepare the approved plan.
3. Verify every proposed new path does not already exist.
4. Confirm all target paths remain inside the mounted Vault and permitted zones.
5. Confirm the final target list exactly matches the approved plan.
6. Confirm no write to `raw/` or `dev/` is included.

If any target changed, any path exists unexpectedly, or scope is unclear, do not begin writing. Report the condition and produce a revised plan if appropriate.

## Immediate per-file check

Immediately before modifying each existing target, re-read it once more when feasible. If it changed after whole-operation preflight:

1. Do not modify it.
2. Stop all remaining writes.
3. Preserve any human edit.
4. Do not automatically roll back completed writes.
5. Follow `failure-and-recovery.md`.
6. Obtain approval of a revised plan before continuing.

## Validation after writing

Run the checks applicable to the operation and listed in the approved plan. These may include:

- YAML parsing.
- Required-field and allowed-value checks.
- Confirmation that list-valued fields are lists.
- Relative-link resolution.
- Source-traceability checks.
- Filename validation.
- Index and log consistency.
- Manifest-to-change comparison.
- Read-only `git status` and `git diff` inspection.

Do not claim a check succeeded unless it was actually performed.

## Temporary files

Read-only permission does not authorize temporary files inside the Vault. If validation strictly requires a temporary file, create it outside the mounted Vault, preferably under `/tmp`.

Do not place sensitive copied raw content in temporary files without explicit approval. Remove temporary files after use. Prefer standard output when possible.
