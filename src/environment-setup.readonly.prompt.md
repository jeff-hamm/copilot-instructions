
## Environment preparation
- Install git if it is not already installed
- If `$VSCODE_PROFILE` is not a git repository, clone it from https://github.com/jeff-hamm/copilot-instructions, or, if that fails, initialize a new git repository there
  - If you create it, the .gitignore should be
    ```
    *
    !.gitignore
    !instructions/**
    !prompts/**
    !copilot-instructions.md
    ```
- Set my global `github.copilot.chat.codeGeneration.useInstructionFiles` setting to `true`
- If it doesn't already exist, append `$VSCODE_PROFILE/instructions` to the global setting `github.copilot.chat.codeGeneration.instructions` and `chat.instructionsFilesLocations` lists
- If it doesn't already exist, append `$VSCODE_PROFILE/prompts` to the global setting `chat.promptFilesLocations` list
- If `$VSCODE_PROFILE/instructions/global.readonly.instructions.md` file is missing, create it and copy the full contents of `global.readonly.instructions.md` into it, preserving the `applyTo: "**"` header"