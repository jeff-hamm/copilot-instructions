# Update Initial Setup Prompt

Use this prompt to rebuild `dist/initial-setup.readonly.prompt.md` whenever it drifts from the canonical source prompts.

You *ARE* allowed to edit or remove `dist/initial-setup.readonly.prompt.md` and `dist/new-install.readonly.prompt.md`.

## Source files
- `src/environment-setup.readonly.prompt.md`
- `src/profile-resolution-scripts.readonly.prompt.md`
- `src/edit-global-files.readonly.prompt.md`
- `src/global.bootstrap.readonly.instructions.md`
- `src/global.readonly.instructions.md`
- `src/profile-resolution-runner.template.md`
- `src/user-skills/common/resolve-vscode-profile.ps1`
- `src/user-skills/common/resolve-vscode-profile.sh`
- `src/prompts/*.prompt.md`
- `src/user-skills/**/*.md`

## Regeneration steps
1. Check to see if the source files exist. If not, try to clone them from https://github.com/jeff-hamm/copilot-instructions
   - Install git if it is not already installed
2. Rebuild from source files:
   1. Start with the content
     ```markdown
     # Initial Copilot Setup
     Use this prompt when reusable prompts or global instructions are missing, or when preparing a fresh environment.
     ```
   2. Append the full contents of `src/edit-global-files.readonly.prompt.md`
   3. Append the full contents of `src/environment-setup.readonly.prompt.md`
   4. Append the full contents of `src/profile-resolution-scripts.readonly.prompt.md`
   5. Append the content
      ```markdown
      
      ## Recreate prompts, instructions, and user-profile skills
      Create or update these files under `$VSCODE_PROFILE` and `~/.agents/skills`, where each section title is the filename. Use the section's markdown as the file contents (copy verbatim)
      ```
   6. Perform a file search in `src/prompts` for `*.prompt.md` and in `src/user-skills` for markdown sources (`*.md`) to determine included prompts and skills/references.
   7. Replace `{{PROFILE_RESOLUTION_CONTENT}}` in user-skill source files with the full contents of `src/profile-resolution-runner.template.md` before embedding.
   8. Generate a temporary `global.readonly.instructions.md` file outside the repository (not checked into git) that:
      - includes the `## Global Edit Routing` section from `src/global.readonly.instructions.md`
      - lists discovered prompts and discovered skills with descriptions
   9. Under `### prompts/edit-global-files.readonly.prompt.md`, embed a second copy of `src/edit-global-files.readonly.prompt.md` in a fenced `markdown` block whose contents are copied directly from that source file.
   10. Under `### instructions/global.readonly.instructions.md`, embed a fenced `markdown` block copied from the temporary generated `global.readonly.instructions.md` (this is the installed always-on file).
   11. For each discovered prompt source file, add `### prompts/<filename>` and embed the file in a fenced `markdown` block.
   12. For each discovered user-skill markdown file, map its relative path from `src/user-skills/` to `.agents/skills/<relative-path>`, then add `### .agents/skills/<relative-path>` and embed it in a fenced `markdown` block.
   13. For each discovered skill `SKILL.md` that used `{{PROFILE_RESOLUTION_CONTENT}}`, add generated co-located sections under the same skill directory for:
      - `resolve-vscode-profile.ps1` (content from `src/user-skills/common/resolve-vscode-profile.ps1`)
      - `resolve-vscode-profile.sh` (content from `src/user-skills/common/resolve-vscode-profile.sh`)
   14. Under `## Setup-only references (do not install)`, add `### src/global.bootstrap.readonly.instructions.md` and embed a fenced `markdown` block copied directly from `src/global.bootstrap.readonly.instructions.md`.
   15. Write `dist/new-install.readonly.prompt.md` as a minimal prompt that instructs the agent to download raw `dist/initial-setup.readonly.prompt.md` from remote `origin` and run it as a prompt.
3. Create backup before modifying:
   - Use exactly one `.bak` file for this change.
   - If `dist/initial-setup.readonly.prompt.md.bak` exists, replace its contents with the current HEAD version before continuing
4. Save the regenerated files and confirm each embedded block and the start of the file matches its source byte-for-byte (including VS Code Stable/Insiders, Cursor paths, dynamic prompt/skill sections, and generated global instructions).

## Verification and Commit

- Diff `initial-setup.readonly.prompt.md` against the source prompts to confirm the embedded blocks are identical.
- Run `git status` to ensure only the expected files changed.
- Show the diff summary with git diff --stat
- Explain the changes made
- Stage the changes with `git add .`
- Commit with an appropriate message.
- If verification fails, diagnose the problem and include the solution for what the differences were in your summary.

# Installation
- Run `dist/initial-setup.readonly.prompt.md` as a prompt