---
title: Claude Code Sandbox Execution
type: concept
status: active
classification: public
aliases: ["Claude Code sbx"]
tags: ["sandbox", "security", "claude-code", "cli", "agentic-ai"]
sources:
  - "[[Source - Claude Code Sandbox Setup]]"
created: 2026-10-06
updated: 2026-10-06
confidence: high
knowledge_status: current
review_needed: false
---

# Claude Code Sandbox Execution

## Definition

Claude Code Sandbox Execution refers to the workflow and configuration mechanisms for running the Claude Code agentic AI safely and scalably inside a Docker `sbx` container environment.

## Key points

- **Autonomous Execution Boundaries**: Executing the agent autonomously (e.g., with `--dangerously-skip-permissions`) inside a sandbox is inherently safer than host-execution. However, because the user's project directory is typically mounted into the container, the agent still has unfettered access to modify those specific project files [[Source - Claude Code Sandbox Setup]].
- **Multi-Session Management**: The sandbox supports an Agent View interface (triggered via the `agents` parameter) that provides a centralized dashboard. This allows operators to run, monitor, and seamlessly attach to multiple concurrent agent tasks from a single terminal [[Source - Claude Code Sandbox Setup]].
- **Declarative Provisioning (Kits)**: Claude Code sandboxes can be bootstrapped from a `spec.yaml` definition kit. This allows operations to declaratively set network allowlists, register custom plugin marketplaces, and pre-install external tooling plugins (e.g., `superpowers`, `ponytail`, `caveman`) automatically during container creation [[Source - Claude Code Sandbox Setup]].

## Relationships

- Related: [[Agentic AI]]
