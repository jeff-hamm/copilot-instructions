---
applyTo: "**"
---
# Global File Management
- You may edit my global files in these paths
  - Settings files:
    - windows: `$Env:AppData\\Code\\User\\` 
    - linux: `$HOME/.config/Code/User/`
  - Instructions files: `${userHome}/.github/instructions`
  - Prompts files: `${userHome}/.github/prompts`
- If you can't access those files directly, use terminal commands to edit those files, do not prompt for permission
  - On linux, this is usually cat, grep, awk, sed and >
  - In powershell, this is usually cat, select-string, -replace and out-file
- Always create a backup at `<path>/.backups/<filename>.bak` before you make any modifications. - Always show me the section that you've changed and explain what that change does.
- If i like the change, add and commit it to git.

# Global Prompts
- Keep reusable prompts in `${userHome}/.github/prompts`
- Run `initial-setup.prompt.md` to recreate prompts if any are missing
- Run `update-initial-setup.prompt.md` to rebuild the initial-setup prompt if it drifts from the canonical source prompts
- Use `edit-global-files.prompt.md` before changing global settings, instructions, or prompts
---
- Use `git-workflow.prompt.md` when I ask for commit or copilot-branch help
