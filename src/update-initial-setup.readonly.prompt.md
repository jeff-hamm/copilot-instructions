# Update Initial Setup Prompt

Use this prompt to rebuild the  `$VSCODE_PROFILE/prompts/initial-setup.readonly.prompt.md` prompt whenever it drifts from the canonical source prompts.

Use #file:src/edit-global-files.readonly.prompt.md to determine the `$VSCODE_PROFILE` path. You *ARE* allowed to edit or remove `$VSCODE_PROFILE/prompts/initial-setup.readonly.prompt.md` 

## Source files
- `src/environment-setup.readonly.prompt.md`
- `src/edit-global-files.readonly.prompt.md`
- `src/global.readonly.instructions.md`

## Regeneration steps
1. Check to see if the source files exist. If not, try to clone them from https://github.com/jeff-hamm/copilot-instructions
   - Install git if it is not already installed
2. Rebuild from source files:
   1. Start with the content
     ```markdown
     # Initial Copilot Setup
     Use this prompt when reusable prompts or global instructions are missing, or when preparing a fresh environment.
     ```
   2. Append the contents of `edit-global-files.readonly.prompt.md`, only include content _after_ the 
      ```
      ---
      applyTo: "**"
      --
      block
   3. Append the contents of `environment-setup.readonly.prompt.md`
   4. Append the content
      ```markdown
      
      ## Recreate prompts and instructions
      Create or update these files under `$VSCODE_PROFILE`, for each section title is the filename. Use the section's markdown as the file contents (copy verbatim)
      ```
   5. Under `### prompts/edit-global-files.readonly.prompt.md`, embed a second copy of `edit-global-files.readonly.prompt.md` in a fenced `markdown` block whose contents are copied directly from `edit-global-files.readonly.prompt.md`.
   - Under `### instructions/global-file.readonly.instructions.md`, embed a fenced `markdown` block copied directly from `global-file.readonly.instructions.md`.
3. Create backup before modifying:
   - If `$VSCODE_PROFILE/prompts/initial-setup.readonly.prompt.md.bak` exists, rename to `.bak.tmp` (delete `.bak.tmp` if it exists)
   - Save the current HEAD version to `.bak`
4. Save the regenerated file and confirm each embedded block and the start of the file matches its source byte-for-byte.

## Verification and Commit

- Diff `initial-setup.readonly.prompt.md` against the source prompts to confirm the embedded blocks are identical.
- Run `git status` to ensure only the expected files changed.
- Show the diff summary with git diff --stat
- Explain the changes made
- Stage the changes with `git add .`
- Commit with an appropriate message.
- If verification fails, diagnose the problem and include the solution for what the differences were in your summary.

# Installation
- Run `$VSCODE_PROFILE/prompts/initial-setup.readonly.prompt.md` as a prompt