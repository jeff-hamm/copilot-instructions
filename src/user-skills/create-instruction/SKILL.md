---
name: create-instruction
description: 'Create or update instruction files for workspace, profile, or global scope. Use to add or edit "global rules", "global instructions", "global instructions", "reusable instructions", "profile instructions" or "user instructions"'
argument-hint: 'scope=[workspace|global](default:global) name=<instruction-name>'
---

# Create Instruction

Create or update instruction files for workspace/profile/global targets.

## Shared Scope Resolution
Resolve `$VSCODE_PROFILE` by running the co-located resolver script for the current platform.

{{PROFILE_RESOLUTION_CONTENT}}

## Use When
- You need to create `copilot-instructions.md` or `<name>.instructions.md`.
- You need to refine wording of global rules.
- You need to avoid duplicate or conflicting instruction blocks.

## Scope Notes
- `profile` is supported in VS Code and Cursor via `$VSCODE_PROFILE/prompts/*.instructions.md` when profile instruction files are enabled.
- `global` resolves to `$VSCODE_PROFILE/instructions/` in this setup.

## Required Workflow
1. Resolve `$VSCODE_PROFILE` using the co-located resolver script for the current platform, then map scope and target file path.
2. Check `git status` in target repo when git is available.
3. Create exactly one backup file per change at `<filename>.bak`.
4. If `<filename>.bak` exists, replace its contents with the current pre-change contents of `<filename>`.
5. Keep wording concise and non-duplicative.
6. Validate that resulting file is clear and does not repeat existing rules.
7. Show `git diff` and `git diff --stat`.
8. Ask for approval before commit.
9. Commit on approval or restore from backup on rejection.

## Safety Rules
- Never edit `*.readonly.*.md` files.
- Prefer updating an existing instruction file before creating a new one.
