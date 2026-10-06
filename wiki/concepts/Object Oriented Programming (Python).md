---
title: Object Oriented Programming (Python)
type: concept
status: active
classification: public
aliases: ["OOP (Python)"]
tags: ["python", "oop", "architecture"]
sources:
  - "[[Source - Object Oriented Programming (Python)]]"
created: 2026-10-06
updated: 2026-10-06
confidence: high
knowledge_status: current
review_needed: false
---

# Object Oriented Programming (Python)

## Definition

Object-Oriented Programming (OOP) in Python is a paradigm that uses "Classes" as blueprints to create custom data types (Objects). This approach encapsulates data and behavior together, making complex software more organized and robust compared to relying solely on primitive data structures.

## Key points

- **Classes and Instantiation**: A class defines the mold for an object. Calling the class function (e.g., `Student()`) instantiates a new object, structuring data consistently across all instances [[Source - Object Oriented Programming (Python)]].
- **Instance Methods**: Special methods dictate object behavior. The `__init__(self)` method is automatically invoked upon object creation to initialize instance variables and enforce standardized attributes [[Source - Object Oriented Programming (Python)]].
- **Encapsulation and Validation**: OOP encourages placing all related functionality within the class itself. For example, input validation can be performed directly inside `__init__`, raising exceptions (e.g., `raise ValueError(...)`) if invalid data is provided, which is an advantage over inherently unvalidated structures like Dictionaries [[Source - Object Oriented Programming (Python)]].
- **Comparison to Alternatives**:
  - **Tuples**: Immutable collections of values useful when data should not change.
  - **Dictionaries**: Mutable collections providing semantic keys (e.g., `student["name"]`), but lacking built-in logic or validation guarantees [[Source - Object Oriented Programming (Python)]].

## Relationships

- Related: [[Python (Programming Language)]]
