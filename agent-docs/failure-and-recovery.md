# Failure and Partial-Completion Handling

## Scope

Load this document when an operation stops, fails validation, encounters concurrent modification, or partially completes.

## Stop conditions

Stop when:

- Approved scope or file list is unclear.
- A target changed after planning or preflight.
- A required source cannot be read.
- YAML or required link validation fails.
- A reviewed-page conflict appears.
- An unapproved file or operation is required.
- Continuing would modify `raw/` or `dev/`.
- A prohibited Git command, unapproved network task, or unapproved installation is required.
- Continuing could cause data loss.

## Required response

After stopping:

1. State the point at which the operation stopped.
2. Report what completed successfully.
3. Report what did not complete.
4. List every file already created or modified.
5. List every planned file left unchanged.
6. Record failed or unperformed validation accurately.
7. Preserve any partial changes for human inspection.
8. Ask the human to inspect `git status` and `git diff`.
9. Propose a revised plan when appropriate.

## Prohibited recovery behavior

Do not use deletion, `git restore`, `git reset`, `git clean`, or another write operation to hide or automatically roll back partial work.

The human owns recovery and all Git write operations during Stage 1.
