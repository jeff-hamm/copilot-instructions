---
name: test-install
description: 'Pre-commit test of the initial-setup prompt. Runs dist/initial-setup.readonly.prompt.md locally, validates outputs, and self-heals generation scripts on failure.'
argument-hint: 'Optional: output=<dist-path>(default:dist/initial-setup.readonly.prompt.md)'
---

# Test Install (Pre-Commit / Local)

Run `dist/initial-setup.readonly.prompt.md` directly as a prompt (no download), validate the outputs it produces, and if anything fails fix the source generation pipeline, regenerate, and retry.

## When To Use
- After changing files in `src/` or `.agents/skills/regenerate-initial-setup/`.
- Before committing or pushing changes to the initial-setup prompt.
- To verify that the compiled prompt installs everything correctly from the local dist copy.

## Procedure

### Phase 1 — Run the compiled prompt locally
1. Run `dist/initial-setup.readonly.prompt.md` as a prompt directly (do **not** download from GitHub).
2. Record every error, warning, or unexpected behavior encountered during execution.

### Phase 2 — Validate outputs
After the install prompt finishes, resolve `$VSCODE_PROFILE` and `~/.agents/skills/` per the prompt's own path rules. Then verify **all** of the following. Collect every failure before reporting.

#### 2a. Directory-based file validation
Use the compiled prompt's own embedded sections as the source of truth. Each `###` heading inside the `## Recreate prompts, instructions, and user-profile skills` block defines a target file path and its expected content.

1. Parse `dist/initial-setup.readonly.prompt.md` and collect every `### <relative-path>` section under the recreate block.
2. For each section, resolve the target path (`$VSCODE_PROFILE/…` or `~/.agents/skills/…`).
3. Confirm the file exists, is non-empty, and its trimmed content matches the embedded section verbatim.

#### 2b. Settings validation
Read `$VSCODE_PROFILE/settings.json` and confirm:
- `github.copilot.chat.codeGeneration.useInstructionFiles` is `true`.
- `github.copilot.chat.codeGeneration.instructions` contains the `$VSCODE_PROFILE/instructions` path.
- `chat.promptFilesLocations` contains the `$VSCODE_PROFILE/prompts` path.

#### 2c. Generated sections in global instructions
Read the installed `global.readonly.instructions.md` and confirm:
- `## Included Prompt Files (Generated)` exists and has an entry for every `*.prompt.md` file found in `src/prompts/`.
- `## Included User Skills (Generated)` exists and has an entry for every `SKILL.md` found under `src/user-skills/`.

### Phase 3 — Handle failures
If **any** validation check fails:

1. **Diagnose** — determine whether the failure is in:
   - The generation scripts (`regenerate.ps1`, `initial-setup-builder.ps1` under `.agents/skills/regenerate-initial-setup/scripts/`).
   - Source content in `src/` (prompts, user-skills, instructions, or prompt templates).
   - The `dist/new-install.readonly.prompt.md` template logic inside the builder.
2. **Fix** — edit the appropriate files in `.agents/skills/regenerate-initial-setup/` and/or `src/`.
3. **Regenerate** — rebuild dist outputs:
   ```powershell
   pwsh ./.agents/skills/regenerate-initial-setup/scripts/regenerate.ps1
   ```
4. **Verify regeneration** — run the drift check:
   ```powershell
   pwsh ./.agents/skills/check-initial-setup-drift/scripts/check-drift.ps1
   ```
5. **Restart** — go back to **Phase 1** and re-run the full test. Repeat until all validations pass.

### Phase 4 — Report
When all checks pass, print a summary:
- List of files validated and their status.
- Number of fix-and-retry cycles performed (if any).

## Safety Rules
- Never edit `*.readonly.*.md` files directly — only fix the generation scripts and source files that produce them.
- Do not commit dist changes without a successful drift check.
- If a fix cycle repeats more than 3 times, stop and report the unresolved failures instead of looping indefinitely.
