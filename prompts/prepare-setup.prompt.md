# Initial Copilot Setup

Use this prompt when reusable prompts or global instructions are missing, or when preparing a fresh environment.

## Environment preparation
- Install git if it is not already installed
- If ${userHome}/.github is not a git repository, clone it from https://github.com/jeff-hamm/copilot-instructions, or, if that fails, initialize a new git repository there
  - If you create it, the .gitignore should be
    ```
    *
    !instructions/
    !prompts/
    !copilot-instructions.md
    ```
- Set mys global `github.copilot.chat.codeGeneration.useInstructionFiles` setting to `true`
- If it doesn't already exist, append `${userHome}/.github/instructions` to the global setting `github.copilot.chat.codeGeneration.instructions` list
- If it doesn't already exist, append `${userHome}/.github/prompts` to the global setting `github.copilot.chat.promptFilesLocations` list
- If `${userHome}/.github/instructions/copilot-instructions.md` file is missing, create it and copy the full contents of `copilot-instructions.md` into it, preserving the `applyTo: "**"` header"