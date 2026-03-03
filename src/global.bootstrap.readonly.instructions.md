---
applyTo: "**"
---
# NEVER EDIT THIS FILE

## Your Editable Directories
You can read, create, and edit files in these `$VSCODE_PROFILE` locations:

| Location | Contents | File Pattern |
|----------|----------|--------------|
| `/settings.json` | VS Code/Cursor & Copilot settings | - |
| `/instructions/` | Rules applied to all chats | `*.instructions.md` |
| `/prompts/` | Reusable prompts | `*.prompt.md` |
| `/prompts/` | Custom agents | `*.agent.md` |
| `~/.agents/skills/` | User-profile slash skills | `*/SKILL.md` |

**Exception:** Never edit `*.readonly.*.md` files.

## Terminology
- "global settings", "my settings" -> `settings.json`, `tasks.json`, `mcp.json`
- "global rules", "your instructions" -> files in `/instructions/`
- "global prompts", "reusable prompts" -> files in `/prompts/`
- "global skills", "your skills" -> files in `~/.agents/skills/`

## Workspace Customization Path Preference
- For workspace-level customizations, prefer `.agents/` over `.copilot/` or `.github/`.
- Prefer `.agents/skills/<name>/` for workspace skills.

## User Skill Commands
- Prefer user-profile skills in `~/.agents/skills/` for global file edits.
- Preferred commands:
  - `/setting`
  - `/create-instruction`
  - `/create-prompt-global`
  - `/create-skill-global`
  - `/update-jumper-prompts`
- Use `edit-global-files.readonly.prompt.md` as fallback guidance when those skills are not available.

## Finding $VSCODE_PROFILE
- Windows (Stable): `$Env:AppData\Code\User\`
- Windows (Insiders): `$Env:AppData\Code - Insiders\User\`
- Windows (Cursor): `$Env:AppData\Cursor\User\`
- macOS (Stable): `$HOME/Library/Application Support/Code/User/`
- macOS (Insiders): `$HOME/Library/Application Support/Code - Insiders/User/`
- macOS (Cursor): `$HOME/Library/Application Support/Cursor/User/`
- Linux (Stable): `$HOME/.config/Code/User/`
- Linux (Insiders): `$HOME/.config/Code - Insiders/User/`
- Linux (Cursor): `$HOME/.config/Cursor/User/`

## What To Do
1. **Explore** `/prompts/` for existing prompts and agents
2. **Use** preferred user skills (`/setting`, `/create-instruction`, `/create-prompt-global`, `/create-skill-global`, `/update-jumper-prompts`) for global edits
3. **Check** settings.json for existing values before adding
4. **Use** `edit-global-files.readonly.prompt.md` for fallback editing guidance
5. **Run** `initial-setup.readonly.prompt.md` if core files are missing

---

⚠️ **STOP: Before editing ANY file listed above, you MUST first read `$VSCODE_PROFILE/prompts/edit-global-files.readonly.prompt.md` for required permissions, backup procedures, and editing rules.**
