# Initial Copilot Setup
Use this prompt when reusable prompts or global instructions are missing, or when preparing a fresh environment.

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
  4. Once you have that path, make sure it is a git repository.
    - If `$VSCODE_PROFILE` is not a git repository, clone it from https://github.com/jeff-hamm/copilot-instructions, or, if that fails, initialize a new git repository there
      - If you create it, the .gitignore should be
        ```
        *
        !.gitignore
        !instructions/
        !instructions/**
        !prompts/
        !prompts/**
        !copilot-instructions.md
        !/*.json
        ```
## Permissions
- You may view my vscode configuration and any paths and files specified below
- If you can't access those files directly, use terminal commands to read those files, do not prompt for permission
- *NEVER* Edit or remove a file with a `.readonly.*.md` file extension. You may read them though.
- You may edit files in  `$VSCODE_PROFILE` without the `.readonly.*.md` extension per each section below.  
  - If you can't edit those files directly, use terminal commands to read those files, do not prompt for permission
    - If a file must be written from the terminal
      - Linux/macOS: wrap the block in `cat <<'EOF' > …` so the shell copies it exactly 
      - Powershell: use a literal PowerShell here-string and Set-Content -Encoding UTF8 to avoid quoting problems.
      - Example:
        ```powershell
        @'
        <paste the markdown block verbatim>
        '@ | Set-Content -Path "$VSCODE_PROFILE\prompts\edit-global-files.readonly.prompt.md" -Encoding UTF8
        ```        
## Backup
- Before making a change to any file in `$VSCODE_PROFILE`
  - check to see if t `$VSCODE_PROFILE` has any uncommitted changes with `git status`. If so, prompt me to review and commit or stash them first. If I'd like to commit them, create a commit message summarizing the changes and commit them.
  - Always Create a backup at `<filename>.bak` before modifying any global file. If that file exists, rename to `<filename>.bak.tmp` (if that exists, delete it)
- After making changes to any file in `$VSCODE_PROFILE`:
  1. Show the diff with `git diff <filename>`
  2. Show diff summary with `git diff --stat <filename>`, also explain what changed and why
  3. Ask if I approve
    - if no, revert it by renaming `<filename>.bak` to `<filename>` and `<filename>.bak.tmp` to `<filename>.bak`
    - if yes
      1. Stage the changes with `git add <filename>`
      2. Commit with a descriptive message using `git commit -m "..."`
      3. Confirm the commit was successful

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
  - Add/Edit all markdown files that do NOT end in `.readonly.*.md`
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
    !instructions/
    !instructions/**
    !prompts/
    !prompts/**
    !copilot-instructions.md
    !/*.json
    ```
- If `$VSCODE_PROFILE/instructions/global.readonly.instructions.md` file is missing, create it and copy the full contents of `global.readonly.instructions.md` into it, preserving the `applyTo: "**"` header"
- Update my settings as below. Use careful string manipulation that accounts for JSON escaping requirements. Read the existing JSON, parse it, modify the object, and write it back (using ConvertFrom-Json and ConvertTo-Json)
  - Set my global `github.copilot.chat.codeGeneration.useInstructionFiles` setting to `true`
  - If it doesn't already exist, append `$VSCODE_PROFILE/instructions` to the global setting `github.copilot.chat.codeGeneration.instructions` and `chat.instructionsFilesLocations` lists
  - If it doesn't already exist, append `$VSCODE_PROFILE/prompts` to the global setting `chat.promptFilesLocations` list


## Recreate prompts and instructions
Create or update these files under `$VSCODE_PROFILE`, for each section title is the filename. Use the section's markdown as the file contents (copy verbatim)

### prompts/edit-global-files.readonly.prompt.md
``````markdown
````prompt
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
  4. Once you have that path, make sure it is a git repository.
    - If `$VSCODE_PROFILE` is not a git repository, clone it from https://github.com/jeff-hamm/copilot-instructions, or, if that fails, initialize a new git repository there
      - If you create it, the .gitignore should be
        ```
        *
        !.gitignore
        !instructions/
        !instructions/**
        !prompts/
        !prompts/**
        !copilot-instructions.md
        !/*.json
        ```
## Permissions
- You may view my vscode configuration and any paths and files specified below
- If you can't access those files directly, use terminal commands to read those files, do not prompt for permission
- *NEVER* Edit or remove a file with a `.readonly.*.md` file extension. You may read them though.
- You may edit files in  `$VSCODE_PROFILE` without the `.readonly.*.md` extension per each section below.  
  - If you can't edit those files directly, use terminal commands to read those files, do not prompt for permission
    - If a file must be written from the terminal
      - Linux/macOS: wrap the block in `cat <<'EOF' > …` so the shell copies it exactly 
      - Powershell: use a literal PowerShell here-string and Set-Content -Encoding UTF8 to avoid quoting problems.
      - Example:
        ```powershell
        @'
        <paste the markdown block verbatim>
        '@ | Set-Content -Path "$VSCODE_PROFILE\prompts\edit-global-files.readonly.prompt.md" -Encoding UTF8
        ```        
## Backup
- Before making a change to any file in `$VSCODE_PROFILE`
  - check to see if t `$VSCODE_PROFILE` has any uncommitted changes with `git status`. If so, prompt me to review and commit or stash them first. If I'd like to commit them, create a commit message summarizing the changes and commit them.
  - Always Create a backup at `<filename>.bak` before modifying any global file. If that file exists, rename to `<filename>.bak.tmp` (if that exists, delete it)
- After making changes to any file in `$VSCODE_PROFILE`:
  1. Show the diff with `git diff <filename>`
  2. Show diff summary with `git diff --stat <filename>`, also explain what changed and why
  3. Ask if I approve
    - if no, revert it by renaming `<filename>.bak` to `<filename>` and `<filename>.bak.tmp` to `<filename>.bak`
    - if yes
      1. Stage the changes with `git add <filename>`
      2. Commit with a descriptive message using `git commit -m "..."`
      3. Confirm the commit was successful

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
  - Add/Edit all markdown files that do NOT end in `.readonly.*.md`
  - Add-Only all other markdown files
- I may call these "global prompts", "your prompts", or "reusable prompts"
- When adding a prompt, check to see if another prompt has similar functionality and can be edited before adding a new one
---
# *IMPORTANT: NEVER EDIT THIS FILE!*

````
``````

### instructions/global.readonly.instructions.md
``````markdown
```instructions
---
applyTo: "**"
---
# Global Prompts
- Run `initial-setup.readonly.prompt.md` to recreate prompts if any are missing
- Run `edit-global-files.readonly.prompt.md` to view, add or edit any global settings, instructions or prompts
```
``````