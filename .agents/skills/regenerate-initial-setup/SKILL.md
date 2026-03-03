---
name: regenerate-initial-setup
description: 'Regenerate prompts/initial-setup.readonly.prompt.md from src source files using dynamic discovery of src/prompts and src/user-skills. Generates a temporary global.readonly.instructions.md (outside git) that lists included skills/prompts and implicit-use guidance.'
argument-hint: 'Optional: output relative path; default is prompts/initial-setup.readonly.prompt.md'
---

# Regenerate Initial Setup

Rebuild the compiled prompt from canonical source files.

## When To Use
- You updated files in `src/` that feed the compiled installer prompt.
- `prompts/initial-setup.readonly.prompt.md` is missing sections or has stale content.
- You changed user-profile skill source files under `src/user-skills/`.
- You need deterministic regeneration before review.

## Procedure
1. Confirm source files exist in `src/`.
2. Run [regeneration script](./scripts/regenerate.ps1).
3. The script scans `src/prompts` and `src/user-skills` to discover included prompts/skills.
4. The script generates a temporary global instructions file outside git for embedding.
5. Review changes with `git diff prompts/initial-setup.readonly.prompt.md`.
6. If needed, run drift and verification skills before committing.

## Command Example
```powershell
pwsh ./.agents/skills/regenerate-initial-setup/scripts/regenerate.ps1
```
