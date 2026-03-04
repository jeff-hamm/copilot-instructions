---
name: create-skill-global
description: 'Create, edit, or refactor skills for workspace/profile/global scope. Use for requests like "global skills", "slash commands", "reusable workflows", "automation skill", "agent skill", "SKILL.md", "new skill", or "skill updates". Best for repeatable multi-step tasks and integrations.'
argument-hint: 'scope=[workspace|profile|global](default:profile) name=<skill-name>'
---

# Create Skill Global

Create or update skills for workspace/profile/global targets.

## Shared Scope Resolution
Resolve `$VSCODE_PROFILE` by running the co-located resolver script for the current platform.

{{PROFILE_RESOLUTION_CONTENT}}

## Use When
- You want reusable slash workflows beyond prompts.
- You need a dedicated skill for repeated multi-step tasks.
- You need to refactor long prompt procedures into skill instructions.

## Required Workflow
1. Resolve `$VSCODE_PROFILE` using the co-located resolver script for the current platform, then map scope/path.
2. Prefer `.agents/` over `.copilot/` or `.github/` for skills.
3. Create or update `SKILL.md` with valid frontmatter and concise procedure steps.
4. Add scripts/references only when needed.
5. Review for naming consistency (`name` should match folder).
6. Create exactly one backup file per change at `<filename>.bak`.
7. If `<filename>.bak` exists, replace its contents with the current pre-change contents of `<filename>`.
8. Show file diffs and ask for approval before committing profile-repo changes.

## Safety Rules
- Do not overwrite unrelated skill folders.
- Keep descriptions keyword-rich so the model can discover the skill.
