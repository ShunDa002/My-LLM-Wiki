---
title: Source - Claude Code Sandbox Setup
type: source
raw_file: "[[raw/notes/sbx-Sandbox/Claude-Code-Sandbox.md]]"
source_id: d974e83302459108ef01d1f4ebf801194801c8da18ce9c41cca2725c93bee6aa
source_kind: notes
author: Unknown
classification: public
captured: 2026-10-06
ingested: 2026-10-06
status: processed
---

# Source - Claude Code Sandbox Setup

## What this source is

A technical guide describing how to run, monitor, and provision the Claude Code agentic CLI inside a Docker `sbx` sandbox environment.

## Claims taken from it

- Claude Code can be launched inside a sandbox using the command `sbx run claude`.
- Using the `--dangerously-skip-permissions` flag inside the sandbox mitigates host machine risks, but still grants the agent autonomous write access to any project directory mounted into the container.
- Launching with the `agents` flag opens a multi-session dashboard (Claude Code Agent View) to monitor, interact with, and manage simultaneous AI tasks.
- Sandboxes can be declaratively provisioned using a `spec.yaml` kit file to preconfigure permissions, add third-party plugin marketplaces, and auto-install plugins.

## What it changed in the Wiki

- Created: [[Claude Code Sandbox Execution]]

## Not used

- Windows winget installation steps for Docker sbx itself, as the focus is on the CLI execution and provisioning pattern.
