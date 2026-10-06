---
title: Vim (Text Editor)
type: concept
status: active
classification: public
aliases: ["Vi"]
tags: ["linux", "editor", "vim"]
sources:
  - "[[Source - Linux Commands and Vim Operations]]"
created: 2026-10-06
updated: 2026-10-06
confidence: high
knowledge_status: current
review_needed: false
---

# Vim (Text Editor)

## Definition

Vim (Vi Improved) is a highly ubiquitous, terminal-based text editor in Linux environments. It operates on a modal architecture, meaning the same keystrokes perform different actions depending on the current active mode [[Source - Linux Commands and Vim Operations]].

## Modal Architecture

Vim relies on three primary modes [[Source - Linux Commands and Vim Operations]]:
- **Command Mode** (Default): Used for navigation and structural edits. Keystrokes like `h/j/k/l` move the cursor, `yy` copies a line, `dd` deletes a line, `p` pastes, and `u` undoes changes.
- **Insert Mode**: Entered via keys like `i` (insert before cursor), `a` (append after), or `o` (open new line). Used for raw text entry. Exited by pressing `ESC`.
- **Bottom-line / Ex Mode**: Entered by pressing `:` from Command mode. Used for file-level operations like saving (`:w`), quitting (`:q`), enabling line numbers (`:set nu`), and executing global substitutions (e.g., `:%s/old/new/g`). Search is also executed here using `/` (forward) or `?` (backward).

## Relationships

- Related: [[Linux Basics]]
