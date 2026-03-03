---
name: regenerate-initial-setup
description: 'Regenerate dist/initial-setup.readonly.prompt.md from src source files using dynamic discovery of src/prompts and src/user-skills. Also writes a minimal new-install bootstrap prompt under dist/ that downloads raw dist/initial-setup.readonly.prompt.md from origin and runs it.'
argument-hint: 'Optional: output relative path; default is dist/initial-setup.readonly.prompt.md'
---

# Regenerate Initial Setup

Rebuild the compiled prompt from canonical source files.

## When To Use
- You updated files in `src/` that feed the compiled installer prompt.
- `dist/initial-setup.readonly.prompt.md` is missing sections or has stale content.
- You changed user-profile skill source files under `src/user-skills/`.
- You need deterministic regeneration before review.

## Procedure
1. Confirm source files exist in `src/`.
2. Run [regeneration script](./scripts/regenerate.ps1).
3. The script scans `src/prompts` and `src/user-skills` to discover included prompts/skills.
4. The script generates a temporary global instructions file outside git for embedding.
5. The script also writes `dist/new-install.readonly.prompt.md` as a minimal bootstrap prompt for new installations, with the current `origin` raw GitHub URL hardcoded.
6. Review changes with `git diff dist/initial-setup.readonly.prompt.md`.
7. If needed, run drift and verification skills before committing.

## Command Example
```powershell
pwsh ./.agents/skills/regenerate-initial-setup/scripts/regenerate.ps1
```
