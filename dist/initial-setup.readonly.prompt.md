# Initial Copilot Setup
Use this prompt when reusable prompts or global instructions are missing, or when preparing a fresh environment.

# *IMPORTANT: NEVER EDIT THIS FILE!*
# Global File Management
Use this prompt whenever you view, edit or remove my global settings, instructions, prompts, or skills.

## Preferred Skills
- Prefer user-profile skills under `~/.agents/skills/` over prompt-only workflows.
- Route requests to these slash commands when applicable:
  - `/setting` for "global settings" or "my settings" (`settings.json`, `tasks.json`, `mcp.json`, `keybindings.json`)
  - `/create-instruction` for "global rules" or "your instructions"
  - `/create-prompt-global` for "global prompts" or "reusable prompts"
  - `/create-skill-global` for "global skills", "your skills", or "slash skills"
  - `/update-jumper-prompts` to update this module from `origin` by downloading `dist/initial-setup.readonly.prompt.md` from raw content and running it as a prompt
- Use this prompt as a fallback only when those skills are missing.

## Paths
- I will refer to my editor profile path as `$VSCODE_PROFILE`. To find the location
  1. Resolve `$VSCODE_PROFILE` for VS Code or Cursor using the active editor profile path.
  2. If the active profile path cannot be determined from settings/profiles metadata, use editor and channel fallback candidates:
    - powershell (Stable): `$Env:AppData\\Code\\User\\`
    - powershell (Insiders): `$Env:AppData\\Code - Insiders\\User\\`
    - powershell (Cursor): `$Env:AppData\\Cursor\\User\\`
    - cmd.exe (Stable): `%APPDATA%/Code/User/`
    - cmd.exe (Insiders): `%APPDATA%/Code - Insiders/User/`
    - cmd.exe (Cursor): `%APPDATA%/Cursor/User/`
    - macOS (Stable): `~/Library/Application Support/Code/User/`
    - macOS (Insiders): `~/Library/Application Support/Code - Insiders/User/`
    - macOS (Cursor): `~/Library/Application Support/Cursor/User/`
    - Linux (Stable): `$HOME/.config/Code/User/`
    - Linux (Insiders): `$HOME/.config/Code - Insiders/User/`
    - Linux (Cursor): `$HOME/.config/Cursor/User/`
  3. Once you have that path, make sure it is a git repository.
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
- I will refer to my user-profile skill path as `$AGENTS_SKILLS_HOME`
  - powershell (Windows): `$HOME\.agents\skills\`
  - cmd.exe (Windows): `%USERPROFILE%/.agents/skills/`
  - macOS: `$HOME/.agents/skills/`
  - Linux: `$HOME/.agents/skills/`
  - Prefer `.agents/` over `.copilot/` or `.github/` for user-level skills.
## Permissions
- You may view my editor configuration and any paths and files specified below
- If you can't access those files directly, use terminal commands to read those files, do not prompt for permission
- *NEVER* Edit or remove a file with a `.readonly.*.md` file extension. You may read them though.
- You may edit files in `$VSCODE_PROFILE` and `$AGENTS_SKILLS_HOME` without the `.readonly.*.md` extension per each section below.
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
- Before making a change to any file in `$VSCODE_PROFILE` or `$AGENTS_SKILLS_HOME`
  - check to see if the target path is in a git repository and has uncommitted changes with `git status`. If so, prompt me to review and commit or stash them first. If I'd like to commit them, create a commit message summarizing the changes and commit them.
  - Create exactly one backup file per change at `<filename>.bak` before modifying any global file. If that file exists, rename it to `<filename>.bak.tmp` (delete existing `.bak.tmp` first) and then create a new `<filename>.bak`.
- After making changes:
  1. If the target path is in git, show the diff with `git diff <filename>` and summary with `git diff --stat <filename>`
  2. If the target path is not in git, show an equivalent before/after comparison
  3. Explain what changed and why
  4. Ask if I approve
    - if no, revert it by renaming `<filename>.bak` to `<filename>` and `<filename>.bak.tmp` to `<filename>.bak`
    - if yes and target path is in git
      1. Stage the changes with `git add <filename>`
      2. Commit with a descriptive message using `git commit -m "..."`
      3. Confirm the commit was successful

## Global Settings
- Files: `$VSCODE_PROFILE/settings.json`, `$VSCODE_PROFILE/tasks.json`, `$VSCODE_PROFILE/mcp.json`, `$VSCODE_PROFILE/keybindings.json`
- I may call these "my settings", "global settings", or "global files"
- Check for an existing setting before adding new values; edit or append as needed
- Validate the file to prevent duplicates before finishing

## Global Instructions
- Locations:
  - global: `$VSCODE_PROFILE/instructions`
  - profile: `$VSCODE_PROFILE/prompts/*.instructions.md` (when profile instruction files are enabled)
- Files: `copilot-instructions.md` (all filetypes) or `<NAME>.instructions.md` (file-specific)
- I may call these "global rules", "your instructions", or "your rules"
- Keep wording short and precise. They can significantly reduce my performance if they are too long
- Review the result for clarity and duplication

## Global Prompts
- Location: `$VSCODE_PROFILE/prompts`
- Files
  - Preferred prompt files: `*.prompt.md`
  - Add/Edit markdown files that do NOT end in `.readonly.*.md`
  - Add-Only files ending in `.readonly.*.md`
- I may call these "global prompts", "your prompts", or "reusable prompts"
- When adding a prompt, check to see if another prompt has similar functionality and can be edited before adding a new one

## Global Skills
- Location (profile default): `$AGENTS_SKILLS_HOME`
- Files: `<SKILL_NAME>/SKILL.md` and optional `scripts/`, `references/`, `assets/`
- I may call these "global skills", "your skills", or "slash skills"
- Ensure `SKILL.md` uses valid frontmatter (`---`, `name`, `description`, optional `argument-hint`, `---`)
- Prefer multiple focused skills over one long procedural prompt
---
# *IMPORTANT: NEVER EDIT THIS FILE!*


## Environment preparation
- Install git if it is not already installed
- Resolve `$VSCODE_PROFILE` for VS Code or Cursor using the active editor profile path.
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
- Ensure the user-profile skill directory exists at `~/.agents/skills/`.
  - Prefer `.agents/` over `.copilot/` or `.github/` for user-level skills.

## Upgrade existing installs from `b9cc57aa67b6b25c5348fe7f807f229b544905c7`
- Detect whether this profile was initialized by that legacy setup prompt:
  - `$VSCODE_PROFILE/prompts/edit-global-files.readonly.prompt.md` exists
  - and either:
    - `$VSCODE_PROFILE/instructions/global.readonly.instructions.md` contains `# Global Prompts` but does not contain `## Included Prompt Files (Generated)`
    - or one or more required user-skill files are missing:
      - `~/.agents/skills/setting/SKILL.md`
      - `~/.agents/skills/create-instruction/SKILL.md`
      - `~/.agents/skills/create-prompt-global/SKILL.md`
      - `~/.agents/skills/create-skill-global/SKILL.md`
      - `~/.agents/skills/update-jumper-prompts/SKILL.md`
- If detected, run an in-place upgrade:
  - Keep existing git history and user-created files.
  - Replace only the files defined in this setup prompt with current contents.
  - Install or update user-profile skills under `~/.agents/skills/` from the embedded sections below.
  - Preserve user-created prompts, instructions, and settings that are not explicitly listed in this setup prompt.
- If not detected, continue normal setup flow.

- If `$VSCODE_PROFILE/instructions/global.readonly.instructions.md` file is missing, create it and copy the full contents of `global.readonly.instructions.md` into it, preserving the `applyTo: "**"` header"
- Update my settings as below. Use careful string manipulation that accounts for JSON escaping requirements. Read the existing JSON, parse it, modify the object, and write it back (using ConvertFrom-Json and ConvertTo-Json). If a setting key is unsupported in the current editor, skip it and report that in your summary.
  - Set my global `github.copilot.chat.codeGeneration.useInstructionFiles` setting to `true`
  - If it doesn't already exist, append `$VSCODE_PROFILE/instructions` to the global setting `github.copilot.chat.codeGeneration.instructions` and `chat.instructionsFilesLocations` lists
  - If it doesn't already exist, append `$VSCODE_PROFILE/prompts` to the global setting `chat.promptFilesLocations` list

## Recreate prompts, instructions, and user-profile skills
Create or update these files under $VSCODE_PROFILE and ~/.agents/skills, where each section title is the filename. Use the section's markdown as the file contents (copy verbatim)

### prompts/edit-global-files.readonly.prompt.md
````markdown
# *IMPORTANT: NEVER EDIT THIS FILE!*
# Global File Management
Use this prompt whenever you view, edit or remove my global settings, instructions, prompts, or skills.

## Preferred Skills
- Prefer user-profile skills under `~/.agents/skills/` over prompt-only workflows.
- Route requests to these slash commands when applicable:
  - `/setting` for "global settings" or "my settings" (`settings.json`, `tasks.json`, `mcp.json`, `keybindings.json`)
  - `/create-instruction` for "global rules" or "your instructions"
  - `/create-prompt-global` for "global prompts" or "reusable prompts"
  - `/create-skill-global` for "global skills", "your skills", or "slash skills"
  - `/update-jumper-prompts` to update this module from `origin` by downloading `dist/initial-setup.readonly.prompt.md` from raw content and running it as a prompt
- Use this prompt as a fallback only when those skills are missing.

## Paths
- I will refer to my editor profile path as `$VSCODE_PROFILE`. To find the location
  1. Resolve `$VSCODE_PROFILE` for VS Code or Cursor using the active editor profile path.
  2. If the active profile path cannot be determined from settings/profiles metadata, use editor and channel fallback candidates:
    - powershell (Stable): `$Env:AppData\\Code\\User\\`
    - powershell (Insiders): `$Env:AppData\\Code - Insiders\\User\\`
    - powershell (Cursor): `$Env:AppData\\Cursor\\User\\`
    - cmd.exe (Stable): `%APPDATA%/Code/User/`
    - cmd.exe (Insiders): `%APPDATA%/Code - Insiders/User/`
    - cmd.exe (Cursor): `%APPDATA%/Cursor/User/`
    - macOS (Stable): `~/Library/Application Support/Code/User/`
    - macOS (Insiders): `~/Library/Application Support/Code - Insiders/User/`
    - macOS (Cursor): `~/Library/Application Support/Cursor/User/`
    - Linux (Stable): `$HOME/.config/Code/User/`
    - Linux (Insiders): `$HOME/.config/Code - Insiders/User/`
    - Linux (Cursor): `$HOME/.config/Cursor/User/`
  3. Once you have that path, make sure it is a git repository.
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
- I will refer to my user-profile skill path as `$AGENTS_SKILLS_HOME`
  - powershell (Windows): `$HOME\.agents\skills\`
  - cmd.exe (Windows): `%USERPROFILE%/.agents/skills/`
  - macOS: `$HOME/.agents/skills/`
  - Linux: `$HOME/.agents/skills/`
  - Prefer `.agents/` over `.copilot/` or `.github/` for user-level skills.
## Permissions
- You may view my editor configuration and any paths and files specified below
- If you can't access those files directly, use terminal commands to read those files, do not prompt for permission
- *NEVER* Edit or remove a file with a `.readonly.*.md` file extension. You may read them though.
- You may edit files in `$VSCODE_PROFILE` and `$AGENTS_SKILLS_HOME` without the `.readonly.*.md` extension per each section below.
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
- Before making a change to any file in `$VSCODE_PROFILE` or `$AGENTS_SKILLS_HOME`
  - check to see if the target path is in a git repository and has uncommitted changes with `git status`. If so, prompt me to review and commit or stash them first. If I'd like to commit them, create a commit message summarizing the changes and commit them.
  - Create exactly one backup file per change at `<filename>.bak` before modifying any global file. If that file exists, rename it to `<filename>.bak.tmp` (delete existing `.bak.tmp` first) and then create a new `<filename>.bak`.
- After making changes:
  1. If the target path is in git, show the diff with `git diff <filename>` and summary with `git diff --stat <filename>`
  2. If the target path is not in git, show an equivalent before/after comparison
  3. Explain what changed and why
  4. Ask if I approve
    - if no, revert it by renaming `<filename>.bak` to `<filename>` and `<filename>.bak.tmp` to `<filename>.bak`
    - if yes and target path is in git
      1. Stage the changes with `git add <filename>`
      2. Commit with a descriptive message using `git commit -m "..."`
      3. Confirm the commit was successful

## Global Settings
- Files: `$VSCODE_PROFILE/settings.json`, `$VSCODE_PROFILE/tasks.json`, `$VSCODE_PROFILE/mcp.json`, `$VSCODE_PROFILE/keybindings.json`
- I may call these "my settings", "global settings", or "global files"
- Check for an existing setting before adding new values; edit or append as needed
- Validate the file to prevent duplicates before finishing

## Global Instructions
- Locations:
  - global: `$VSCODE_PROFILE/instructions`
  - profile: `$VSCODE_PROFILE/prompts/*.instructions.md` (when profile instruction files are enabled)
- Files: `copilot-instructions.md` (all filetypes) or `<NAME>.instructions.md` (file-specific)
- I may call these "global rules", "your instructions", or "your rules"
- Keep wording short and precise. They can significantly reduce my performance if they are too long
- Review the result for clarity and duplication

## Global Prompts
- Location: `$VSCODE_PROFILE/prompts`
- Files
  - Preferred prompt files: `*.prompt.md`
  - Add/Edit markdown files that do NOT end in `.readonly.*.md`
  - Add-Only files ending in `.readonly.*.md`
- I may call these "global prompts", "your prompts", or "reusable prompts"
- When adding a prompt, check to see if another prompt has similar functionality and can be edited before adding a new one

## Global Skills
- Location (profile default): `$AGENTS_SKILLS_HOME`
- Files: `<SKILL_NAME>/SKILL.md` and optional `scripts/`, `references/`, `assets/`
- I may call these "global skills", "your skills", or "slash skills"
- Ensure `SKILL.md` uses valid frontmatter (`---`, `name`, `description`, optional `argument-hint`, `---`)
- Prefer multiple focused skills over one long procedural prompt
---
# *IMPORTANT: NEVER EDIT THIS FILE!*
````

### instructions/global.readonly.instructions.md
````markdown
---
applyTo: "**"
---
# NEVER EDIT THIS FILE

## Global Edit Routing
- Prefer user-profile skills in `~/.agents/skills/`:
	- `/setting`
	- `/create-instruction`
	- `/create-prompt-global`
	- `/create-skill-global`
	- `/update-jumper-prompts`
- Prefer `.agents/` over `.copilot/` or `.github/` for skills.

## Included Prompt Files (Generated)
- `git-workflow.prompt.md`: Use this prompt when I ask you to use or work with a copilot branch.

## Included User Skills (Generated)
- `/create-instruction`: Create or update instruction files for workspace, profile, or global scope. Use for "global rules" or "your instructions" in /instructions/, with backup and approval workflow.
- `/create-prompt-global`: Create or update reusable prompts for workspace, profile, or global scope. Use for "global prompts" or "reusable prompts" in /prompts/, with overlap checks and approval flow.
- `/create-skill-global`: Create or update skills for workspace, profile, or global scope. Use for "global skills" or "your skills" under ~/.agents/skills, with review workflow and profile-level defaults.
- `/setting`: Edit VS Code or Cursor setting/config files with scope-aware targeting. Use for "global settings" or "my settings" including settings.json, tasks.json, mcp.json, and keybindings, with backup, diff review, and approval flow.
- `/update-jumper-prompts`: Download and run this repo\'s bootstrap prompt by fetching dist/initial-setup.readonly.prompt.md from raw GitHub, then running the downloaded prompt file.
````

### prompts/git-workflow.prompt.md
````markdown
# Git Workflow
Use this prompt when I ask you to use or work with a copilot branch.
- Write commit messages that explain what changed and why
- Before working on a copilot branch, check whether `<current branch>_copilot` exists; create it if it does not
- Use `git worktree` when I ask you to commit to a copilot branch; otherwise use the current branch
````

### .agents/skills/common/profile-resolution.md
````markdown
# Scope And Profile Resolution

Use this reference from user-profile skills to resolve target scope and paths without duplicating logic across VS Code and Cursor.

## Resolve $VSCODE_PROFILE
1. Resolve `$VSCODE_PROFILE` for VS Code or Cursor using the active editor profile path.
2. If the active profile path cannot be determined from settings/profiles metadata, use editor and channel fallback candidates:
  - VS Code Windows Stable: `$Env:AppData\Code\User\`
  - VS Code Windows Insiders: `$Env:AppData\Code - Insiders\User\`
  - VS Code macOS Stable: `$HOME/Library/Application Support/Code/User/`
  - VS Code macOS Insiders: `$HOME/Library/Application Support/Code - Insiders/User/`
  - VS Code Linux Stable: `$HOME/.config/Code/User/`
  - VS Code Linux Insiders: `$HOME/.config/Code - Insiders/User/`
  - Cursor Windows: `$Env:AppData\Cursor\User\`
  - Cursor macOS: `$HOME/Library/Application Support/Cursor/User/`
  - Cursor Linux: `$HOME/.config/Cursor/User/`
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
- `global`, `profile` or `user`:
  - `$VSCODE_PROFILE/instructions/`
- `workspace`:
  - `.github/instructions/*.instructions.md`
  - or workspace-level `copilot-instructions.md` where applicable

### Prompts
- `global`, `profile` or `user`:
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
````

### .agents/skills/create-instruction/SKILL.md
````markdown
---
name: create-instruction
description: 'Create or update instruction files for workspace, profile, or global scope. Use for "global rules" or "your instructions" in /instructions/, with backup and approval workflow.'
argument-hint: 'scope=[workspace|profile|global](default:global) name=<instruction-name>'
---

# Create Instruction

Create or update instruction files for workspace/profile/global targets.

## Shared Scope Resolution
- Use [scope reference](../common/profile-resolution.md) to resolve supported profile/global/workspace instruction paths.

## Use When
- You need to create `copilot-instructions.md` or `<name>.instructions.md`.
- You need to refine wording of global rules.
- You need to avoid duplicate or conflicting instruction blocks.

## Scope Notes
- `profile` is supported in VS Code and Cursor via `$VSCODE_PROFILE/prompts/*.instructions.md` when profile instruction files are enabled.
- `global` resolves to `$VSCODE_PROFILE/instructions/` in this setup.

## Required Workflow
1. Resolve target scope and file path using [scope reference](../common/profile-resolution.md).
2. Check `git status` in target repo when git is available.
3. Create exactly one backup file per change at `<filename>.bak`.
4. If `<filename>.bak` exists, rotate to `<filename>.bak.tmp` before creating a new `.bak`.
5. Keep wording concise and non-duplicative.
6. Validate that resulting file is clear and does not repeat existing rules.
7. Show `git diff` and `git diff --stat`.
8. Ask for approval before commit.
9. Commit on approval or restore from backup on rejection.

## Safety Rules
- Never edit `*.readonly.*.md` files.
- Prefer updating an existing instruction file before creating a new one.
````

### .agents/skills/create-prompt-global/SKILL.md
````markdown
---
name: create-prompt-global
description: 'Create or update reusable prompts for workspace, profile, or global scope. Use for "global prompts" or "reusable prompts" in /prompts/, with overlap checks and approval flow.'
argument-hint: 'scope=[workspace|profile|global](default:global) name=<prompt-name>'
---

# Create Prompt Global

Create or update reusable prompt files for workspace/profile/global targets.

## Shared Scope Resolution
- Use [scope reference](../common/profile-resolution.md) for prompt path resolution.

## Use When
- You need a new workflow prompt (`*.prompt.md`).
- You need to improve an existing prompt.
- You need to avoid duplicate prompts that overlap in scope.

## Scope Notes
- `profile` prompt files are supported in VS Code and Cursor when profile prompt files are enabled.
- `global` resolves to `$VSCODE_PROFILE/prompts/` in this setup.

## Required Workflow
1. Resolve target scope and file path using [scope reference](../common/profile-resolution.md).
2. Explore existing prompt files for overlap before adding a new file.
3. Check `git status` in target repo when git is available.
4. Create exactly one backup file per change at `<filename>.bak`.
5. If `<filename>.bak` exists, rotate to `<filename>.bak.tmp` before creating a new `.bak`.
6. For markdown files ending in `.readonly.*.md`, add-only behavior applies.
7. Show `git diff` and `git diff --stat`.
8. Ask for approval before commit.
9. Commit on approval or restore backup on rejection.

## Safety Rules
- Never edit or remove `*.readonly.*.md`.
- Keep prompts focused and avoid duplicating existing functionality.
````

### .agents/skills/create-skill-global/SKILL.md
````markdown
---
name: create-skill-global
description: 'Create or update skills for workspace, profile, or global scope. Use for "global skills" or "your skills" under ~/.agents/skills, with review workflow and profile-level defaults.'
argument-hint: 'scope=[workspace|profile|global](default:profile) name=<skill-name>'
---

# Create Skill Global

Create or update skills for workspace/profile/global targets.

## Shared Scope Resolution
- Use [scope reference](../common/profile-resolution.md) for skill target path resolution.

## Use When
- You want reusable slash workflows beyond prompts.
- You need a dedicated skill for repeated multi-step tasks.
- You need to refactor long prompt procedures into skill instructions.

## Required Workflow
1. Resolve target scope/path using [scope reference](../common/profile-resolution.md).
2. Prefer `.agents/` over `.copilot/` or `.github/` for skills.
3. Create or update `SKILL.md` with valid frontmatter and concise procedure steps.
4. Add scripts/references only when needed.
5. Review for naming consistency (`name` should match folder).
6. Create exactly one backup file per change at `<filename>.bak`.
7. If `<filename>.bak` exists, rotate to `<filename>.bak.tmp` before creating a new `.bak`.
8. Show file diffs and ask for approval before committing profile-repo changes.

## Safety Rules
- Do not overwrite unrelated skill folders.
- Keep descriptions keyword-rich so the model can discover the skill.
````

### .agents/skills/setting/SKILL.md
````markdown
---
name: setting
description: 'Edit VS Code or Cursor setting/config files with scope-aware targeting. Use for "global settings" or "my settings" including settings.json, tasks.json, mcp.json, and keybindings, with backup, diff review, and approval flow.'
argument-hint: 'scope=[workspace|global](default:global) type=[setting|task|mcp|keybinding](default:setting) key=<setting-key>'
---

# Setting

Edit VS Code or Cursor setting/config files using scope-aware path resolution and safe change controls.

## Shared Scope Resolution
- Use [scope reference](../common/profile-resolution.md) to resolve `$VSCODE_PROFILE` and target files.

## Use When
- You need to update `settings.json`, `tasks.json`, or `mcp.json`.
- You need to update keybindings via `keybindings.json`.
- You need to add or modify Copilot instruction/prompt location settings.
- You want JSON-safe updates with explicit diff review.

## Required Workflow
1. Resolve target scope and file path using [scope reference](../common/profile-resolution.md).
2. Check `git status` in the target repository when git is available.
3. Create exactly one backup file per change at `<filename>.bak`.
4. If `<filename>.bak` exists, rotate to `<filename>.bak.tmp` before creating a new `.bak`.
5. Read, parse, and modify JSON without duplicating existing values.
6. Show `git diff <filename>` and `git diff --stat <filename>` (or equivalent before/after if not in git).
7. Ask for approval before commit.
8. If approved and git is available, `git add <filename>` and commit with a descriptive message.
9. If rejected, restore from backup.

## Safety Rules
- Never edit files matching `*.readonly.*.md`.
- Use terminal fallback read/write when direct file APIs are unavailable.
- Keep settings changes minimal and idempotent.
````

### .agents/skills/update-jumper-prompts/SKILL.md
````markdown
---
name: update-jumper-prompts
description: 'Download and run this repo\'s bootstrap prompt by fetching dist/initial-setup.readonly.prompt.md from raw GitHub, then running the downloaded prompt file.'
argument-hint: 'Optional: branch=<branch>(default:main)'
---

# Update Jumper Prompts

Download and run this repo's bootstrap prompt from raw GitHub.

## Shared Scope Resolution
- No profile path resolution is required for this workflow.

## Use When
- You need a quick bootstrap/update entrypoint for this repo.
- You want to fetch and run `dist/initial-setup.readonly.prompt.md` without relying on local profile setup.
- You want a platform-agnostic update flow.

## Required Workflow
1. Build the raw URL using this repo path template:
  - `https://raw.githubusercontent.com/jeff-hamm/copilot-instructions/<branch>/dist/initial-setup.readonly.prompt.md`
  - Default `<branch>` is `main`.
2. Choose a temp target path:
  - `<TEMP_DIR>/copilot-instructions/initial-setup.readonly.prompt.md`
3. Download the raw file to that temp path.
4. Validate the downloaded file starts with `# Initial Copilot Setup`.
5. Run the downloaded temp file as a prompt.
6. Summarize the update and include the raw URL and temp path used.

## Safety Rules
- If download fails, surface the exact URL and error.
- Do not modify files outside this update flow unless explicitly requested.
- Keep the workflow platform-agnostic (no shell-specific temp environment syntax).
````

## Setup-only references (do not install)

### src/global.bootstrap.readonly.instructions.md
````markdown
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
````

