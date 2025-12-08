# Initial Copilot Setup

Use this prompt when reusable prompts or global instructions are missing, or when preparing a fresh environment.

## Environment preparation
- Install git if it is not already installed
- If ${userHome}/.github is not a git repository, clone it from https://github.com/jeff-hamm/copilot-instructions, or, if that fails, initialize a new git repository there
  - If you create it, the .gitignore should be
    ```
    *
    !instructions/
    !prompts/
    !copilot-instructions.md
    ```
- Set mys global `github.copilot.chat.codeGeneration.useInstructionFiles` setting to `true`
- If it doesn't already exist, append `${userHome}/.github/instructions` to the global setting `github.copilot.chat.codeGeneration.instructions` list
- If it doesn't already exist, append `${userHome}/.github/prompts` to the global setting `github.copilot.chat.promptFilesLocations` list
- If `${userHome}/.github/instructions/copilot-instructions.md` file is missing, create it and copy the full contents of `copilot-instructions.md` into it, preserving the `applyTo: "**"` header"

## Recreate reusable prompts

Create or update these files under `${userHome}/.github/prompts`

### edit-global-files.prompt.md

```markdown
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
```

### git-workflow.prompt.md

```markdown
# Git Workflow
Use this prompt when I ask you to use or work with a copilot branch.
- Write commit messages that explain what changed and why
- Before working on a copilot branch, check whether `<current branch>_copilot` exists; create it if it does not
- Use `git worktree` when I ask you to commit to a copilot branch; otherwise use the current branch

```

### Update copilot-instructions.md

```markdown
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
- Always create a backup in the `<path>/.backups` directory before you make any modifications
- Always show me the section that you've changed and explain what that change does.
- If i like the change, add and commit it to git.

# Global Prompts
- Keep reusable prompts in `${userHome}/.github/prompts`
- Run `initial-setup.prompt.md` to recreate prompts if any are missing
- Run `update-initial-setup.prompt.md` to rebuild the initial-setup prompt if it drifts from the canonical source prompts
- Use `edit-global-files.prompt.md` before changing global settings, instructions, or prompts
---
- Use `git-workflow.prompt.md` when I ask for commit or copilot-branch help

```