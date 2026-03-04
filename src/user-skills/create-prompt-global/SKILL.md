---
name: create-prompt-global
description: 'Create or update reusable prompts for workspace, profile, or global scope. Use to add or edit "global prompts", "reusable prompts", "profile prompts" or "user prompts".'
argument-hint: 'scope=[workspace|global](default:global) name=<prompt-name>'
---

# Create Prompt Global

Create or update reusable prompt files for workspace/profile/global targets.

## Shared Scope Resolution
Use the inlined scope/path reference below for prompt path resolution.

{{PROFILE_RESOLUTION_CONTENT}}

## Use When
- You need a new workflow prompt (`*.prompt.md`).
- You need to improve an existing prompt.
- You need to avoid duplicate prompts that overlap in scope.

## Scope Notes
- `profile` prompt files are supported in VS Code and Cursor when profile prompt files are enabled.
- `global` resolves to `$VSCODE_PROFILE/prompts/` in this setup.

## Required Workflow
1. Resolve target scope and file path using the inlined scope/path reference in this file.
2. Explore existing prompt files for overlap before adding a new file.
3. Check `git status` in target repo when git is available.
4. Create exactly one backup file per change at `<filename>.bak`.
5. If `<filename>.bak` exists, replace its contents with the current pre-change contents of `<filename>`.
6. For markdown files ending in `.readonly.*.md`, add-only behavior applies.
7. Show `git diff` and `git diff --stat`.
8. Ask for approval before commit.
9. Commit on approval or restore backup on rejection.

## Safety Rules
- Never edit or remove `*.readonly.*.md`.
- Keep prompts focused and avoid duplicating existing functionality.
