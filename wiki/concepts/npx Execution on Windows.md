---
title: npx Execution on Windows
type: concept
status: active
classification: public
aliases: ["npx.cmd"]
tags: ["node", "npm", "windows"]
sources:
  - "[[Source - FNM Windows Troubleshooting]]"
created: 2026-10-06
updated: 2026-10-06
confidence: high
knowledge_status: current
review_needed: false
---

# npx Execution on Windows

## Definition

On Windows, the Node Package Manager (`npm`) installs global executable tools (including `npx`) as `.cmd` batch wrappers rather than native, extensionless binaries.

## Cross-Platform Configuration Issues

In interactive shells (like PowerShell or CMD), typing `npx` works because the shell automatically resolves the `.cmd` extension. However, programmatic launchers, child-process spawners, and cross-platform configuration files (e.g., VS Code tasks, Model Context Protocol configurations) often search explicitly for a literal executable named `npx` [[Source - FNM Windows Troubleshooting]].

If the execution environment does not inherit the shell's extension resolution or the dynamically injected `PATH` (such as one managed by FNM), it will throw an `executable file not found` error [[Source - FNM Windows Troubleshooting]].

To resolve this reliably on Windows, automated tool configurations must explicitly invoke the Windows command processor to run the wrapper script:
```json
{
  "command": "cmd",
  "args": [
    "/c",
    "npx.cmd",
    "..."
  ]
}
```

## Relationships

- None
