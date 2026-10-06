---
title: Source - LangGraph
type: source
raw_file: "[[raw/notes/LangGraph/LangGraph.md]]"
source_id: d359f6a7be0a2080d5e18bf74eac8eb9b18843d968fd6cc78f736e709fce13b9
source_kind: notes
author: Unknown
classification: public
captured: 2026-10-06
ingested: 2026-10-06
status: processed
---

# Source - LangGraph

## What this source is

Notes describing the specific capabilities of LangGraph and how it solves the limitations of using LangChain alone for complex workflows.

## Claims taken from it

- LangChain is best suited for simple, linear workflows and provides the underlying building blocks (e.g., LLMs, prompts, retrievers).
- LangGraph solves LangChain's limitations in complex workflows by providing explicit control flow (nodes, edges, conditional branches).
- LangGraph uses a graph-state model to handle shared state across workflows, unlike LangChain's conversational memory.
- LangGraph supports event-driven execution with interrupts, allowing human-in-the-loop (HITL) workflows.
- LangGraph offers fault tolerance via durable execution and checkpoint-based recovery.
- LangGraph allows nesting subgraphs to modularize multi-agent systems.

## What it changed in the Wiki

- Created: [[LangChain]]
- Updated: [[LangGraph]] — added capabilities and architectural contrast with LangChain.

## Not used

- The distinction between workflow-level vs infrastructure-level faults and retries vs checkpoints, as it is standard software engineering practice rather than LangGraph-specific knowledge.
