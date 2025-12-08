# Update Initial Setup Prompt

Use this prompt to rebuild `initial-setup.prompt.md` whenever it drifts from the canonical source prompts.

## Source files
- `${userHome}/.github/prompts/prepare-setup.prompt.md`
- `${userHome}/.github/prompts/edit-global-files.prompt.md`
- `${userHome}/.github/prompts/git-workflow.prompt.md`
- `${userHome}/.github/instructions/copilot-instructions.md`

## Regeneration steps
1. Check to see if the source files exist. If not, try to clone them from https://github.com/jeff-hamm/copilot-instructions
   - Install git if it is not already installed
2. Rebuild from source files:
   - Start the file with the contents of `${userHome}/.github/prompts/prepare-setup.prompt.md`
   - Under `### edit-global-files.prompt.md`, embed a fenced `markdown` block whose contents are copied directly from `${userHome}/.github/prompts/edit-global-files.prompt.md`.
   - Under `### git-workflow.prompt.md`, embed a fenced `markdown` block copied directly from `${userHome}/.github/prompts/git-workflow.prompt.md`.
   - Under `### Update copilot-instructions.md`, embed a fenced `markdown` block copied directly from `${userHome}/.github/instructions/copilot-instructions.md`.
3. Save the file and confirm each embedded block matches its source byte-for-byte before staging.

## Verification

- Diff `initial-setup.prompt.md` against the source prompts to confirm the embedded blocks are identical.
- Run `git status` inside `${userHome}/.github/prompts` to ensure only the expected files changed.
