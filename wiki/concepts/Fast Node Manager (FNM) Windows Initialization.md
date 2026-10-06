---
title: Fast Node Manager (FNM) Windows Initialization
type: concept
status: active
classification: public
aliases: ["FNM Initialization"]
tags: ["node", "fnm", "windows", "powershell"]
sources:
  - "[[Source - FNM Windows Troubleshooting]]"
created: 2026-10-06
updated: 2026-10-06
confidence: high
knowledge_status: current
review_needed: false
---

# Fast Node Manager (FNM) Windows Initialization

## Definition

Fast Node Manager (FNM) uses dynamic shell initialization rather than static system environment variables to manage Node.js versions. To expose `node` and `npm`, the shell must run `fnm env` at startup to inject the target version into the current session's `PATH` [[Source - FNM Windows Troubleshooting]].

## Resilience against OneDrive Folder Redirection

On Windows, the standard current-user PowerShell profile is located in the user's `Documents` directory. Because Windows features like OneDrive Folder Backup (Known Folder Move) can redirect `Documents` to a cloud-synced path, the profile may fail to execute if OneDrive is unlinked, syncing, or offline [[Source - FNM Windows Troubleshooting]].

When the profile fails, FNM never initializes, leaving `node` unrecognized despite a successful installation.

**Workarounds:**
- **PowerShell**: Write the FNM initialization hook to `$PROFILE.AllUsersCurrentHost`. This profile resides in the local PowerShell application directory, entirely bypassing the fragile OneDrive virtualization layer [[Source - FNM Windows Troubleshooting]].
- **CMD**: Register an AutoRun script in the Windows Registry (`HKCU\Software\Microsoft\Command Processor`) to execute `fnm env` whenever a Command Prompt opens [[Source - FNM Windows Troubleshooting]].

## Relationships

- None
