# LLM Wiki Operating Rules

## 1. Purpose

This workspace is a human-directed Obsidian LLM Wiki maintained with
Antigravity CLI running inside Docker sbx.

The human owns the Vault and makes all final decisions.

The agent performs structured knowledge maintenance within the boundaries
defined in this file.

## 2. Knowledge zones

The Vault has three knowledge zones:

- `raw/`: human-owned source evidence
- `dev/`: human-led working and learning notes
- `wiki/`: agent-maintained canonical knowledge

## 3. Instruction priority

When instructions conflict, use this priority:

1. Prevent data loss.
2. Never modify `raw/`.
3. Preserve human-authored observations in `dev/`.
4. Maintain source traceability in `wiki/`.
5. Prefer updating an existing canonical page over creating a duplicate.
6. Ask the human before medium-risk or high-risk changes.

## 4. Docker sbx environment

Antigravity CLI runs inside a Docker sbx microVM.

Docker sbx is the infrastructure isolation boundary, but the mounted
Obsidian Vault remains writable and changes are synchronized back to the host.

Therefore, sandbox isolation does not grant permission to modify all files
inside the workspace.

The agent must:

- Operate only inside the mounted Vault workspace.
- Never inspect or search for host files outside the workspace.
- Never attempt to discover host credentials or host services.
- Never change sbx network policies.
- Never create, read, update, or delete sbx secrets.
- Never bypass Antigravity tool approvals.
- Never use unrestricted or dangerous execution modes.
- Never install tools unless explicitly approved.
- Never start nested containers during Stage 1.
- Never access external websites unless explicitly authorized for a
  specific task.

## 5. Zone ownership

### raw/

`raw/` is the immutable evidence layer.

The agent may:

- Read files
- Search files
- Cite files
- Create Wiki pages based on files
- Report metadata problems

The agent must never:

- Edit raw files
- Reformat raw files
- Add ingest markers to raw files
- Rename raw files
- Move raw files
- Delete raw files
- Change anything in `raw/assets/`

Treat every file under `raw/` as immutable even when filesystem permissions
technically allow writing.

### dev/

`dev/` is a human-led collaboration area.

The agent may:

- Read files
- Suggest improvements
- Identify related concepts
- Recommend promotion candidates

The agent must ask before:

- Editing a dev note
- Rewriting a complete note
- Renaming or moving a note
- Combining notes
- Removing personal observations
- Promoting content to `wiki/`

### wiki/

`wiki/` is the canonical knowledge layer maintained by the agent.

The agent may:

- Create draft source-summary pages
- Create draft concept pages
- Update existing draft pages
- Add internal links
- Add source links
- Update `wiki/index.md`
- Append to `wiki/log.md`

The agent must:

- Search before creating a canonical page
- Preserve traceability to `raw/` or `dev/`
- Separate verified facts from interpretation
- Preserve uncertainty
- Never fabricate citations
- Never mark a page as human-reviewed
- Ask before reversing a reviewed conclusion

## 6. Required Wiki metadata

Every new file under `wiki/` must begin with valid YAML frontmatter.

Required fields:

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

Default values for agent-created Wiki pages:

- `zone: wiki`
- `status: draft`
- `created_by: ai`
- `maintainer: human-ai`
- `confidence: medium`
- `reviewed: false`

Only the human may set `reviewed: true`.

Use ISO 8601 timestamps with timezone.

## 7. Canonical concept rule

One concept must have one canonical Wiki page.

Before creating a page:

1. Read `wiki/index.md`.
2. Search filenames.
3. Search frontmatter titles and tags.
4. Search existing Wiki body text.
5. Check related pages.
6. Update an existing page if it represents the concept.
7. Create a new page only if no canonical page exists.

Do not create duplicate concepts with different capitalization, plural forms,
abbreviations, or minor naming differences.

## 8. Links and source traceability

Canonical Wiki relationships should use relative Markdown links for portability.

Every factual Wiki page must contain source links.

A source link identifies evidence.
A concept link identifies a knowledge relationship.

Do not treat a related Concept page as evidence for a factual claim unless
that Concept page itself has traceable sources.

## 9. Ingest workflow

When asked to ingest a source:

1. Read `AGENTS.md`.
2. Read only the specified source.
3. Read `wiki/index.md`.
4. Search for related Wiki pages.
5. Produce a file-level change plan.
6. Do not modify files until the human approves the plan.
7. Create one source-summary page under `wiki/sources/`.
8. Update existing concepts before creating new concepts.
9. Preserve uncertainty and contradictions.
10. Update `wiki/index.md`.
11. Append one concise entry to `wiki/log.md`.
12. Create one manifest under `operations/manifests/`.
13. Validate YAML and internal links.
14. Report every created and modified file.

During Stage 1, process only one source per ingest.

## 10. Query workflow

When answering from the Wiki:

1. Read `wiki/index.md` first.
2. Locate relevant canonical pages.
3. Prefer reviewed pages.
4. Follow source links for important claims.
5. Read raw evidence only when verification is needed.
6. Separate:
   - verified facts
   - synthesis
   - personal observations
   - uncertainty
   - open questions
7. List the files used.
8. Do not write the answer back unless the human explicitly approves file-back.

## 11. Lint workflow

Lint must check:

- Invalid YAML
- Missing required metadata
- Broken internal links
- Duplicate concepts
- Orphan Wiki pages
- Missing source notes
- Unsupported factual claims
- Index omissions
- Missing log entries
- Inconsistent filenames and titles
- AI pages incorrectly marked as reviewed

Lint must write a report under:

`operations/lint-reports/`

Lint must not automatically apply medium-risk or high-risk fixes.

## 12. Risk levels

### Low risk

The agent may execute only after showing the file-level plan:

- Create a draft source summary
- Create a draft concept page
- Update `wiki/index.md`
- Append to `wiki/log.md`
- Create an operation manifest
- Fix obvious YAML formatting in an AI-owned draft

### Medium risk

Requires explicit human approval:

- Rewrite an existing Wiki page
- Modify several concept pages
- Promote a dev note
- Change status or confidence
- Rename or move a Wiki page
- Merge duplicate concepts

### High risk

Requires explicit human approval and a clean Git checkpoint:

- Delete any file
- Modify anything in `raw/`
- Reverse a reviewed conclusion
- Replace an accepted ADR
- Modify an approved runbook
- Perform bulk moves or rewrites

## 13. Git rules

The agent may run read-only Git inspection commands:

- `git status`
- `git diff`
- `git log`
- `git show`

The agent must not run:

- `git add`
- `git commit`
- `git push`
- `git pull`
- `git reset`
- `git clean`
- `git rebase`
- `git checkout`
- `git restore`
- commands that change branches or remotes

unless the human explicitly requests the exact operation.

## 14. Stage 1 restrictions

During Stage 1:

- Do not install plugins.
- Do not configure MCP.
- Do not add vector search.
- Do not create remote automation.
- Do not access the web unless explicitly authorized.
- Do not modify sbx configuration.
- Do not start nested containers.
- Process one source at a time.
- Explore first, plan second, execute only after approval.
- Never commit changes to Git.
