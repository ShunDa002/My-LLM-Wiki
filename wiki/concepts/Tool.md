---
title: Tool
type: concept
status: active
classification: public
aliases: ["Tools", "Tool Calling"]
tags: ["agents", "tools", "architecture"]
sources:
  - "[[Source - Tools]]"
created: 2026-10-06
updated: 2026-10-06
confidence: high
knowledge_status: current
review_needed: false
---

# Tool

## Definition

In the context of Agentic AI, a Tool is an external function, API, database, or service that an LLM-based agent can invoke to perform real-world actions, retrieve data, or compute results beyond its static training knowledge.

## Key points

- **Capabilities**: Tools enable agents to search the web, execute code (e.g., Python), query databases, trigger APIs, or retrieve documents (RAG) [[Source - Tools]].
- **Tool Calling Workflow**: The typical lifecycle for tool execution follows eight steps [[Source - Tools]]:
  1. The user provides a request.
  2. The agent understands the goal.
  3. The agent decides if a tool is required.
  4. The agent selects the appropriate tool.
  5. The agent generates the necessary arguments for the tool.
  6. The tool executes the action.
  7. The result is returned to the agent.
  8. The agent produces the final response incorporating the tool's result.

## Relationships

- Related: [[Agentic AI]]
