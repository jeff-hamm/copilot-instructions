# Scope And Profile Resolution

Use this reference from user-profile skills to resolve target scope and paths without duplicating logic across VS Code and Cursor.

## Resolve $VSCODE_PROFILE
1. Determine editor family and channel/profile path candidates:
  - VS Code Windows Stable: `$Env:AppData\Code\User\`
  - VS Code Windows Insiders: `$Env:AppData\Code - Insiders\User\`
  - VS Code macOS Stable: `$HOME/Library/Application Support/Code/User/`
  - VS Code macOS Insiders: `$HOME/Library/Application Support/Code - Insiders/User/`
  - VS Code Linux Stable: `$HOME/.config/Code/User/`
  - VS Code Linux Insiders: `$HOME/.config/Code - Insiders/User/`
  - Cursor Windows: `$Env:AppData\Cursor\User\`
  - Cursor macOS: `$HOME/Library/Application Support/Cursor/User/`
  - Cursor Linux: `$HOME/.config/Cursor/User/`
2. If active profile cannot be determined from settings/profiles metadata, use the detected editor/channel base path.
3. Treat this resolved path as `$VSCODE_PROFILE` for compatibility with existing prompt/instruction conventions.

## Scope Modes
- `workspace`: current repository/workspace files.
- `profile`: VS Code or Cursor profile-level user customizations.
- `global`: managed global files under `$VSCODE_PROFILE` used by this setup.

## Path Mapping

### Settings And Config
- `global`:
  - `$VSCODE_PROFILE/settings.json`
  - `$VSCODE_PROFILE/tasks.json`
  - `$VSCODE_PROFILE/mcp.json`
  - `$VSCODE_PROFILE/keybindings.json`
- `workspace`:
  - `.vscode/settings.json`
  - `.vscode/tasks.json`
  - `.vscode/mcp.json` (if used)
  - `.vscode/keybindings.json` (if used)

### Instructions
- `global`:
  - `$VSCODE_PROFILE/instructions/`
- `profile` (supported in VS Code and Cursor when using profile prompt/instruction files):
  - `$VSCODE_PROFILE/prompts/*.instructions.md`
- `workspace`:
  - `.github/instructions/*.instructions.md`
  - or workspace-level `copilot-instructions.md` where applicable

### Prompts
- `global`:
  - `$VSCODE_PROFILE/prompts/*.prompt.md`
- `profile` (supported in VS Code and Cursor when using profile prompt files):
  - `$VSCODE_PROFILE/prompts/*.prompt.md`
- `workspace`:
  - `.github/prompts/*.prompt.md`

### Skills
- `profile` (preferred default):
  - `~/.agents/skills/<name>/SKILL.md`
- `workspace`:
  - `.agents/skills/<name>/SKILL.md`
- Prefer `.agents/` over `.copilot/` or `.github/` for skills.

## Backup Rule
- Use exactly one `.bak` file per target file per change.
- If `<filename>.bak` already exists, rotate it to `<filename>.bak.tmp` (deleting existing `.bak.tmp` first) before creating a new `.bak`.
