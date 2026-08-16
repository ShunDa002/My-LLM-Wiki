# Wiki Metadata, Naming, and Link Schema

## Scope

Load this document when creating a Wiki page, changing frontmatter, validating metadata, checking filenames, or constructing internal/source links.

## Required frontmatter

Every new Markdown file under `wiki/` must begin with valid YAML frontmatter containing:

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

## Default values for agent-created pages

```yaml
zone: wiki
status: draft
created_by: ai
maintainer: human-ai
confidence: medium
reviewed: false
```

Only the human may set `reviewed: true`.

## Field rules

### `type`

Allowed Stage 1 values:

- `Index`
- `Log`
- `Source`
- `Concept`
- `Synthesis`

Do not invent a type without explicit approval.

### `title`

Use a clear human-readable page title. The title does not replace the filename.

### `description`

Use a brief plain-text summary, normally one sentence. Do not include Markdown or a long abstract.

### `resource`

Use one of:

- The primary external URL.
- A relative path to the primary underlying non-Markdown resource.
- An empty value if no single primary resource exists.

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

Do not use copied HTML and do not fabricate a resource.

### `tags`

Always use a YAML list:

```yaml
tags: []
```

or:

```yaml
tags:
  - python
  - data-structure
```

### `timestamp`

Record page creation time as ISO 8601 with an explicit timezone:

```yaml
timestamp: 2026-08-14T23:08:00+08:00
```

Normal updates must not replace the original timestamp. Modification history is tracked by Git, `wiki/log.md`, and approved manifests.

### `zone`

Every file created under `wiki/` uses:

```yaml
zone: wiki
```

### `status`

Agent-created pages default to `draft`. Changing the value requires enhanced approval.

### `created_by`

Allowed values are `human` and `ai`. Do not change the original value during normal updates.

### `maintainer`

Allowed values are `human`, `ai`, and `human-ai`. Agent-created pages normally use `human-ai`.

### `confidence`

Allowed values are `low`, `medium`, and `high`. Agent-created pages default to `medium`. A change requires enhanced approval. Do not use numeric confidence scores during Stage 1.

### `reviewed`

Agent-created pages use `false`. Only the human may change it to `true`. Never claim human review unless the human performed and recorded it.

### `source_notes`

Always use a YAML list:

```yaml
source_notes: []
```

or:

```yaml
source_notes:
  - ../../raw/inbox/python-list-raw-note.md
```

This list does not replace links and citations in the Markdown body.

## Filenames

New agent-created files must use lowercase kebab-case, for example:

- `python-list.md`
- `python-virtual-environment.md`
- `python-list-raw-learning-note.md`
- `python-sequence-types-comparison.md`

Do not use spaces, underscores, uppercase letters, trailing punctuation, unnecessary date prefixes, or generic names such as `note.md` and `summary.md`.

Do not rename existing files merely to enforce this rule during Stage 1. Report inconsistencies during Lint.

## Links

Use relative Markdown links. Do not use absolute host paths, `file://` URLs, host-specific drive letters, or copied content in place of a source link.

Examples:

```markdown
[Python Tuple](./python-tuple.md)
```

```markdown
[Python List Raw Learning Note](../sources/python-list-raw-learning-note.md)
```

```markdown
[Python List Raw Note](../../raw/inbox/python-list-raw-note.md)
```
