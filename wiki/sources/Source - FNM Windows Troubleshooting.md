---
title: Source - FNM Windows Troubleshooting
type: source
raw_file: "[[raw/notes/fnm-powershell-onedrive-troubleshooting.md]]"
source_id: 244e02a891e6b3c086e13e8b497ae3fcfdf64243e2a58515f93c0e6b83f3cbb8
source_kind: notes
author: Unknown
classification: public
captured: 2026-10-06
ingested: 2026-10-06
status: processed
---

# Source - FNM Windows Troubleshooting

## What this source is

A troubleshooting summary detailing how to fix Fast Node Manager (FNM) shell initialization issues on Windows, particularly when OneDrive folder redirection breaks standard PowerShell profiles.

## Claims taken from it

- FNM relies on executing an initialization script (`fnm env`) at shell startup to inject the selected Node.js version into the current session's `PATH`.
- Windows Known Folder Move (OneDrive Folder Backup) frequently redirects the current-user Documents folder to a cloud-synced location. If this path becomes unavailable or inconsistent, the user's standard PowerShell profile (`Microsoft.PowerShell_profile.ps1`) fails to load, preventing FNM from initializing.
- This failure can be bypassed by placing the FNM initialization command inside the shared `$PROFILE.AllUsersCurrentHost` profile, which is stored safely within the local PowerShell installation directory.
- On Windows, `npm` and `npx` are installed as `.cmd` wrappers rather than native executable binaries. Automated launch configurations (such as for MCP servers) must explicitly invoke `cmd /c npx.cmd` to inherit the `PATH` correctly.

## What it changed in the Wiki

- Created: [[Fast Node Manager (FNM) Windows Initialization]]
- Created: [[npx Execution on Windows]]

## Not used

- Deep evaluation of OneDrive's sync limitations (e.g., storage quotas, online-only files), as they are generic filesystem observations unrelated to the core Node/FNM architecture.
