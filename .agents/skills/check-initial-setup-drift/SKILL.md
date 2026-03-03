---
name: check-initial-setup-drift
description: 'Detect drift between src source files and prompts/initial-setup.readonly.prompt.md. Use before commit or when troubleshooting missing embedded blocks.'
argument-hint: 'Optional: compiled prompt relative path; default is prompts/initial-setup.readonly.prompt.md'
---

# Check Initial Setup Drift

Compare the compiled prompt with the content that should be generated from source files.

## When To Use
- Before committing prompt updates.
- After running regeneration to ensure no manual drift remains.
- When debugging mismatches in embedded prompt/instruction blocks.

## Procedure
1. Build expected content from `src/` in memory.
2. Compare expected content against the compiled prompt.
3. Return exit code `0` for no drift, `1` for drift.

## Command Example
```powershell
pwsh ./.agents/skills/check-initial-setup-drift/scripts/check-drift.ps1
```
