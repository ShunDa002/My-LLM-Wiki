---
title: LangChain
type: concept
status: active
classification: public
aliases: []
tags: ["framework", "langchain"]
sources:
  - "[[Source - LangGraph]]"
created: 2026-10-06
updated: 2026-10-06
confidence: medium
knowledge_status: current
review_needed: false
---

# LangChain

## Definition

LangChain is a framework providing the foundational building blocks for Large Language Model (LLM) applications, such as prompts, tools, and retrievers, organized primarily as linear workflows.

## Key points

- **Workflow Role**: LangChain is best suited for simple, sequential, linear workflows, such as prompt chains or basic retrieval systems [[Source - LangGraph]].
- **Ecosystem Base**: It acts as the foundational layer that other tools (like LangGraph) build upon, providing components like `ChatOpenAI`, `PromptTemplate`, and `DocumentLoaders` without handling complex orchestration on its own [[Source - LangGraph]].

## Relationships

- Contrasts with: [[LangGraph]]
