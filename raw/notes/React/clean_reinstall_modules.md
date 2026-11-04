# Build Error: Error evaluating Node.js code
## macOS / Linux / Git Bash
``` shell
rm -rf .next node_modules
npm cache verify
npm ci
npm run dev
```
## Windows PowerShell
``` powershell
Remove-Item -Recurse -Force .next, node_modules -ErrorAction SilentlyContinue
npm cache verify
npm ci
npm run dev
```

# If you use another package manager
Do not mix package managers. Use the one matching your lock file.
## pnpm
``` shell
rm -rf .next node_modules
pnpm store prune
pnpm install --frozen-lockfile
pnpm dev
```
## Yarn
``` shell
rm -rf .next node_modules
yarn cache clean
yarn install --frozen-lockfile
yarn dev
```
For Windows PowerShell, replace rm -rf .next node_modules with:
``` powershell
Remove-Item -Recurse -Force .next, node_modules -ErrorAction SilentlyContinue
```
