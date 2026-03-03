---
name: update-jumper-prompts
description: 'Download and run this repo\'s bootstrap prompt by fetching dist/initial-setup.readonly.prompt.md from raw GitHub, then running the downloaded prompt file.'
argument-hint: 'Optional: branch=<branch>(default:main)'
---

# Update Jumper Prompts

Download and run this repo's bootstrap prompt from raw GitHub.

## Shared Scope Resolution
- No profile path resolution is required for this workflow.

## Use When
- You need a quick bootstrap/update entrypoint for this repo.
- You want to fetch and run `dist/initial-setup.readonly.prompt.md` without relying on local profile setup.
- You want a platform-agnostic update flow.

## Required Workflow
1. Build the raw URL using this repo path template:
  - `https://raw.githubusercontent.com/jeff-hamm/copilot-instructions/<branch>/dist/initial-setup.readonly.prompt.md`
  - Default `<branch>` is `main`.
2. Choose a temp target path:
  - `<TEMP_DIR>/copilot-instructions/initial-setup.readonly.prompt.md`
3. Download the raw file to that temp path.
4. Validate the downloaded file starts with `# Initial Copilot Setup`.
5. Run the downloaded temp file as a prompt.
6. Summarize the update and include the raw URL and temp path used.

## Safety Rules
- If download fails, surface the exact URL and error.
- Do not modify files outside this update flow unless explicitly requested.
- Keep the workflow platform-agnostic (no shell-specific temp environment syntax).
