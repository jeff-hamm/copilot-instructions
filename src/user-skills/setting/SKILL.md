---
name: setting
description: 'Edit VS Code or Cursor configuration files with scope-aware targeting. Use for requests like "global settings", "my settings", "workspace settings", "vscode settings", "user settings", "settings.json", "tasks.json", "mcp.json", "keybindings", "Copilot settings", or "instruction/prompt locations".'
argument-hint: 'scope=[workspace|global](default:global) type=[setting|task|mcp|keybinding](default:setting) key=<setting-key>'
---

# Setting

Edit VS Code or Cursor setting/config files using scope-aware path resolution and safe change controls.

## Shared Scope Resolution
Resolve `$VSCODE_PROFILE` by running the co-located resolver script for the current platform.

{{PROFILE_RESOLUTION_CONTENT}}

## Required Workflow
1. Resolve `$VSCODE_PROFILE` using the co-located resolver script for the current platform, then map scope and target file path.
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
