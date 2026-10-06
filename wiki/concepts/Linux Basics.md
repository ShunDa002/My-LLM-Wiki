---
title: Linux Basics
type: concept
status: active
classification: public
aliases: ["Linux Commands"]
tags: ["linux", "os", "filesystem"]
sources:
  - "[[Source - Linux Commands and Vim Operations]]"
created: 2026-10-06
updated: 2026-10-06
confidence: high
knowledge_status: current
review_needed: false
---

# Linux Basics

## Definition

Basic Linux operations revolve around command-line utilities for navigating and manipulating the POSIX filesystem.

## Core Utilities

- **Navigation and Inspection**: Traversal is handled by `cd` and `pwd`, while `ls` (with flags like `-l` for detail or `-a` for hidden files), `tree`, and `du` inspect directory structures and sizes [[Source - Linux Commands and Vim Operations]].
- **File Management**: `touch` creates empty files or updates timestamps. `mkdir` creates directories (`-p` for nested). `cp`, `mv`, and `rm` handle copying, moving/renaming, and deletion, respectively [[Source - Linux Commands and Vim Operations]].
- **Output**: `echo` prints text (often redirected to files via `>`), and `cat` prints file contents to standard output [[Source - Linux Commands and Vim Operations]].

## Permissions (chmod)

Linux file permissions are divided into three groups: User (Owner), Group, and Other. Permissions consist of Read (r=4), Write (w=2), and Execute (x=1) [[Source - Linux Commands and Vim Operations]].
- **Symbolic notation**: Modifies specific groups (e.g., `chmod u+x` adds execute to the user).
- **Octal notation**: Overwrites permissions entirely using sums (e.g., `chmod 777` for global full access, or `644` for standard read/write user and read-only others).

## Relationships

- Related: [[Hard vs Soft Links (Linux)]]
