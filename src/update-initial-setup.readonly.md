# Update Initial Setup Prompt

Use this prompt to rebuild the global `prompts/initial-setup.readonly.md` prompt whenever it drifts from the canonical source prompts.

## Source files
- `src/environment-setup.readonly.md`
- `src/edit-global-files.readonly.md`
- `src/global-instructions.readonly.md`

## Regeneration steps
1. Check to see if the source files exist. If not, try to clone them from https://github.com/jeff-hamm/copilot-instructions
   - Install git if it is not already installed
2. Rebuild from source files:
   1. Start with the content
     ```markdown
     # Initial Copilot Setup
     Use this prompt when reusable prompts or global instructions are missing, or when preparing a fresh environment.
     ```
   2. Append the contents of `edit-global-files.readonly.md` 
   3. Append the contents of `environment-setup.readonly.md`
   4. Append the content
      ```markdown
      
      ## Recreate prompts and instructions
      Create or update these files under `$VSCODE_PROFILE`
      ```
   5. Under `### prompts/edit-global-files.readonly.md`, embed a second copy of `edit-global-files.readonly.md` in a fenced `markdown` block whose contents are copied directly from `edit-global-files.readonly.md`.
   - Under `### Update instructions/global-file-instructions.readonly.md`, embed a fenced `markdown` block copied directly from `global-file-instructions.readonly.md`.
3. Save the file and confirm each embedded block and the start of the file matches its source byte-for-byte before staging.

## Verification

- Diff `initial-setup.readonly.md` against the source prompts to confirm the embedded blocks are identical.
- Run `git status` to ensure only the expected files changed.
