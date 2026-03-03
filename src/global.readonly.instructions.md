---
applyTo: "**"
---
# NEVER EDIT THIS FILE

## Your Editable Directories
You can read, create, and edit files in these `$VSCODE_PROFILE` locations:

| Location | Contents | File Pattern |
|----------|----------|--------------|
| `/settings.json` | VS Code & Copilot settings | - |
| `/instructions/` | Rules applied to all chats | `*.instructions.md` |
| `/prompts/` | Reusable prompts | `*.prompt.md` |
| `/prompts/` | Custom agents | `*.agent.md` |

**Exception:** Never edit `*.readonly.*.md` files.

## Terminology
- "global settings", "my settings" → `settings.json`, `tasks.json`, `mcp.json`
- "global rules", "your instructions" → files in `/instructions/`
- "global prompts", "reusable prompts" → files in `/prompts/`

## Workspace Customization Path Preference
- For workspace-level customizations, prefer `.agents/` over `.copilot/` or `.github/`.
- Prefer `.agents/skills/<name>/` for workspace skills.

## Finding $VSCODE_PROFILE
- Windows (Stable): `$Env:AppData\Code\User\`
- Windows (Insiders): `$Env:AppData\Code - Insiders\User\`
- macOS (Stable): `$HOME/Library/Application Support/Code/User/`
- macOS (Insiders): `$HOME/Library/Application Support/Code - Insiders/User/`
- Linux (Stable): `$HOME/.config/Code/User/`
- Linux (Insiders): `$HOME/.config/Code - Insiders/User/`

## What To Do
1. **Explore** `/prompts/` for existing prompts and agents
2. **Check** settings.json for existing values before adding
3. **Use** `edit-global-files.readonly.prompt.md` for detailed editing guidance
4. **Run** `initial-setup.readonly.prompt.md` if core files are missing

---

⚠️ **STOP: Before editing ANY file listed above, you MUST first read `$VSCODE_PROFILE/prompts/edit-global-files.readonly.prompt.md` for required permissions, backup procedures, and editing rules.**