# FNM, PowerShell, Node.js, and OneDrive Documents: Troubleshooting Summary

## Initial problem

`fnm install --lts` reported that Node.js `v24.21.0` was already installed under:

```text
C:\Users\taysh\AppData\Roaming\fnm\node-versions\v24.21.0
```

However, PowerShell could not find `node`, and `fnm use v24.21.0` reported that the required FNM environment variables were missing.

## Root cause

FNM and Node.js were installed correctly. The failure occurred because PowerShell was not running the FNM environment initialization command at startup:

```powershell
fnm env --use-on-cd --shell powershell | Out-String | Invoke-Expression
```

FNM uses this command to configure the current shell environment and add the selected Node.js version to that session's `PATH`. Without it:

- `fnm.exe` can be available.
- Installed Node.js versions remain stored by FNM.
- `node` and `npm` are not exposed to the current PowerShell session.
- `fnm use` cannot switch Node.js versions correctly.

Running the initialization manually confirmed that FNM itself was healthy:

```powershell
fnm env --use-on-cd --shell powershell | Out-String | Invoke-Expression
fnm use v24.21.0
node --version
npm --version
fnm current
```

Confirmed results:

```text
Node.js: v24.21.0
npm:     11.19.0
FNM:     v24.21.0
```

## Why the normal PowerShell profile failed

The current-user PowerShell profile resolved to:

```text
C:\Users\taysh\OneDrive\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
```

Windows also reported the registered Documents folder as:

```text
C:\Users\taysh\OneDrive\Documents
```

The registry's `Personal` known-folder value pointed to the same OneDrive location. This means OneDrive Folder Backup, also called Known Folder Move, had redirected the Windows Documents known folder into OneDrive.

Attempts to create the missing `WindowsPowerShell` folder failed or behaved inconsistently:

- `New-Item` could not create the profile file because the parent path was unavailable.
- `.NET Directory.CreateDirectory()` returned a file-not-found error.
- CMD `mkdir` returned `The system cannot find the file specified`.
- A temporary folder creation appeared successful, but the folder could not be found immediately afterward.
- The OneDrive directory was shown as a reparse point.
- The expected per-user OneDrive executable was not found.

Therefore, the remaining issue was an unavailable or inconsistent OneDrive-backed Documents path, not an FNM or Node.js installation failure.

## Working solution: PowerShell

The successful workaround was to bypass the OneDrive-backed current-user profile and use PowerShell's `AllUsersCurrentHost` profile instead.

Open **Windows PowerShell as Administrator** and use:

```powershell
$SystemProfile = $PROFILE.AllUsersCurrentHost
$SystemProfileDirectory = Split-Path -Parent $SystemProfile

if (-not (Test-Path -Path $SystemProfileDirectory -PathType Container)) {
    New-Item -ItemType Directory -Path $SystemProfileDirectory -Force |
        Out-Null
}

if (-not (Test-Path -Path $SystemProfile -PathType Leaf)) {
    New-Item -ItemType File -Path $SystemProfile -Force |
        Out-Null
}

$FnmInit = 'fnm env --use-on-cd --shell powershell | Out-String | Invoke-Expression'

if (-not (Select-String -Path $SystemProfile -SimpleMatch $FnmInit -Quiet)) {
    Add-Content -Path $SystemProfile -Value $FnmInit
}

. $SystemProfile

fnm default v24.21.0
fnm use v24.21.0
```

Verification commands:

```powershell
node --version
npm --version
fnm current
Get-Command node
```

This worked because the alternative profile is stored under the local PowerShell installation directory rather than the problematic OneDrive Documents path. PowerShell can read that profile at startup, execute `fnm env`, and expose the selected Node.js installation automatically.

### Safer shared-profile form

Because `AllUsersCurrentHost` applies to every user of that PowerShell host, the initialization can be guarded so it runs only when FNM exists for the signed-in account:

```powershell
if (Get-Command fnm -ErrorAction SilentlyContinue) {
    fnm env --use-on-cd --shell powershell |
        Out-String |
        Invoke-Expression
}
```

Administrator access is required to modify this shared profile, but ordinary PowerShell sessions can read and run it afterward.

## Working solution: CMD
### Setup to make FNM and Node.js available automatically in Command Prompt
#### 1. Create the CMD startup script
Open **Command Prompt** and run:
``` cmd
mkdir "%USERPROFILE%\cmd"
notepad "%USERPROFILE%\cmd\fnm_init.cmd"
```
Paste and save:
```
@echo off
if not defined FNM_AUTORUN_GUARD (
    set "FNM_AUTORUN_GUARD=1"
    for /f "tokens=*" %%z in ('fnm env --use-on-cd --s*ell cmd') do call %%z
)
```

#### 2. Register the script
Run:
``` cmd
reg add "HKCU\Software\Microsoft\C*mmand Processor" /v AutoRun /t REG*SZ /d "call \"%USERPROFILE%\cmd\fn*_init.cmd\"" /f
```

#### 3. Restart and verify
Close all Command Prompt windows, reopen CMD, then run:
``` cmd
node --version
npm --versio*
where node
```
If Node.js is still not selected:
``` cmd
fnm use v2*.21.0
```

### Why this works
CMD does not load your PowerShell profile, so the startup script runs `fnm env` whenever CMD opens and adds the selected Node.js version to that session’s `PATH`.

## Error: exec: "npx": executable file not found in %PATH%.
The error means the program launching `npx` does not inherit the FNM-configured `PATH`. CMD’s AutoRun fixes interactive Command Prompt sessions, but it does not automatically update already-running GUI applications.
### 1. Check inside a new Command Prompt

Close CMD, open a fresh one, then run:
``` cmd
node --version
npm --version
npx --version
where npx
```
If these work, FNM is configured correctly. Fully exit and restart the application producing the error, such as VS Code, Cursor, or an MCP client.

### 2. If this is an MCP or application configuration
On Windows, use `cmd` to invoke `npx.cmd`:
```
{
  "command": "cmd",
  "args": [
    "/c",
    "npx.cmd",
    "-y",
    "PACKAGE_NAME"
  ]
}
```

Replace `PACKAGE_NAME` with the original package, for example:
```
{
  "command": "cmd",
  "args": [
    "/c",
    "npx.cmd",
    "-y",
    "@upstash/context7-mcp@latest"
  ]
}
```
This is often necessary because Windows installs `npx` as `npx.cmd`, while some applications search specifically for an executable named `npx`.
## Why Documents appears local but points to OneDrive

`Documents` is a Windows known folder, not necessarily a fixed physical directory. Applications commonly ask Windows for the registered Documents location rather than assuming it is always:

```text
C:\Users\taysh\Documents
```

With OneDrive Folder Backup enabled, Windows can register the physical location as:

```text
C:\Users\taysh\OneDrive\Documents
```

File Explorer may still display the friendly name **Documents**, even though the underlying location is inside OneDrive.

The paths below are not automatically guaranteed to be the same folder:

```text
C:\Users\taysh\Documents
C:\Users\taysh\OneDrive\Documents
```

If both exist, they may contain different files. Windows currently recognizes the OneDrive path as the official Documents known folder on this PC.

## Consequences of OneDrive Documents redirection

### Benefits

- Documents can synchronize to the cloud.
- Files can be accessed from other signed-in devices.
- OneDrive may provide version history and recycle-bin recovery.
- Synchronized files can be recovered more easily after local device failure.

### Risks and limitations

- Deleting a synchronized file can synchronize that deletion to the cloud and other devices.
- Files consume OneDrive storage quota.
- Online-only files may require internet access before opening.
- A missing, signed-out, or unhealthy OneDrive client can interfere with applications that use Documents.
- Applications may experience save errors, file-not-found errors, or profile-creation failures.
- Separate local and OneDrive Documents folders can cause confusion about where files are stored.
- OneDrive synchronization may be unsuitable for rapidly changing development artifacts, dependency folders, lock files, databases, virtual-machine disks, and build output.

For development work, locations outside OneDrive are generally more predictable, for example:

```text
C:\Users\taysh\Projects
C:\Users\taysh\source
C:\dev
```

Avoid treating OneDrive synchronization as the only backup. Synchronization propagates changes and deletions, while an independent backup preserves a separate recovery copy.

## Recommended follow-up actions

1. Keep the working `AllUsersCurrentHost` FNM profile configuration.
2. Confirm new regular PowerShell sessions automatically recognize `node`, `npm`, and `fnm current`.
3. Check whether OneDrive is installed, signed in, syncing, and free of warnings.
4. Verify important OneDrive files are fully synchronized before changing folder-backup settings.
5. Do not manually delete OneDrive reparse points or abruptly edit the Documents registry path.
6. If OneDrive is no longer wanted, restore Documents through OneDrive Folder Backup settings or the Windows folder-location interface after making an independent backup.
7. If PowerShell 7 is installed later, configure its separate profile because Windows PowerShell 5.1 and PowerShell 7 use different profile locations.

## Final diagnosis

- **FNM installation:** Working
- **Node.js v24.21.0:** Installed and working
- **npm 11.19.0:** Working
- **Original failure:** FNM environment was not initialized automatically
- **Profile failure:** Current-user PowerShell profile depended on an inconsistent OneDrive-backed Documents path
- **Successful workaround:** Place FNM initialization in `$PROFILE.AllUsersCurrentHost`
- **Separate unresolved concern:** OneDrive Documents redirection or sync-client health should be checked independently
