# LLM Wiki Vault

This is a human-directed, Antigravity-maintained Obsidian LLM Wiki.

## Zones

- `raw/`: immutable source evidence
- `dev/`: human-led working and learning notes
- `wiki/`: canonical agent-maintained knowledge

## Runtime

Antigravity CLI runs inside a Docker sbx microVM.

The Vault is mounted as a writable workspace. Docker sbx protects the host
outside the workspace, while AGENTS.md, human approvals, and Git protect
the knowledge system inside the workspace.
