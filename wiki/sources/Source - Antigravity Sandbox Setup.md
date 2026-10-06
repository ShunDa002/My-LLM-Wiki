---
title: Source - Antigravity Sandbox Setup
type: source
raw_file: "[[raw/notes/sbx-Sandbox/Agy-Sandbox.md]]"
source_id: f928cad6b7512857976c7d9ba988bbdb5d623bf8178cf21723c67e4f2296693c
source_kind: notes
author: Unknown
classification: public
captured: 2026-10-06
ingested: 2026-10-06
status: processed
---

# Source - Antigravity Sandbox Setup

## What this source is

A technical guide describing how to install, configure, and isolate the Antigravity CLI (`agy`) inside a Docker `sbx` sandbox environment.

## Claims taken from it

- `agy` can be fully isolated from the host machine by running it inside a Docker sandbox container.
- Installation requires explicitly allowing installer (`antigravity.google`) and updater (`antigravity-cli-auto-updater...`) domains through the `sbx` network policy.
- To prevent accidental credential exposure, the `~/.gemini/oauth_creds.json` file must be protected, and `request-review` permission modes should be used over autonomous execution.

## What it changed in the Wiki

- Created: [[Antigravity Sandbox Isolation]]

## Not used

- Specific `cmd` and `bash` snippets used to configure the Windows launcher and test the PATH, as they are implementation details of one specific user setup rather than overarching principles.
