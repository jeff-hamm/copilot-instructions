---
name: test-install-live
description: 'Post-push end-to-end test. Downloads dist/initial-setup.readonly.prompt.md from GitHub via new-install.readonly.prompt.md, validates outputs, and self-heals generation scripts on failure.'
argument-hint: 'Optional: branch=<branch>(default:main)'
---

# Test Install Live (Post-Push / Download)

Run `dist/new-install.readonly.prompt.md` as a prompt — this downloads the compiled setup from raw GitHub and executes it. Then validate output files and self-heal on failure.

## When To Use
- After pushing changes to verify the published prompt works end-to-end.
- To confirm the raw GitHub download URL resolves and the content is correct.
- As a final gate before announcing a new release.

## Procedure

### Phase 1 — Run the download-based install
1. Run `dist/new-install.readonly.prompt.md` as a prompt.
   - This creates a temp directory, downloads `dist/initial-setup.readonly.prompt.md` from the raw GitHub URL, validates the download starts with `# Initial Copilot Setup`, and then runs the downloaded file as a prompt.
2. Record every error, warning, or unexpected behavior encountered during execution.

### Phase 2 — Validate outputs
After the install prompt finishes, resolve `$VSCODE_PROFILE` and `~/.agents/skills/` per the prompt's own path rules. Then verify **all** of the following. Collect every failure before reporting.

#### 2a. Directory-based file validation
Use the **downloaded** compiled prompt as the source of truth. Each `###` heading inside its `## Recreate prompts, instructions, and user-profile skills` block defines a target file path and its expected content.

1. Parse the downloaded prompt and collect every `### <relative-path>` section under the recreate block.
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

#### 2d. Download integrity
Compare the downloaded temp file against the local `dist/initial-setup.readonly.prompt.md`:
- If they differ, report the exact differences — this indicates the push did not propagate or the local copy has unpushed changes.

### Phase 3 — Handle failures
If **any** validation check fails:

1. **Diagnose** — determine whether the failure is in:
   - The generation scripts (`regenerate.ps1`, `initial-setup-builder.ps1` under `.agents/skills/regenerate-initial-setup/scripts/`).
   - Source content in `src/` (prompts, user-skills, instructions, or prompt templates).
   - The `dist/new-install.readonly.prompt.md` template logic inside the builder.
   - A push/propagation issue (downloaded content doesn't match local dist).
2. **Fix** — edit the appropriate files in `.agents/skills/regenerate-initial-setup/` and/or `src/`.
3. **Regenerate** — rebuild dist outputs:
   ```powershell
   pwsh ./.agents/skills/regenerate-initial-setup/scripts/regenerate.ps1
   ```
4. **Verify regeneration** — run the drift check:
   ```powershell
   pwsh ./.agents/skills/check-initial-setup-drift/scripts/check-drift.ps1
   ```
5. **Commit & push** — stage all changed files, commit with a fix message, and push:
   ```powershell
   git add -A
   git commit -m "fix: <description of what was wrong and what was fixed>"
   git push
   ```
6. **Wait for propagation** — allow a brief delay for GitHub raw content to update.
7. **Restart** — go back to **Phase 1** and re-run the full test. Repeat until all validations pass.

### Phase 4 — Report
When all checks pass, print a summary:
- Raw URL used for download.
- List of files validated and their status.
- Whether downloaded content matched local dist.
- Number of fix-and-retry cycles performed (if any).
- Final commit SHA (if fixes were pushed).

## Safety Rules
- Never edit `*.readonly.*.md` files directly — only fix the generation scripts and source files that produce them.
- Do not push without a successful drift check.
- If a fix cycle repeats more than 3 times, stop and report the unresolved failures instead of looping indefinitely.
