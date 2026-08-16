# Stage 1 Git Policy

## Scope

Load this document before issuing any Git command.

## Allowed commands

Only these Git commands are allowed, with options that preserve read-only behavior:

- `git status`
- `git diff`
- `git log`
- `git show`

Before adding an unfamiliar option, verify that it does not modify the working tree, index, history, branches, remotes, or configuration.

## Prohibited commands

Do not run any Git write or state-changing command, including:

- `git add`
- `git commit`
- `git push`
- `git pull`
- `git fetch`
- `git reset`
- `git clean`
- `git rebase`
- `git checkout`
- `git switch`
- `git restore`
- `git merge`
- `git cherry-pick`
- `git revert`
- `git stash`
- `git branch`
- `git remote`
- `git config`

There is no conversational override during Stage 1.

## When a Git write seems necessary

1. Explain why it may be needed.
2. Show the exact proposed command.
3. Explain its expected effect and risk.
4. Ask the human to run it manually on the host.
5. Do not execute it.
6. Reinspect the resulting state afterward only with allowed read-only commands.
