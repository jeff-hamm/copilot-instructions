---
name: create-skill-global
description: 'Create or update skills for workspace, profile, or global scope. Use for "global skills" or "your skills" under ~/.agents/skills, with review workflow and profile-level defaults.'
argument-hint: 'scope=[workspace|profile|global](default:profile) name=<skill-name>'
---

# Create Skill Global

Create or update skills for workspace/profile/global targets.

## Shared Scope Resolution
- Use [scope reference](../common/profile-resolution.md) for skill target path resolution.

## Use When
- You want reusable slash workflows beyond prompts.
- You need a dedicated skill for repeated multi-step tasks.
- You need to refactor long prompt procedures into skill instructions.

## Required Workflow
1. Resolve target scope/path using [scope reference](../common/profile-resolution.md).
2. Prefer `.agents/` over `.copilot/` or `.github/` for skills.
3. Create or update `SKILL.md` with valid frontmatter and concise procedure steps.
4. Add scripts/references only when needed.
5. Review for naming consistency (`name` should match folder).
6. Create exactly one backup file per change at `<filename>.bak`.
7. If `<filename>.bak` exists, rotate to `<filename>.bak.tmp` before creating a new `.bak`.
8. Show file diffs and ask for approval before committing profile-repo changes.

## Safety Rules
- Do not overwrite unrelated skill folders.
- Keep descriptions keyword-rich so the model can discover the skill.
