---
title: Antigravity Sandbox Isolation
type: concept
status: active
classification: public
aliases: ["Agy Sandbox"]
tags: ["sandbox", "security", "antigravity", "cli"]
sources:
  - "[[Source - Antigravity Sandbox Setup]]"
created: 2026-10-06
updated: 2026-10-06
confidence: high
knowledge_status: current
review_needed: false
---

# Antigravity Sandbox Isolation

## Definition

Antigravity Sandbox Isolation is the architectural pattern of running the Antigravity CLI (`agy`) entirely within a controlled Docker `sbx` container environment, ensuring the host machine remains insulated from AI-driven operations.

## Key points

- **Network Policy Control**: By default, sandboxes restrict outbound traffic. Installing and updating the CLI requires explicitly whitelisting domains (e.g., `antigravity.google` and updater services) via `sbx policy allow network` [[Source - Antigravity Sandbox Setup]].
- **Data Isolation**: The CLI installation, its execution binaries, and critical authentication state (like `~/.gemini/oauth_creds.json`) are maintained entirely within the sandbox's `/home/agent` user directory, ensuring no leakage to the host OS [[Source - Antigravity Sandbox Setup]].
- **Execution Safeguards**: When operating in a sandbox, it is recommended to launch `agy` with strict directory targeting (`-w`) and to operate in a `request-review` permission mode to verify the AI's actions before execution [[Source - Antigravity Sandbox Setup]].

## Relationships

- None
