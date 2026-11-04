---
title: Spec Kit
type: concept
status: active
classification: public
aliases: ["Specification-Driven Development", "SDD", "Specification-Driven Development (SDD)"]
tags: ["sdd", "spec-kit", "agentic-ai", "development-workflow", "engineering"]
sources:
  - "[[Source - Spec Kit]]"
created: 2026-11-03
updated: 2026-11-03
confidence: high
knowledge_status: current
review_needed: false
---

# Spec Kit

## Definition

Spec Kit is a structured framework and workflow methodology for Specification-Driven Development (SDD), designed to guide software engineering with AI coding agents and human developers through phased artifact creation adhering to the progression: Intent → Specification → Design → Execution [[Source - Spec Kit]].

## Key points

- **Phased Artifact Generation**: Each phase generates a dedicated, structured artifact that provides reliable, unambiguous context for subsequent phases, shifting AI agent tasks from subjective interpretation to systematic execution [[Source - Spec Kit]].
- **Core Phases**:
  - `/constitution`: Defines fundamental project principles, constraints, non-negotiable rules, and decision criteria against which all subsequent artifacts are evaluated [[Source - Spec Kit]].
  - `/specify`: Focuses on *what* should be built and *why* using business-oriented language, detailing user needs, business value, expected behavior, and acceptance criteria without implementation details [[Source - Spec Kit]].
  - `/plan`: Translates specifications into *how* the system will be built, addressing technical architecture, system design, dependencies, APIs, and data structures [[Source - Spec Kit]].
  - `/tasks`: Breaks the implementation plan into granular, sequenced, and prioritized work items suitable for engineers or autonomous coding agents [[Source - Spec Kit]].
  - `/implement`: Executes task items into actual code modifications, relying on earlier artifacts to minimize requirement drift [[Source - Spec Kit]].
- **Quality-Gate Phases**:
  - `/clarify`: Identifies edge cases, assumptions, and ambiguous requirements between specification and planning [[Source - Spec Kit]].
  - `/analyze`: Read-only cross-artifact audit (checking the constitution, specification, plan, and tasks) to catch inconsistencies, duplicated work, or architectural violations before writing code [[Source - Spec Kit]].
- **Workflow Profiles**:
  - *Lightweight Workflow*: `/specify` → `/plan` → `/tasks` → `/implement` [[Source - Spec Kit]].
  - *Full Production Workflow*: `/constitution` → `/specify` → `/clarify` → `/plan` → `/tasks` → `/analyze` → `/implement` [[Source - Spec Kit]].

## Relationships

- Related: [[Agentic AI]]
- Related: [[Claude Code Sandbox Execution]]

