# Initial Copilot Setup
Use this prompt when reusable prompts or global instructions are missing, or when preparing a fresh environment.

---
applyTo: "**"
---
# Global Prompts
- Run `initial-setup.readonly.md` to recreate prompts if any are missing
- Run `edit-global-files.readonly.md` to view, add or edit any global settings, instructions or prompts

# *IMPORTANT: NEVER EDIT THIS FILE!*
# Global File Management
Use this prompt whenever you view, edit or remove my global settings, instructions, or prompts.

## Paths
- I will refer to my vscode profile path as `$VSCODE_PROFILE`. To find the location
  1. Find the base VSCode settings path for my OS:
    - powershell: `$Env:AppData\\Code\\User\\`
    - cmd.exe `%APPDATA%/Code/User/`
    - Linux `$HOME/.config/Code/User/`
  2. Try to determine my current profile path by checking
    - setting.json for a key indicating the current profile
    - profiles.json for the current profile
  3. If you cannot determine the profile path, use the VSCode base settings path

## Permissions
- You may view my vscode configuration and any paths and files specified below
- If you can't access those files directly, use terminal commands to read those files, do not prompt for permission
- *NEVER* Edit or remove a file with a `.readonly.md` file extension. You may read them though.
- You may edit without the .readonly.md extension per each section below.  
- If you can't edit those files directly, use terminal commands to read those files, do not prompt for permission
  - On linux, this is usually cat, grep, awk, sed and >
  - In powershell, this is usually cat, select-string, -replace and out-file
- Always Create a backup at `<filname>.bak` before modifying any global file
- Show the diff and explain any changes made
- If I approve, stage and commit the change

## Global Settings
- Files: `$VSCODE_PROFILE/settings.json`, `$VSCODE_PROFILE/tasks.json`, `$VSCODE_PROFILE/mcp.json`
- I may call these "my settings", "global settings", or "global files"
- Check for an existing setting before adding new values; edit or append as needed
- Validate the file to prevent duplicates before finishing

## Global Instructions
- Location: `$VSCODE_PROFILE/instructions`
- Files: `copilot-instructions.md` (all filetypes) or `<NAME>.instructions.md` (file-specific)
- I may call these "global rules", "your instructions", or "your rules"
- Keep wording short and precise. They can significantly reduce my performance if they are too long
- Review the result for clarity and duplication

## Global Prompts
- Location: `$VSCODE_PROFILE/prompts`
- Files
  - Add/Edit all markdown files that do NOT end in `.readonly.md`
  - Add-Only all other markdown files
- I may call these "global prompts", "your prompts", or "reusable prompts"
- When adding a prompt, check to see if another prompt has similar functionality and can be edited before adding a new one
---
# *IMPORTANT: NEVER EDIT THIS FILE!*


## Environment preparation
- Install git if it is not already installed
- If `$VSCODE_PROFILE` is not a git repository, clone it from https://github.com/jeff-hamm/copilot-instructions, or, if that fails, initialize a new git repository there
  - If you create it, the .gitignore should be
    ```
    *
    !.gitignore
    !instructions/**
    !prompts/**
    !copilot-instructions.md
    ```
- Set my global `github.copilot.chat.codeGeneration.useInstructionFiles` setting to `true`
- If it doesn't already exist, append `$VSCODE_PROFILE/instructions` to the global setting `github.copilot.chat.codeGeneration.instructions` and `chat.instructionsFilesLocations` lists
- If it doesn't already exist, append `$VSCODE_PROFILE/prompts` to the global setting `chat.promptFilesLocations` list
- If `$VSCODE_PROFILE/instructions/global-instructions.readonly.md` file is missing, create it and copy the full contents of `global-instructions.readonly.md` into it, preserving the `applyTo: "**"` header"

## Recreate prompts and instructions
Create or update these files under `$VSCODE_PROFILE`

### prompts/edit-global-files.readonly.md
```markdown
# *IMPORTANT: NEVER EDIT THIS FILE!*
# Global File Management
Use this prompt whenever you view, edit or remove my global settings, instructions, or prompts.

## Paths
- I will refer to my vscode profile path as `$VSCODE_PROFILE`. To find the location
  1. Find the base VSCode settings path for my OS:
    - powershell: `$Env:AppData\\Code\\User\\`
    - cmd.exe `%APPDATA%/Code/User/`
    - Linux `$HOME/.config/Code/User/`
  2. Try to determine my current profile path by checking
    - setting.json for a key indicating the current profile
    - profiles.json for the current profile
  3. If you cannot determine the profile path, use the VSCode base settings path

## Permissions
- You may view my vscode configuration and any paths and files specified below
- If you can't access those files directly, use terminal commands to read those files, do not prompt for permission
- *NEVER* Edit or remove a file with a `.readonly.md` file extension. You may read them though.
- You may edit without the .readonly.md extension per each section below.  
- If you can't edit those files directly, use terminal commands to read those files, do not prompt for permission
  - On linux, this is usually cat, grep, awk, sed and >
  - In powershell, this is usually cat, select-string, -replace and out-file
- Always Create a backup at `<filname>.bak` before modifying any global file
- Show the diff and explain any changes made
- If I approve, stage and commit the change

## Global Settings
- Files: `$VSCODE_PROFILE/settings.json`, `$VSCODE_PROFILE/tasks.json`, `$VSCODE_PROFILE/mcp.json`
- I may call these "my settings", "global settings", or "global files"
- Check for an existing setting before adding new values; edit or append as needed
- Validate the file to prevent duplicates before finishing

## Global Instructions
- Location: `$VSCODE_PROFILE/instructions`
- Files: `copilot-instructions.md` (all filetypes) or `<NAME>.instructions.md` (file-specific)
- I may call these "global rules", "your instructions", or "your rules"
- Keep wording short and precise. They can significantly reduce my performance if they are too long
- Review the result for clarity and duplication

## Global Prompts
- Location: `$VSCODE_PROFILE/prompts`
- Files
  - Add/Edit all markdown files that do NOT end in `.readonly.md`
  - Add-Only all other markdown files
- I may call these "global prompts", "your prompts", or "reusable prompts"
- When adding a prompt, check to see if another prompt has similar functionality and can be edited before adding a new one
---
# *IMPORTANT: NEVER EDIT THIS FILE!*
```

### Update instructions/global-file-instructions.readonly.md
```markdown
---
applyTo: "**"
---
- Run `initial-setup.readonly.md` to recreate prompts if any are missing
- Run `edit-global-files.readonly.md` to view, add or edit any global settings, instructions or prompts
```
