# *IMPORTANT: NEVER EDIT THIS FILE!*
# Global File Management
Use this prompt whenever you view, edit or remove my global settings, instructions, prompts, or skills.

## Preferred Skills
- Prefer user-profile skills under `~/.agents/skills/` over prompt-only workflows.
- Use these slash commands when applicable:
  - `/setting`
  - `/create-instruction`
  - `/create-prompt-global`
  - `/create-skill-global`
- Use this prompt as a fallback only when those skills are missing.

## Paths
- I will refer to my editor profile path as `$VSCODE_PROFILE`. To find the location
  1. Find the base VS Code or Cursor settings path for my OS and channel:
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

## Global Skills
- Location: `$AGENTS_SKILLS_HOME`
- Files: `<SKILL_NAME>/SKILL.md` and optional `scripts/`, `references/`, `assets/`
- I may call these "global skills", "your skills", or "slash skills"
- Prefer multiple focused skills over one long procedural prompt
---
# *IMPORTANT: NEVER EDIT THIS FILE!*
