---
title: Asynchronous Programming
type: concept
status: active
classification: public
aliases: ["Async", "Asynchronous"]
tags: ["programming", "async"]
sources:
  - "[[Source - Agentic AI]]"
created: 2026-10-06
updated: 2026-10-06
confidence: medium
knowledge_status: current
review_needed: false
---

# Asynchronous Programming

## Definition

A programming paradigm that allows code to handle multiple tasks concurrently without blocking the program's execution, primarily used for I/O-bound tasks to allow other operations to proceed while waiting for external events.

## Key points

- **Subroutine vs. Co-routine**: A subroutine follows a strict hierarchical relationship and executes fully before returning control. A co-routine allows cooperative multitasking and can pause itself (e.g., using `await`), giving control back to the caller while saving its state [[Source - Agentic AI]].
- **Parallelism vs. Concurrency**: Parallelism runs multiple tasks simultaneously using multiple threads or processes, whereas concurrency manages multiple tasks that can start, run, and finish in overlapping time periods [[Source - Agentic AI]].

## Relationships

- Related: [[Agentic AI]]
