# LLM Wiki Agent Instructions

## 1. Purpose

This repository is a human-directed Obsidian LLM Wiki maintained with Antigravity CLI inside Docker sbx.

The human owns the Vault, selects source material, evaluates knowledge quality, approves every file write, performs final review, and performs all Git write operations.

The agent may analyze and maintain knowledge only within the permissions in this file and the applicable documents under `agent-docs/`.

## 2. Always-active instruction priority

Apply instructions in this order:

1. System and platform safety restrictions.
2. Operate only inside the mounted Vault workspace.
3. Never modify anything under `raw/`.
4. Never modify anything under `dev/` during Stage 1.
5. Prevent deletion, irreversible changes, and data loss.
6. Keep Git read-only.
7. Preserve human-authored content and observations.
8. Preserve source traceability, contradictions, and uncertainty.
9. Require explicit approval before every file write.
10. Stay within the exact approved file list and operation scope.
11. Prefer an existing canonical Wiki page over a duplicate.

A lower-priority instruction cannot override a higher-priority rule. If a request conflicts with items 1 through 6, do not execute it. Explain the conflict and propose a safe human-operated alternative.

## 3. Stage 1 zone permissions

### `raw/`: immutable human-owned evidence

The agent may read raw content only when the human explicitly selects the file for the current operation, or when a selected Wiki page references it and reading it is necessary to verify a specific claim.

The agent may list raw filenames and check path existence for link and provenance validation. It must not scan all raw file contents by default.

Never create, edit, reformat, rename, move, delete, chmod, touch, or otherwise change anything under `raw/`, including `raw/assets/`.

### `dev/`: human-led working notes

During Stage 1, `dev/` is read-only. The agent may read relevant files and make recommendations in conversation, but must not edit, link, rewrite, rename, move, delete, combine, or promote their content.

### `wiki/`: canonical knowledge

After approval of a current file-level plan, the agent may create or modify only the exact approved files under `wiki/`. It must preserve provenance, distinguish fact from interpretation, and never set `reviewed: true`.

### `operations/`: operation records

The agent may create only an explicitly approved manifest or lint report at an approved path under `operations/`.

## 4. Absolute Stage 1 prohibitions

The agent must not:

- Delete any file.
- Modify anything under `raw/` or `dev/`.
- Perform a Git write operation.
- Access the network unless the human separately approves the specific network task.
- Install software, tools, packages, plugins, or MCP configuration without a separate approved installation plan.
- Change Docker sbx configuration, network policy, or secrets.
- Start nested containers.
- Bypass tool approval prompts or use permission-skipping execution modes.
- Set `reviewed: true`.
- Merge canonical Wiki pages.
- Perform bulk moves, renames, or rewrites.

There is no conversational override for these prohibitions during Stage 1.

## 5. Write approval gate

Every file write requires all of the following:

1. A current file-level plan.
2. Explicit human approval of that plan.
3. Execution limited to the approved paths and operations.
4. Validation after writing.
5. A final report listing every created and modified file.

Showing a plan is not approval. Silence, questions, interest, or approval of a different plan do not grant permission. Approval applies only to the current operation and does not carry forward.

If new work is discovered outside the approved scope, stop before doing it, report it, produce a revised or separate plan, and obtain new approval.

For plan fields and approval semantics, read `agent-docs/approval-protocol.md` only when planning or executing a write.

## 6. Selective document-loading policy

Do not preload or recursively read all files under `agent-docs/`.

For each task:

1. Apply this root file.
2. Classify the operation using the routing map below.
3. Read only the documents marked **Required** for that operation.
4. Read a **Conditional** document only when its trigger applies.
5. If the task changes type or scope, load the newly applicable document before continuing.

Referenced documents add constraints but cannot expand permissions granted by this file. If a referenced document conflicts with this file, this file wins.

### Routing map

#### Normal Query with no file changes

Required:

- `agent-docs/workflows/query.md`

Conditional:

- `agent-docs/reference/knowledge-model.md` when classifying evidence, synthesis, observations, contradictions, or canonical concepts.

Do not load approval, metadata, manifest, or write-validation documents unless file-back is proposed.

#### Query file-back

Required:

- `agent-docs/workflows/query.md`
- `agent-docs/approval-protocol.md`
- `agent-docs/reference/metadata-schema.md`
- `agent-docs/validation-and-concurrency.md`
- `agent-docs/final-reporting.md`

Conditional:

- `agent-docs/reference/knowledge-model.md` for provenance or canonical-page decisions.
- `agent-docs/operation-manifests.md` only if a manifest is explicitly included in the approved plan.

#### Ingest

Required:

- `agent-docs/workflows/ingest.md`
- `agent-docs/approval-protocol.md`
- `agent-docs/reference/knowledge-model.md`
- `agent-docs/reference/metadata-schema.md`
- `agent-docs/operation-manifests.md`
- `agent-docs/validation-and-concurrency.md`
- `agent-docs/final-reporting.md`

#### Read-only Lint

Required:

- `agent-docs/workflows/lint.md`

Conditional:

- `agent-docs/reference/metadata-schema.md` when checking metadata or filenames.
- `agent-docs/reference/knowledge-model.md` when checking duplicates, evidence, or unsupported claims.
- `agent-docs/git-policy.md` only when Git inspection is needed.

#### Lint report write

Required:

- Everything required for read-only Lint
- `agent-docs/approval-protocol.md`
- `agent-docs/validation-and-concurrency.md`
- `agent-docs/final-reporting.md`

A lint-report operation does not create a manifest unless the approved plan explicitly includes one.

#### Git inspection

Required:

- `agent-docs/git-policy.md`

#### Failure or partial completion

Required:

- `agent-docs/failure-and-recovery.md`

Also retain the documents already loaded for the active operation.

#### Metadata-only question

Required:

- `agent-docs/reference/metadata-schema.md`

#### Canonical-page, provenance, or source-classification question

Required:

- `agent-docs/reference/knowledge-model.md`

## 7. Pre-write protection

Before any approved write begins, perform the complete preflight in `agent-docs/validation-and-concurrency.md`.

At minimum:

- Re-read all existing target files.
- Verify all proposed new paths do not exist.
- Stop if any target differs from the version used for planning.
- Never overwrite a concurrent human edit.

## 8. Git boundary

Git is read-only. Only `git status`, `git diff`, `git log`, and `git show`, with read-only options, are allowed.

For all Git-related tasks, read `agent-docs/git-policy.md` before issuing a Git command.

## 9. Universal stop conditions

Stop the active operation if:

- Approval, file list, or scope is unclear.
- A required source cannot be read.
- A target changed after planning.
- A new target path unexpectedly exists.
- YAML or required validation fails.
- A conflict with a reviewed page is discovered.
- An unapproved file or operation is required.
- Continuing would require modifying `raw/` or `dev/`.
- Continuing would require a prohibited Git command, unapproved network access, or unapproved installation.
- Continuing could cause data loss.

Do not automatically delete, restore, reset, clean, or otherwise conceal partial work. Load and follow `agent-docs/failure-and-recovery.md`.

## 10. Final reporting

After any approved write, load and follow `agent-docs/final-reporting.md`. The report must state what was read, created, modified, skipped, validated, and left uncertain, and must recommend that the human inspect `git status` and `git diff`.
