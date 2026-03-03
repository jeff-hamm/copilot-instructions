# Copilot Global Setup Prompts

This repository contains the source-of-truth prompt and instruction files used to bootstrap global GitHub Copilot behavior in a VS Code user profile.

The main goal is to let a fresh install quickly recreate:
- reusable global prompts,
- reusable global instructions,
- key settings that enable instruction/prompt loading.

## What This Repo Is For

Use this repo when you want a repeatable way to configure global Copilot behavior in your VS Code profile (`$VSCODE_PROFILE`) and keep those files under git.

The compiled installer prompt is:
- `prompts/initial-setup.readonly.prompt.md`

It is built from canonical source files in `src/`.

## Repo Layout

| Path | Purpose | Source of Truth |
|---|---|---|
| `src/edit-global-files.readonly.prompt.md` | Rules for editing global settings/prompts/instructions safely | Yes |
| `src/environment-setup.readonly.prompt.md` | Environment prep and settings initialization steps | Yes |
| `src/global.readonly.instructions.md` | Core global instruction file to place in profile | Yes |
| `src/update-initial-setup.readonly.prompt.md` | Meta-prompt describing how to regenerate initial setup prompt | Yes |
| `prompts/initial-setup.readonly.prompt.md` | Compiled bootstrap prompt used on fresh installs | No (generated from `src/*`) |
| `prompts/git-workflow.prompt.md` | Reusable prompt for copilot-branch/worktree workflow | Yes |
| `instructions/copilot-instructions.md` | Lightweight global instruction include | Yes |
| `.agents/skills/regenerate-initial-setup/` | Workspace skill to regenerate compiled initial setup prompt | Yes |
| `.agents/skills/check-initial-setup-drift/` | Workspace skill to detect drift between source and compiled prompt | Yes |
| `.agents/skills/verify-initial-setup/` | Workspace skill to run pre-commit verification checks | Yes |

## Customization Path Preference

This repository prefers `.agents/` for skill/customization placement.

- Workspace scope: `.agents/skills/<name>/`
- User scope: `~/.agents/skills/<name>/`
- Avoid as first choice: `.copilot/` and `.github/`

This keeps conventions consistent for both workspace and user-level agent customizations.

## Workspace Skills

These skills are included under `.agents/skills`:

- `regenerate-initial-setup`: rebuilds `prompts/initial-setup.readonly.prompt.md` from `src/*`
- `check-initial-setup-drift`: compares expected compiled content vs current file
- `verify-initial-setup`: runs drift checks, required marker checks, Insiders checks, and prints git status/diff stats

Run them directly with PowerShell:

```powershell
pwsh ./.agents/skills/regenerate-initial-setup/scripts/regenerate.ps1
pwsh ./.agents/skills/check-initial-setup-drift/scripts/check-drift.ps1
pwsh ./.agents/skills/verify-initial-setup/scripts/verify.ps1
```

## VS Code Stable + Insiders Support

The source prompts/instructions now include profile path variants for both channels.

| OS | Stable | Insiders |
|---|---|---|
| Windows | `$Env:AppData\Code\User\` | `$Env:AppData\Code - Insiders\User\` |
| macOS | `$HOME/Library/Application Support/Code/User/` | `$HOME/Library/Application Support/Code - Insiders/User/` |
| Linux | `$HOME/.config/Code/User/` | `$HOME/.config/Code - Insiders/User/` |

## How `initial-setup.readonly.prompt.md` Is Built

The compiled prompt is assembled in this order:
1. Static header (`Initial Copilot Setup`)
2. Full contents of `src/edit-global-files.readonly.prompt.md`
3. Full contents of `src/environment-setup.readonly.prompt.md`
4. "Recreate prompts and instructions" section header text
5. Embedded copy of `src/edit-global-files.readonly.prompt.md`
6. Embedded copy of `src/global.readonly.instructions.md`

This duplication is intentional so the bootstrap prompt can recreate required files without external lookup.

## Regeneration Workflow

When the compiled prompt drifts:
1. Update canonical files in `src/` first.
2. Rebuild `prompts/initial-setup.readonly.prompt.md` using `src/update-initial-setup.readonly.prompt.md`.
3. Verify embedded blocks match source content byte-for-byte.
4. Review with `git diff` and `git diff --stat`.

## Fresh Install Workflow

On a new machine/profile:
1. Run the compiled prompt `prompts/initial-setup.readonly.prompt.md`.
2. It prepares git/profile basics and required settings.
3. It recreates the key read-only prompt/instruction files in `$VSCODE_PROFILE`.

## Should This Be Converted To Skills?

Short answer: partially.

What should stay as prompts/instructions:
- Global bootstrap behavior in user profile directories.
- Cross-session guidance that must be discoverable as user prompt/instruction files.

What can be a skill:
- Maintainer-only repo tasks, especially regeneration/verification workflows for this repository.
- Multi-step authoring checks (drift detection, compare embedded blocks, lint frontmatter).

Why not move everything to skills:
- User-level VS Code profile customization currently centers on `*.prompt.md`, `*.instructions.md`, and `*.agent.md` files.
- Skills are best treated as workflow tooling for maintainers, not as the primary distribution format for this global bootstrap set.

For `edit-global-files.readonly.prompt.md` specifically:
- Keep the prompt for bootstrap and policy-critical guardrails.
- Add a companion user-level skill in `~/.agents/skills/` for day-to-day global file editing workflows.
- Use `.agents/` as the default location for both workspace and user-level skills.

## Maintenance Notes

- Treat `src/*` as canonical.
- Keep wording concise to reduce context overhead.
- Avoid editing generated output directly unless you are intentionally regenerating it.
- Preserve `.readonly.*.md` semantics for bootstrap artifacts.
