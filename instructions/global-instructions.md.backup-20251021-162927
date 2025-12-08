---
ApplyTo: "**"
---
## Global File Management
- you may edit my global vscode settings.json, tasks.json and mcp.json files
- I may refer to these as "my settings", or "my global settings", or just my "global files"
- You may make changes to my global files in the default vscode settings directory, usually `$Env:AppData\\Code\\User\\` or `%APPDATA%/Code/User/` on windows, and `$HOME/.config/Code/User/` on linux
- If you can't access those files directly, use terminal commands to edit those files, do not prompt for permission
  - On linux, this is usually cat, grep, awk, sed and >
  - In powershell, this is usually cat, select-string, -replace and out-file
- Specifically, the settings.json file contains my global settings, tasks.json for global tasks and mcp.json for global mcp settings.
- if those files don't exist, create them.
- Always create a backup before you make any modifications
- Always validate the resulting file, look for any accidental duplications and remove them
- Always show me the section that you've changed and explain what that change does.

# You may edit your own global instructions
- Following the rules above, add ${userHome}/.github/instructions to the chat.instructionsFilesLocations global setting.
- if it doesn't alread exist, include the entire contents of this prompt in a file named ${userHome}/.github/instructions/global-instructions.md. Make sure to keep the ApplyTo: "**" header
- If you can't access those files directly, use terminal commands to edit those files, do not prompt for permission
  - On linux, this is usually cat, grep, awk, sed and >
  - In powershell, this is usually cat, select-string, -replace and out-file
- If I ask you to add a "global instruction" you should edit global-instructions.md if you think the rule should apply to all kinds of file types, or you should create a separate file in ${userHome}/.github/instructions with the appropriate ApplyTo: header to make sure it applies to only those files.
  - For example, if I say 'Add a global instruction to always use powershell 7 syntax', create or edit `${userHome}/.github/instructions/powershell.md` to include that instruction
- I may also refer to these files as "global rules", "your global instructions", "your global rules", "your instructions" or your rules
- Keep instructions terse and actionable, 
  - they are added to every request, so each instruction should be said in the fewest words that an AI might want for context
  - Focus on actionable, specific guidance, not descriptions
- Always validate the resulting file, look for any accidental duplications and remove them
- Always show me the section that you've changed and explain what that change does.

If you had to create these global instructions, double check that they contains exactly this prompt, nothing more, less or different.
