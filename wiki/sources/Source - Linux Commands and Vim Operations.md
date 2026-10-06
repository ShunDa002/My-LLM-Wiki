---
title: Source - Linux Commands and Vim Operations
type: source
raw_file: "[[raw/notes/Linux-Commands-and-Vim-Operations.md]]"
source_id: eab65acfcd66e83a7be9c264b7d816f2c92b8b2a8bfac6497f42c0de4d4b9aa1
source_kind: notes
author: Unknown
classification: public
captured: 2026-10-06
ingested: 2026-10-06
status: processed
---

# Source - Linux Commands and Vim Operations

## What this source is

A categorized cheat sheet covering fundamental Linux operations, including Multipass VM management, Vim text editing, basic filesystem navigation, file linking, and permission management.

## Claims taken from it

- **Multipass**: A command-line tool used to create, list, and enter Ubuntu system virtual machines (e.g., `multipass launch`, `multipass list`).
- **Vim**: A modal text editor with three primary modes: Command (default for navigation and copy/pasting), Insert (for text entry), and Bottom-line/Ex (for saving, searching, and global substitution).
- **Filesystem & Management**: Standard Linux commands manage traversal (`cd`, `pwd`), inspection (`ls`, `tree`, `du`), manipulation (`mkdir`, `cp`, `mv`, `rm`), and text output (`cat`, `echo`).
- **Linking**: Hard links (`ln`) share the exact same inode as the original file and survive its deletion. Soft/symbolic links (`ln -s`) act as shortcuts pointing to a path and break if the target is deleted.
- **Permissions**: `chmod` alters file access using either symbolic notation (e.g., `u+x`) or numeric octal combinations (e.g., `777`, `644`) representing read (4), write (2), and execute (1) rights.

## What it changed in the Wiki

- Created: [[Linux Basics]]
- Created: [[Vim (Text Editor)]]
- Created: [[Multipass]]
- Created: [[Hard vs Soft Links (Linux)]]

## Not used

- N/A
