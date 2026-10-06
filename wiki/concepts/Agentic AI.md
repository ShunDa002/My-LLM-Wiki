---
title: Agentic AI
type: concept
status: active
classification: public
aliases: ["Agentic Artificial Intelligence"]
tags: ["ai", "agents", "langgraph"]
sources:
  - "[[Source - Agentic AI]]"
created: 2026-10-06
updated: 2026-10-06
confidence: medium
knowledge_status: current
review_needed: false
---

# Agentic AI

## Definition

Agentic AI refers to an artificial intelligence system capable of making decisions and taking actions autonomously to achieve a specific goal without requiring step-by-step human instructions, though it may still incorporate human-in-the-loop (HITL) approvals for high-risk actions.

## Key points

- **Characteristics**: Agentic AI operates autonomously, is goal-oriented with persistent objectives, can plan and break down high-level goals, reasons to select tools, adapts to unexpected conditions, and maintains context awareness (memory) [[Source - Agentic AI]].
- **Components**: The system architecture typically includes a Brain (the LLM for reasoning), an Orchestrator (frameworks like LangGraph or Autogen for task routing and looping), [[Tool|Tools]] (for external actions), Memory (short and long term), and a Supervisor (for HITL and guardrails) [[Source - Agentic AI]].

## Relationships

- Related: [[Asynchronous Programming]]
- Related: [[Tool]]
