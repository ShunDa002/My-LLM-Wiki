---
title: Python (Programming Language)
type: concept
status: active
classification: public
aliases: ["Python"]
tags: ["python", "language"]
sources:
  - "[[Source - Python Fundamentals]]"
created: 2026-10-06
updated: 2026-10-06
confidence: high
knowledge_status: current
review_needed: false
---

# Python (Programming Language)

## Definition

Python is an interpreted programming language known for its readability, robust exception handling, and modular architecture, utilizing `.py` files executed via an interpreter.

## Key points

- **Control Flow**: Logic is structured using functions (`def`), conditionals (`if`/`elif`/`else`), and loops (`while` for condition-based repetition, `for` for iterating over sequences like lists or ranges) [[Source - Python Fundamentals]].
- **Exception Handling**: Python's philosophy heavily relies on exception handling (`try`, `except`, `else`, `pass`). Instead of defensively checking inputs before executing code, it is idiomatic to try the operation and handle failures (e.g., `ValueError`) when they occur [[Source - Python Fundamentals]].
- **Data Structures**: It relies heavily on built-in collections such as `list` (zero-indexed ordered values) and `dict` (semantic key-value pairs) for data manipulation and APIs (like JSON parsing) [[Source - Python Fundamentals]].
- **Modularity**: Python allows functionality to be abstracted into libraries/modules. A common pattern is wrapping a file's execution block in `if __name__ == "__main__":` to ensure the logic runs only when the file is executed directly, avoiding unintended execution when its functions are imported elsewhere [[Source - Python Fundamentals]].

## Relationships

- Related: [[File IO (Python)]]
- Related: [[Object Oriented Programming (Python)]]
