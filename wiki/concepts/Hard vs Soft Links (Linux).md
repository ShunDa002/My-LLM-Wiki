---
title: Hard vs Soft Links (Linux)
type: concept
status: active
classification: public
aliases: ["Symlinks", "Soft Links", "Hard Links"]
tags: ["linux", "filesystem"]
sources:
  - "[[Source - Linux Commands and Vim Operations]]"
created: 2026-10-06
updated: 2026-10-06
confidence: high
knowledge_status: current
review_needed: false
---

# Hard vs Soft Links (Linux)

## Definition

In Linux, the `ln` command creates links to files, allowing multiple paths to reference the same data. These links come in two distinct architectural forms: hard links and soft (symbolic) links [[Source - Linux Commands and Vim Operations]].

## Hard Links

Created using `ln`. A hard link creates a new directory entry that points directly to the original file's exact `inode` on the disk [[Source - Linux Commands and Vim Operations]].
- Modifications to the hard link instantly reflect in the original file, and vice-versa, because they are structurally identical references to the same data blocks.
- If the original file is deleted, the data remains safely accessible via the hard link.

## Soft Links (Symlinks)

Created using `ln -s`. A soft link operates similarly to a Windows "shortcut." It creates a tiny new file containing only the textual path to the target file, rather than pointing to its `inode` [[Source - Linux Commands and Vim Operations]].
- If the original target file is deleted or moved, the soft link becomes "broken" or "dangling," as the path it references no longer exists.

## Relationships

- Related: [[Linux Basics]]
