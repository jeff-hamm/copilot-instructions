---
name: regenerate-initial-setup
description: 'Regenerate prompts/initial-setup.readonly.prompt.md from src source files. Use when initial setup content drifts or after editing src/edit-global-files.readonly.prompt.md, src/environment-setup.readonly.prompt.md, or src/global.readonly.instructions.md.'
argument-hint: 'Optional: output relative path; default is prompts/initial-setup.readonly.prompt.md'
---

# Regenerate Initial Setup

Rebuild the compiled prompt from canonical source files.

## When To Use
- You updated files in `src/` that feed the compiled installer prompt.
- `prompts/initial-setup.readonly.prompt.md` is missing sections or has stale content.
- You need deterministic regeneration before review.

## Procedure
1. Confirm source files exist in `src/`.
2. Run [regeneration script](./scripts/regenerate.ps1).
3. Review changes with `git diff prompts/initial-setup.readonly.prompt.md`.
4. If needed, run drift and verification skills before committing.

## Command Example
```powershell
pwsh ./.agents/skills/regenerate-initial-setup/scripts/regenerate.ps1
```
