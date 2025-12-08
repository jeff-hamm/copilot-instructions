# Global File Management
Use this prompt whenever you edit my global settings, instructions, or prompts.

## Rules
- Create a backup before modifying any global file
- Show the diff and explain the change
- If I approve, stage and commit the change

## Global Settings
- Location: PowerShell `$Env:AppData\\Code\\User\\`, cmd `%APPDATA%/Code/User/`, Linux `$HOME/.config/Code/User/`
- Files: `settings.json`, `tasks.json`, `mcp.json`
- I may call these "my settings", "global settings", or "global files"
- Check for an existing setting before adding new values; edit or append as needed
- Validate the file to prevent duplicates before finishing

## Global Instructions
- Location: `${userHome}/.github/instructions`
- Files: `copilot-instructions.md` (all filetypes) or `<NAME>.instructions.md` (file-specific)
- I may call these "global rules", "your instructions", or "your rules"
- Keep wording terse and actionable
- Review the result for clarity and duplication

## Global Prompts
- Location: `${userHome}/.github/prompts`
- Files: all markdown files ending in `.prompt.md`
- I may call these "global prompts", "your prompts", or "reusable prompts"
- When adding a prompt, check to see if another prompt has similar functionality and can be edited before adding a new one