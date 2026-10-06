---
title: Source - Python Fundamentals
type: source
raw_file: "[[raw/notes/Python/Python.md]]"
source_id: 5f914da4a205e8fcaedf478d56242813d8ffc9bba25244d0ecda98da43871b01
source_kind: notes
author: Unknown
classification: public
captured: 2026-10-06
ingested: 2026-10-06
status: processed
---

# Source - Python Fundamentals

## What this source is

An extensive primer on the Python programming language, covering its syntax, control flow, exception handling, built-in data structures, and module architecture.

## Claims taken from it

- Python is an interpreted language that translates `.py` files into machine code.
- Control flow is managed via functions (`def`), conditionals (`if`/`elif`/`else`), and loops (`while`/`for`).
- Exception handling in Python encourages the "try it and handle exceptions" (EAFP) approach using `try`/`except`/`else`/`pass` rather than exhaustive defensive type checking.
- The language includes native data structures like `list` (indexed collections) and `dict` (key-value associations), and easily integrates external structured data like JSON.
- Python uses a modular scoping system where the `__name__ == "__main__"` condition is used to ensure that a file's main execution logic runs only when invoked directly from the command line, and not when the file is imported as a module.

## What it changed in the Wiki

- Created: [[Python (Programming Language)]]
- Updated: [[File IO (Python)]] — added relationships link.
- Updated: [[Object Oriented Programming (Python)]] — added relationships link.

## Not used

- Basic arithmetic calculations, repetitive string formatting examples (e.g. `cowsay` API), and rudimentary `sys.argv` usage patterns.
