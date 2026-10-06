---
title: LangSmith
type: concept
status: active
classification: public
aliases: []
tags: ["observability", "llmops", "langchain"]
sources:
  - "[[Source - Langchain Ecosystem]]"
created: 2026-10-06
updated: 2026-10-06
confidence: medium
knowledge_status: current
review_needed: false
---

# LangSmith

## Definition

LangSmith is an LLMOps platform designed by the LangChain team for debugging, monitoring, and evaluating applications and AI agents. It functions independently of LangChain and records complete execution steps as traces.

## Key points

- **Observability and Tracing**: LangSmith records every step in an execution sequence (e.g., inputs, outputs, errors, token usage, tool calls) as a trace, allowing developers to inspect model behavior and measure performance [[Source - Langchain Ecosystem]].
- **Use Cases**: It is useful for debugging failed agent nodes, reviewing conversational threads, measuring response latency, and comparing different prompts or models [[Source - Langchain Ecosystem]].

## Relationships

- Related: [[LangGraph]]
