---
title: Retrieval-Augmented Generation
type: concept
status: active
classification: public
aliases: ["RAG"]
tags: ["rag", "architecture", "llm"]
sources:
  - "[[Source - RAG]]"
created: 2026-10-06
updated: 2026-10-06
confidence: high
knowledge_status: current
review_needed: false
---

# Retrieval-Augmented Generation

## Definition

Retrieval-Augmented Generation (RAG) is an architectural approach for Large Language Models (LLMs) that combines generative capabilities with a mechanism to retrieve external, domain-specific information to ground the model's responses.

## Key points

- **Motivations for Use**: RAG is primarily employed to overcome three major LLM limitations:
  1. **Outdated Knowledge**: By retrieving fresh information, it circumvents the static knowledge cutoff of the model's training data.
  2. **Private Data**: It allows the model to answer questions based on internal or proprietary documents that were not part of its public training set.
  3. **Hallucinations**: Grounding generation in retrieved facts significantly reduces the likelihood of the model inventing false information [[Source - RAG]].

## Relationships

- Contrasts with: In-Context Learning (where context is purely provided in the prompt without a dynamic retrieval step).
