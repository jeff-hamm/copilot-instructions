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

## Finding $VSCODE_PROFILE
- Windows: `$Env:AppData\Code\User\`
- macOS: `$HOME/Library/Application Support/Code/User/`
- Linux: `$HOME/.config/Code/User/`

## What To Do
1. **Explore** `/prompts/` for existing prompts and agents
2. **Check** settings.json for existing values before adding
3. **Use** `edit-global-files.readonly.prompt.md` for detailed editing guidance
4. **Run** `initial-setup.readonly.prompt.md` if core files are missing

---

⚠️ **STOP: Before editing ANY file listed above, you MUST first read `$VSCODE_PROFILE/prompts/edit-global-files.readonly.prompt.md` for required permissions, backup procedures, and editing rules.**
