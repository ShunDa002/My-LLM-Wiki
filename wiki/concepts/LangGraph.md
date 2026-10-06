---
title: LangGraph
type: concept
status: active
classification: public
aliases: []
tags: ["agents", "langchain", "framework"]
sources:
  - "[[Source - Langchain Ecosystem]]"
  - "[[Source - LangGraph]]"
created: 2026-10-06
updated: 2026-10-06
confidence: medium
knowledge_status: current
review_needed: false
---

# LangGraph

## Definition

LangGraph is a framework used to construct and manage LLM-based agents and multi-agent systems. It models logic as a flowchart engine for LLMs, defining nodes (tasks), edges (routing), and state, rather than a linear chain.

## Key points

- **Agent Creation**: It provides the infrastructure to create agents, which are LLMs connected to third-party tools [[Source - Langchain Ecosystem]].
- **Complex Workflows & State**: It solves LangChain's limitations by providing explicit control flow (conditional branches, loops), a shared graph-state model, and support for nested subgraphs [[Source - LangGraph]].
- **Resilience and HITL**: Supports event-driven execution with interrupts for Human-in-the-Loop (HITL) scenarios, and fault tolerance via checkpoint-based durable recovery [[Source - LangGraph]].

## Relationships

- Related: [[Agentic AI]]
- Related: [[LangSmith]]
- Related: [[LangGraph Async Execution]]
- Contrasts with: [[LangChain]]
