---
name: setting
description: 'Edit VS Code or Cursor setting/config files with scope-aware targeting. Use for "global settings", "my settings", "vscode settings", or "user settings", including settings.json, tasks.json, mcp.json, and keybindings.'
argument-hint: 'scope=[workspace|global](default:global) type=[setting|task|mcp|keybinding](default:setting) key=<setting-key>'
---

# Setting

Edit VS Code or Cursor setting/config files using scope-aware path resolution and safe change controls.

## Shared Scope Resolution
Use the inlined scope/path reference below to resolve `$VSCODE_PROFILE` and target files.

{{PROFILE_RESOLUTION_CONTENT}}

## Use When
- You need to update `settings.json`, `tasks.json`, or `mcp.json`.
- You need to update keybindings via `keybindings.json`.
- You need to add or modify Copilot instruction/prompt location settings.
- You want JSON-safe updates with explicit diff review.

## Required Workflow
1. Resolve target scope and file path using the inlined scope/path reference in this file.
2. Check `git status` in the target repository when git is available.
3. Create exactly one backup file per change at `<filename>.bak`.
4. If `<filename>.bak` exists, replace its contents with the current pre-change contents of `<filename>`.
5. Read, parse, and modify JSON without duplicating existing values.
6. Show `git diff <filename>` and `git diff --stat <filename>` (or equivalent before/after if not in git).
7. Ask for approval before commit.
8. If approved and git is available, `git add <filename>` and commit with a descriptive message.
9. If rejected, restore from backup.

## Safety Rules
- Never edit files matching `*.readonly.*.md`.
- Use terminal fallback read/write when direct file APIs are unavailable.
- Keep settings changes minimal and idempotent.
