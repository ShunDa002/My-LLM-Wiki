---
title: Pydantic
type: concept
status: active
classification: public
aliases: []
tags: ["python", "validation", "pydantic"]
sources:
  - "[[Source - Pydantic]]"
created: 2026-10-06
updated: 2026-10-06
confidence: high
knowledge_status: current
review_needed: false
---

# Pydantic

## Definition

Pydantic is a high-performance data validation and settings management library for Python that utilizes native type hints to enforce data structure integrity at runtime.

## Key points

- **Validation and Performance**: Pydantic automatically validates, parses, and coerces input data (using lax or strict modes) based on Python type annotations. Its validation engine is written in Rust, making it extremely fast [[Source - Pydantic]].
- **Schema Definition (BaseModel)**: Data schemas are defined by inheriting from `BaseModel`. This declarative approach removes the need for verbose, manual validation checks and naturally integrates into modern Python workflows [[Source - Pydantic]].
- **Advanced Features**: It extends basic type validation with advanced constructs:
  - Custom rules for individual fields (`@field_validator`) or multiple interdependent fields (`@model_validator`).
  - Derived fields constructed from other input data (`@computed_field`).
  - Complex hierarchical schemas via nested models.
  - Built-in serialization capabilities (`model_dump`, `model_dump_json`) to convert validated objects back into standard formats [[Source - Pydantic]].

## Relationships

- None
