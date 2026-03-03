name: setting
description: 'Edit VS Code or Cursor setting/config files with scope-aware targeting. Use for settings, tasks, mcp, and keybinding updates with backup, diff review, and approval flow.'
argument-hint: 'scope=[workspace|global](default:global) type=[setting|task|mcp|keybinding](default:setting) key=<setting-key>'
---

# Setting

Edit VS Code or Cursor setting/config files using scope-aware path resolution and safe change controls.

## Shared Scope Resolution
- Use [scope reference](../common/profile-resolution.md) to resolve `$VSCODE_PROFILE` and target files.

## Use When
- You need to update `settings.json`, `tasks.json`, or `mcp.json`.
- You need to update keybindings via `keybindings.json`.
- You need to add or modify Copilot instruction/prompt location settings.
- You want JSON-safe updates with explicit diff review.

## Required Workflow
1. Resolve target scope and file path using [scope reference](../common/profile-resolution.md).
2. Check `git status` in the target repository when git is available.
3. Create exactly one backup file per change at `<filename>.bak`.
4. If `<filename>.bak` exists, rotate to `<filename>.bak.tmp` before creating a new `.bak`.
5. Read, parse, and modify JSON without duplicating existing values.
6. Show `git diff <filename>` and `git diff --stat <filename>` (or equivalent before/after if not in git).
7. Ask for approval before commit.
8. If approved and git is available, `git add <filename>` and commit with a descriptive message.
9. If rejected, restore from backup.

## Safety Rules
- Never edit files matching `*.readonly.*.md`.
- Use terminal fallback read/write when direct file APIs are unavailable.
- Keep settings changes minimal and idempotent.
