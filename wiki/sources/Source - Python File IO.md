---
title: Source - Python File IO
type: source
raw_file: "[[raw/notes/Python/File-IO.md]]"
source_id: baf7e496e741a79db7cfe8e88d8e9a3f2a86567bdd10ba0de95e2d923fe2cf0d
source_kind: notes
author: Unknown
classification: public
captured: 2026-10-06
ingested: 2026-10-06
status: processed
---

# Source - Python File IO

## What this source is

Notes covering the fundamentals of File I/O operations in Python, including the `open()` function, context management, and basic CSV parsing.

## Claims taken from it

- The `open()` function accesses files using modes like `"w"` (write/overwrite), `"a"` (append), and `"r"` (read).
- The `with` statement acts as a context manager that automatically closes the file when the code block finishes executing.
- Files act as iterables, meaning they can be directly looped over line-by-line.
- CSV (Comma Separated Values) data can be manually parsed by reading line-by-line and unpacking values using the `.split(",")` string method.

## What it changed in the Wiki

- Created: [[File IO (Python)]]

## Not used

- Redundant code examples showing the manual `file.close()` approach compared to the `with` statement.
