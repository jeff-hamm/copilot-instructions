---
name: verify-initial-setup
description: 'Verify initial setup changes before commit: check drift, confirm required dynamic section markers (prompts/skills/generated global instructions), ensure Insiders/Cursor paths exist, and print git status and diff stats.'
argument-hint: 'Optional: compiled prompt relative path; default is prompts/initial-setup.readonly.prompt.md'
---

# Verify Initial Setup

Run a compact verification pass before staging and committing setup changes.

## What This Checks
- Compiled prompt matches expected generated content.
- Required embedded section markers exist (including discovered prompt and skill blocks).
- Embedded user-profile skill blocks exist for `/setting`, `/create-instruction`, `/create-prompt-global`, and `/create-skill-global`.
- VS Code Stable/Insiders and Cursor path references are present.
- Git status and diff statistics are displayed.

## Procedure
1. Run [verification script](./scripts/verify.ps1).
2. If the script reports failures, fix issues first.
3. If all checks pass, stage and commit.

## Command Example
```powershell
pwsh ./.agents/skills/verify-initial-setup/scripts/verify.ps1
```
