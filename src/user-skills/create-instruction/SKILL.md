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
