
## Environment preparation
- Install git if it is not already installed
- If `$VSCODE_PROFILE` is not a git repository, clone it from https://github.com/jeff-hamm/copilot-instructions, or, if that fails, initialize a new git repository there
  - If you create it, the .gitignore should be
    ```
    *
    !.gitignore
    !instructions/
    !instructions/**
    !prompts/
    !prompts/**
    !copilot-instructions.md
    !/*.json
    ```
- If `$VSCODE_PROFILE/instructions/global.readonly.instructions.md` file is missing, create it and copy the full contents of `global.readonly.instructions.md` into it, preserving the `applyTo: "**"` header"
- Update my settings as below. Use careful string manipulation that accounts for JSON escaping requirements. Read the existing JSON, parse it, modify the object, and write it back (using ConvertFrom-Json and ConvertTo-Json)
  - Set my global `github.copilot.chat.codeGeneration.useInstructionFiles` setting to `true`
  - If it doesn't already exist, append `$VSCODE_PROFILE/instructions` to the global setting `github.copilot.chat.codeGeneration.instructions` and `chat.instructionsFilesLocations` lists
  - If it doesn't already exist, append `$VSCODE_PROFILE/prompts` to the global setting `chat.promptFilesLocations` list
