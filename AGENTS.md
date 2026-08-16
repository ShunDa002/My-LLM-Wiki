# LLM Wiki Operating Rules

## 1. Purpose

This workspace is a human-directed Obsidian LLM Wiki maintained with
Antigravity CLI running inside Docker sbx.

The human owns the Vault, selects the source material, evaluates knowledge
quality, grants write approval, performs final review, and makes all final
decisions.

The agent performs structured knowledge analysis and maintenance only within
the boundaries defined in this file.

The goals of Stage 1 are to establish a minimal, controlled workflow for:

- Reading one source at a time
- Planning an ingest operation
- Creating traceable draft Wiki pages
- Querying the Wiki without automatic file-back
- Producing lint reports
- Reviewing every file change before Git commit

## 2. Runtime and security boundary

Antigravity CLI runs inside a Docker sbx microVM.

Docker sbx is the infrastructure isolation boundary. It protects the host
outside the mounted workspace.

The mounted Obsidian Vault remains writable. Changes made inside the mounted
Vault are synchronized back to the host.

Therefore, Docker sbx isolation does not grant permission to modify every file
inside the Vault.

The agent must:

- Operate only inside the mounted Vault workspace.
- Never inspect, enumerate, or search for host paths outside the workspace.
- Never attempt to discover host credentials, host services, or unrelated mounted resources.
- Never change Docker sbx configuration.
- Never change Docker sbx network policies.
- Never create, read, update, expose, or delete Docker sbx secrets.
- Never bypass Antigravity tool approval prompts.
- Never use an unrestricted, dangerous, or permission-skipping execution mode.
- Never install software, plugins, packages, or tools unless the human has approved a separate installation plan.
- Never start nested containers during Stage 1.
- Never access external websites or perform network research unless the human has explicitly approved that specific network task.

Docker sbx protects the host, while this file, human approval, and Git protect
the knowledge stored inside the writable Vault.

## 3. Instruction priority

When instructions appear to conflict, apply the following priority order:

1. Follow system and platform safety restrictions.
2. Operate only inside the mounted Vault workspace.
3. Never modify anything under `raw/`.
4. Prevent deletion, irreversible changes, and data loss.
5. Obey the Stage 1 Git read-only policy.
6. Preserve human-authored content and observations.
7. Preserve source traceability.
8. Require explicit approval before every file write.
9. Stay within the exact approved file list and operation scope.
10. Prefer updating an existing canonical page over creating a duplicate.
11. Preserve uncertainty rather than inventing certainty.

A lower-priority instruction must never override a higher-priority rule.

If a human request conflicts with rules 1 through 6, the agent must not execute
the request. The agent should explain the conflict and propose a safe,
human-operated alternative.

## 4. Stage 1 effective permissions

During Stage 1, the following permissions apply.

### Allowed without file-change approval

Subject to normal Antigravity tool permission prompts, the agent may:

- Read files inside the mounted Vault.
- List directories inside the mounted Vault.
- Search filenames and text inside the mounted Vault.
- Inspect Markdown links.
- Inspect YAML frontmatter.
- Analyze metadata and relationships.
- Produce plans and recommendations in the conversation.
- Run the approved read-only Git commands listed in the Git policy.

### Allowed only after explicit file-level approval

The agent may perform only the exact approved actions, including:

- Create approved files under `wiki/`.
- Modify approved draft files under `wiki/`.
- Update the approved navigation sections of `wiki/index.md`.
- Append one approved entry to `wiki/log.md`.
- Create one approved operation manifest under `operations/manifests/`.
- Create one approved lint report under `operations/lint-reports/`.

### Prohibited during Stage 1

The following actions are prohibited even if they would normally be classified
as medium or high risk:

- Any modification under `raw/`.
- Any modification under `dev/`.
- Any file deletion.
- Any Git write operation.
- Any network research that has not been separately approved.
- Any tool or package installation that has not been separately approved.
- Any MCP or plugin configuration.
- Any Docker sbx policy or secret operation.
- Any nested container execution.
- Setting `reviewed: true`.
- Merging canonical Wiki pages.
- Bulk file moves, renames, or rewrites.

Risk classification does not override Stage 1 prohibitions.

If a prohibited operation is necessary, the agent must explain the proposed
operation and ask the human to perform it manually on the host or defer it to
a later project stage.

## 5. Knowledge zones

The Vault has three knowledge zones:

- `raw/`: human-owned immutable source evidence
- `dev/`: human-led working and learning notes
- `wiki/`: agent-maintained canonical knowledge

Each zone has different ownership and write rules.

## 6. Zone ownership

### 6.1 `raw/`

`raw/` is the immutable evidence layer and source of truth.

The agent may:

- Read an explicitly specified raw file during Ingest.
- Read a raw file already referenced by a selected Wiki page during Query verification.
- Search raw paths only within a read-only scope explicitly authorized by the human.
- Cite raw files.
- Create Wiki pages based on raw files.
- Report metadata, readability, or formatting problems without correcting them.

The agent must never:

- Edit a raw file.
- Reformat a raw file.
- Add metadata to an existing raw file.
- Add an ingest marker to a raw file.
- Rename a raw file.
- Move a raw file.
- Delete a raw file.
- Modify file permissions under `raw/`.
- Modify timestamps under `raw/`.
- Change anything under `raw/assets/`.

Treat every file under `raw/` as immutable even when filesystem permissions
technically allow writing.

If a raw file must be corrected, renamed, moved, or deleted, the human must
perform that operation directly on the host after reviewing the impact.

The agent may explain the required human operation, but it must not execute it.

### 6.2 `dev/`

`dev/` is a human-led collaboration area for learning notes, projects,
experiments, ADRs, debriefs, troubleshooting records, runbooks, and reusable
snippets.

During Stage 1, `dev/` is read-only for the agent.

The agent may:

- Read an explicitly relevant dev file.
- Analyze dev content.
- Suggest improvements in the conversation.
- Identify related Wiki concepts.
- Recommend future promotion candidates.
- Identify conflicts between a dev note and existing Wiki knowledge.

During Stage 1, the agent must not:

- Edit a dev note.
- Add links to a dev note.
- Add or change metadata in a dev note.
- Rewrite a dev note.
- Rename or move a dev note.
- Combine dev notes.
- Remove personal observations.
- Promote dev content into `wiki/`.

A later project stage may introduce a separately reviewed Promote workflow and
a new write policy for `dev/`.

### 6.3 `wiki/`

`wiki/` is the canonical knowledge layer maintained by the agent under human
direction.

After an approved file-level plan, the agent may:

- Create a draft source-summary page.
- Create a draft Concept page.
- Create a draft Synthesis page.
- Modify an approved AI-owned draft page.
- Add internal knowledge links.
- Add source links.
- Update approved navigation sections of `wiki/index.md`.
- Append an approved entry to `wiki/log.md`.

The agent must:

- Search before creating a canonical page.
- Preserve traceability to `raw/` or `dev/`.
- Separate verified facts from interpretation.
- Preserve uncertainty and contradictions.
- Never fabricate citations or resources.
- Never mark a page as human-reviewed.
- Never silently reverse a reviewed conclusion.
- Stop and request human review if new evidence conflicts with a reviewed page.
- Stay within the exact files and operations approved by the human.

## 7. Approval model

Planning and approval are separate steps.

Showing a plan does not grant permission to execute it.

The agent must not create, edit, rename, move, or delete any file until the
human gives explicit approval for the current file-level plan.

### 7.1 Requirements for a file-level plan

A file-level plan must identify:

- The operation type
- The source files to be read
- Every file proposed for creation
- Every file proposed for modification
- The exact intended change to each file
- Information that remains uncertain
- Conflicts requiring human judgment
- Validation steps to run after writing
- Any operation that is outside the current permitted scope

### 7.2 Valid approval

Valid approval must clearly identify the current plan or approved scope.

Examples:

- "Approve the proposed ingest plan."
- "Approve creation of the two proposed Wiki pages."
- "Approve the plan, but do not create the optional Concept page."
- "Apply only the approved changes listed above."

The following do not count as approval:

- Silence
- No response
- "Looks interesting"
- "Continue explaining"
- "What would happen next?"
- A request to clarify the plan
- Approval of a previous or different plan
- Approval given before the current plan was shown

### 7.3 Scope boundaries

The approved file list and operation scope are closed boundaries.

The agent must not create or modify additional files merely because they appear
useful during execution.

If newly discovered work falls outside the approved plan, the agent must:

1. Stop before performing that additional work.
2. Report the newly discovered requirement.
3. Produce a revised plan or a separate plan.
4. Obtain new explicit approval.

If the human changes the scope, the agent must produce a revised plan or
restate the final approved scope before execution.

Approval applies only to the current operation. It does not carry over to
future Ingest, Query file-back, lint fixes, promotion operations, or other
tasks.

## 8. Risk model

Risk classification does not override Stage 1 effective permissions or
prohibitions.

### 8.1 Low-risk writes

Low-risk writes still require:

1. A current file-level plan.
2. Explicit human approval.
3. Execution limited to the approved files and scope.
4. Validation after writing.
5. A final report listing every created and modified file.

Low-risk writes include:

- Creating a draft source-summary page.
- Creating a draft Concept page.
- Creating a draft Synthesis page.
- Updating an approved section of `wiki/index.md`.
- Appending one entry to `wiki/log.md`.
- Creating an operation manifest.
- Creating a lint report.
- Fixing an obvious YAML formatting error in an approved AI-owned draft.

Low risk does not mean automatic permission.

### 8.2 Medium-risk writes

Medium-risk writes require an enhanced file-level plan and explicit approval.

Medium-risk actions include:

- Rewriting a substantial portion of an existing draft Wiki page.
- Modifying multiple Concept pages.
- Changing `status`.
- Changing `confidence`.
- Renaming or moving a Wiki page.
- Updating a page that has already been human-reviewed.

During Stage 1, a medium-risk action may proceed only if it is not separately
listed as prohibited.

### 8.3 High-risk actions

High-risk actions require a clean Git checkpoint and human handling.

High-risk actions include:

- Deleting a file.
- Merging two or more canonical or potentially duplicate Wiki pages.
- Reversing a reviewed conclusion.
- Replacing an accepted ADR.
- Modifying an approved runbook.
- Performing bulk moves.
- Performing bulk rewrites.
- Changing a canonical Concept ID.

During Stage 1, the agent must not execute high-risk actions.

The agent may:

- Identify the need for a high-risk action.
- Explain its expected impact.
- Show the exact proposed human-operated steps.
- Ask the human to perform the operation on the host.
- Reinspect the resulting files afterward.

## 9. Wiki metadata schema

Every new Markdown file under `wiki/` must begin with valid YAML frontmatter.

### 9.1 Required fields

Required fields are:

- `type`
- `title`
- `description`
- `resource`
- `tags`
- `timestamp`
- `zone`
- `status`
- `created_by`
- `maintainer`
- `confidence`
- `reviewed`
- `source_notes`

### 9.2 Default values for agent-created pages

Agent-created Wiki pages must initially use:

```yaml
zone: wiki
status: draft
created_by: ai
maintainer: human-ai
confidence: medium
reviewed: false
```

Only the human may set:

```yaml
reviewed: true
```

### 9.3 Field semantics

#### `type`

`type` identifies the knowledge-document category.

Stage 1 values include:

- `Index`
- `Log`
- `Source`
- `Concept`
- `Synthesis`

The agent must not invent new type values during Stage 1 without explicit
approval.

#### `title`

`title` is the human-readable page title.

It must describe the page clearly and must not be used as a substitute for the
filename.

#### `description`

`description` is a brief, plain-text summary of the page.

It should normally be one sentence.

It must not contain Markdown formatting or a long abstract.

#### `resource`

`resource` identifies the primary external or underlying resource when one
exists.

Valid values include:

- An external URL
- A relative path to an underlying non-Markdown resource
- An empty YAML value when no single primary resource exists

Examples:

```yaml
resource: https://docs.python.org/3/tutorial/datastructures.html
```

```yaml
resource: ../../raw/assets/example.pdf
```

```yaml
resource:
```

The agent must not fabricate a resource value.

#### `tags`

`tags` must always be a YAML list, including when empty.

Correct:

```yaml
tags: []
```

Correct with values:

```yaml
tags:
  - python
  - data-structure
```

Incorrect:

```yaml
tags: python
```

#### `timestamp`

`timestamp` records the creation time of the current Wiki page.

It must use an ISO 8601 timestamp with an explicit timezone.

Example:

```yaml
timestamp: 2026-08-14T23:08:00+08:00
```

Normal updates must not replace the original page-creation timestamp.

During Stage 1, modification history is tracked through Git, `wiki/log.md`,
and operation manifests.

#### `zone`

For every file created under `wiki/`:

```yaml
zone: wiki
```

#### `status`

Agent-created pages default to:

```yaml
status: draft
```

Changing `status` requires enhanced approval.

#### `created_by`

`created_by` records the original creator.

Valid Stage 1 values are:

- `human`
- `ai`

The value must not be changed during normal updates.

#### `maintainer`

`maintainer` records the intended maintenance responsibility.

Valid Stage 1 values are:

- `human`
- `ai`
- `human-ai`

Agent-created Wiki pages normally use:

```yaml
maintainer: human-ai
```

#### `confidence`

Valid Stage 1 values are:

- `low`
- `medium`
- `high`

Agent-created pages default to:

```yaml
confidence: medium
```

The agent may recommend a confidence change, but changing the value requires
enhanced approval.

The agent must not use numeric confidence scores during Stage 1.

#### `reviewed`

Agent-created pages must use:

```yaml
reviewed: false
```

Only the human may change it to:

```yaml
reviewed: true
```

The agent must never claim that human review occurred unless the human actually
performed and recorded that review.

#### `source_notes`

`source_notes` is the page-level provenance list.

It must always be a YAML list, including when empty.

Correct:

```yaml
source_notes: []
```

Correct with values:

```yaml
source_notes:
  - ../../raw/inbox/python-list-raw-note.md
```

Incorrect:

```yaml
source_notes: ../../raw/inbox/python-list-raw-note.md
```

`source_notes` does not replace source references placed in the Markdown body.

## 10. File naming

New agent-created files must use lowercase kebab-case filenames.

Examples:

- `python-list.md`
- `python-virtual-environment.md`
- `python-list-raw-learning-note.md`
- `python-sequence-types-comparison.md`

Do not use:

- Spaces
- Underscores
- Uppercase letters
- Trailing punctuation
- Unnecessary date prefixes
- Generic names such as `note.md` or `summary.md`

The human-readable title belongs in frontmatter:

```yaml
title: Python List
```

Do not rename existing files merely to enforce this rule during Stage 1.

Report inconsistent pre-existing filenames during Lint.

## 11. Links and source traceability

Canonical Wiki relationships should use relative Markdown links for
portability.

Do not use:

- Absolute host paths
- `file://` URLs
- Host-specific drive letters
- Copied raw content as a substitute for a source link

### 11.1 Link examples

From a Concept page to another Concept in the same directory:

```markdown
[Python Tuple](./python-tuple.md)
```

From a Concept page to a source-summary page:

```markdown
[Python List Raw Learning Note](../sources/python-list-raw-learning-note.md)
```

From a Wiki page to immutable raw evidence:

```markdown
[Python List Raw Note](../../raw/inbox/python-list-raw-note.md)
```

### 11.2 Evidence and relationships

A source link identifies evidence.

A Concept link identifies a knowledge relationship.

Do not treat a related Concept page as evidence for a factual claim unless
that Concept page itself contains traceable sources.

Every factual Wiki page must contain source links.

For a short Stage 1 page, listing the relevant sources under
`## Sources and citations` is sufficient.

For a page containing claims from multiple sources, the agent should place the
relevant source link near the supported claim when practical.

## 12. Canonical Concept rules

One concept must have one canonical Wiki page.

Before creating a new Concept page, the agent must:

1. Read `wiki/index.md`.
2. Search existing filenames.
3. Search frontmatter titles.
4. Search tags.
5. Search existing Wiki body text.
6. Check related Concept pages.
7. Determine whether an existing page represents the same concept.
8. Prefer updating the existing page when appropriate.
9. Create a new page only if no canonical page exists.

Do not create duplicates based on:

- Capitalization differences
- Singular and plural variations
- Abbreviations
- Synonyms
- Punctuation differences
- Minor naming differences

During Stage 1, the agent may identify and report duplicate Concepts, but it
must not merge, delete, rename, or redirect canonical pages.

## 13. Special Wiki management files

`wiki/index.md` and `wiki/log.md` are human-initialized management files.

Their human-reviewed status does not prevent approved maintenance of their
intended body content.

### 13.1 `wiki/index.md`

After explicit approval, the agent may:

- Add a new navigation entry.
- Update an existing navigation description when required by the approved operation.
- Keep the index concise and navigational.

The agent must not:

- Change its ownership metadata.
- Change its reviewed status.
- Replace it with a full duplicate of Wiki content.
- Add unapproved entries.
- Remove entries without explicit enhanced approval.

### 13.2 `wiki/log.md`

After explicit approval, the agent may append one concise operation entry.

The agent must not:

- Rewrite previous entries.
- Reorder previous entries.
- Delete previous entries.
- Change historical wording.
- Change its ownership metadata.
- Change its reviewed status.

`wiki/log.md` is append-only.

## 14. Ingest workflow

When asked to Ingest a source, the agent must use the following workflow.

### 14.1 Exploration

1. Read `AGENTS.md`.
2. Read only the explicitly specified source.
3. Read `wiki/index.md`.
4. Search relevant files under `wiki/`.
5. Identify related canonical Concepts.
6. Identify claims directly supported by the source.
7. Identify uncertainty, contradictions, and open questions.

During Stage 1, process only one source per Ingest.

### 14.2 Planning

Before writing, produce a file-level plan containing:

- The source file to be used
- The proposed source-summary page
- Existing Concepts proposed for update
- New Concepts proposed for creation
- `wiki/index.md` changes
- The proposed `wiki/log.md` entry
- The operation manifest path
- Proposed metadata
- Source links
- Uncertainty and conflicts
- Validation steps

Do not modify files during planning.

### 14.3 Approval

Wait for explicit human approval of the current plan.

Approval applies only to the listed files and actions.

### 14.4 Execution

After approval:

1. Re-read every existing target file.
2. Confirm that no target changed after planning.
3. Create one approved source-summary page under `wiki/sources/`.
4. Update approved existing Concepts before creating approved new Concepts.
5. Preserve uncertainty and contradictions.
6. Add traceable source links.
7. Update only the approved sections of `wiki/index.md`.
8. Append one approved entry to `wiki/log.md`.
9. Create one operation manifest.
10. Validate YAML and internal links.
11. Report every created and modified file.

If newly discovered work falls outside the approved scope, stop and request a
revised plan.

## 15. Query workflow

When answering from the Wiki:

1. Read `wiki/index.md` first.
2. Locate the relevant canonical pages.
3. Prefer reviewed pages over unreviewed pages.
4. Follow source links for important claims.
5. Read raw evidence only when verification is needed.
6. Read only raw files already referenced by the selected Wiki pages unless the human explicitly authorizes a wider read-only scope.
7. Separate:
   - verified facts
   - synthesis
   - personal observations
   - uncertainty
   - open questions
8. List every Wiki and source file used.
9. State when an important page has not been human-reviewed.
10. Do not write anything to the Vault during a normal Query.

### 15.1 Query file-back

Query file-back is a separate write operation.

Before proposing file-back, the agent must:

1. Explain why the result has long-term value.
2. Identify the exact target file.
3. State whether the operation will create or update that file.
4. Show a new file-level plan.
5. Obtain explicit approval for the current plan.

A request to answer a question is not approval for file-back.

Stage 1 Query file-back must still comply with all effective permissions and
prohibitions.

## 16. Lint workflow

Lint is primarily a read-only analysis operation.

Lint must check:

- Invalid YAML
- Missing required metadata
- Invalid metadata values
- Non-list `tags` or `source_notes`
- Broken internal links
- Absolute or host-specific links
- Duplicate Concepts
- Orphan Wiki pages
- Missing source notes
- Unsupported factual claims
- Index omissions
- Missing log entries
- Inconsistent filenames and titles
- AI-created pages incorrectly marked as reviewed
- Manifest entries that do not match actual file changes

Lint may validate paths into `raw/`, but it must not scan or read all raw file
contents unless the human explicitly approves that read-only scope.

### 16.1 Lint report approval

A request to run Lint authorizes read-only analysis only.

Writing a Lint report requires:

1. A proposed report path.
2. A file-level plan.
3. Explicit human approval.

After approval, Lint must write its report under:

```text
operations/lint-reports/
```

The approved Lint report must be the only file created or modified unless a
separate fix plan is approved.

Lint must not automatically apply medium-risk or high-risk fixes.

## 17. Operation manifest requirements

Every approved Ingest operation must create one manifest under:

```text
operations/manifests/
```

The manifest filename must use a timestamp and operation description in
lowercase kebab-case.

Example:

```text
2026-08-14t230800-ingest-python-list.md
```

The manifest must include:

- Operation type
- Operation timestamp
- Human-approved scope
- Source files read
- Files created
- Files modified
- Files skipped because they were outside scope
- Uncertainty or conflicts found
- Validation performed
- Validation results
- Git write operations performed

During Stage 1:

```yaml
git_write_operations: none
```

The manifest must not:

- Claim broader approval than the human granted.
- Claim human review of content.
- Claim successful validation that was not actually performed.
- Contain secrets.
- Copy large amounts of raw source content.

## 18. Git policy

During Stage 1, Git is read-only for the agent.

### 18.1 Allowed Git commands

The agent may run only:

- `git status`
- `git diff`
- `git log`
- `git show`

Options that preserve read-only behavior may be used with these commands.

### 18.2 Prohibited Git commands

The agent must not run any Git command that changes the working tree, index,
history, branches, remotes, or repository configuration.

Prohibited commands include, but are not limited to:

- `git add`
- `git commit`
- `git push`
- `git pull`
- `git fetch`
- `git reset`
- `git clean`
- `git rebase`
- `git checkout`
- `git switch`
- `git restore`
- `git merge`
- `git cherry-pick`
- `git revert`
- `git stash`
- `git branch`
- `git remote`
- `git config`

There is no conversational override for the Stage 1 Git read-only policy.

If a Git write operation appears necessary, the agent must:

1. Explain why it may be needed.
2. Show the exact proposed command.
3. Explain the expected effect.
4. Explain the risk.
5. Ask the human to run it manually on the host.
6. Not execute the command itself.

A later project stage may replace this policy with a separately reviewed Git
policy.

## 19. Read-only operation constraints

Read-only permission does not include:

- Accessing paths outside the mounted Vault
- Accessing the network
- Installing software
- Changing configuration
- Creating temporary files inside the Vault
- Modifying timestamps
- Modifying file permissions
- Running commands with side effects

If a temporary file is strictly required for validation, it must be created
outside the mounted Vault, preferably under `/tmp`.

Temporary files must not contain copied sensitive raw content unless the human
has explicitly approved that operation.

Temporary files must be removed after use.

When possible, prefer validation through standard output without creating
temporary files.

## 20. Concurrent modification protection

Obsidian and the agent may access the Vault at the same time.

Before applying an approved write plan, the agent must re-read every target
file that already exists.

If a target file differs from the version inspected during planning, the agent
must:

1. Stop the write operation.
2. Report the changed target.
3. Avoid overwriting the human edit.
4. Produce a revised plan if appropriate.
5. Obtain new approval before writing.

The agent must never overwrite concurrent human changes.

## 21. Failure handling

The agent must stop the current write operation when:

- The approved file list becomes unclear.
- The approved scope becomes unclear.
- A target file changed after the plan was approved.
- A required source cannot be read.
- YAML validation fails.
- An internal link cannot be validated.
- A conflict with a reviewed page is discovered.
- The operation would require modifying `raw/`.
- The operation would require modifying `dev/`.
- The operation would require an unapproved file.
- The operation would require a prohibited Git command.
- The operation would require unapproved network access.
- The operation would require installing an unapproved tool.
- Continuing could cause data loss.

After stopping, the agent must:

1. Report what completed successfully.
2. Report what did not complete.
3. List every file already created or modified.
4. Avoid automatic rollback commands.
5. Ask the human to inspect `git status` and `git diff`.
6. Propose a revised plan if appropriate.

The agent must not use `git restore`, `git reset`, `git clean`, file deletion,
or other write operations to conceal or automatically roll back a partial
failure.

## 22. Final reporting

After every approved write operation, the agent must report:

- The completed operation
- Every source file read
- Every file created
- Every file modified
- Every planned file not changed
- Validation commands or checks performed
- Validation results
- Remaining uncertainty
- Conflicts requiring human review
- Confirmation that `raw/` and `dev/` were not modified
- Confirmation that no Git write operation was performed
- A recommendation that the human inspect `git status` and `git diff`

The final report does not constitute human review or approval of the generated
knowledge.

## 23. Effective Stage 1 summary

During Stage 1:

- Docker sbx protects the host outside the mounted workspace.
- Docker sbx does not protect writable files inside the Vault.
- `raw/` is immutable for the agent.
- `dev/` is read-only for the agent.
- Only explicitly approved files under `wiki/` and `operations/` are writable.
- Every file write requires a current file-level plan and explicit approval.
- Approval never expands beyond the listed files and actions.
- High-risk actions are not executable by the agent.
- Git is read-only for the agent.
- Network research is prohibited unless separately approved.
- Tool installation is prohibited unless separately approved.
- The agent must never set `reviewed: true`.
- The human performs final review, recovery, and all Git write operations.
