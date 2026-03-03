param(
  [string]$WorkspaceRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..\..\..")).Path,
  [string]$OutputRelativePath = "prompts/initial-setup.readonly.prompt.md"
)

$ErrorActionPreference = "Stop"

function Read-Source {
  param([string]$Path)

  if (-not (Test-Path -LiteralPath $Path)) {
    throw "Missing source file: $Path"
  }

  $raw = Get-Content -LiteralPath $Path -Raw
  return $raw.TrimEnd("`r", "`n")
}

$editPath = Join-Path $WorkspaceRoot "src/edit-global-files.readonly.prompt.md"
$envPath = Join-Path $WorkspaceRoot "src/environment-setup.readonly.prompt.md"
$globalPath = Join-Path $WorkspaceRoot "src/global.readonly.instructions.md"

$edit = Read-Source -Path $editPath
$envPrep = Read-Source -Path $envPath
$global = Read-Source -Path $globalPath

$header = @(
  "# Initial Copilot Setup",
  "Use this prompt when reusable prompts or global instructions are missing, or when preparing a fresh environment."
) -join "`n"

$recreate = @(
  "## Recreate prompts and instructions",
  "Create or update these files under `$VSCODE_PROFILE`, for each section title is the filename. Use the section's markdown as the file contents (copy verbatim)"
) -join "`n"

$content = @(
  $header
  ""
  $edit
  ""
  $envPrep
  ""
  $recreate
  ""
  "### prompts/edit-global-files.readonly.prompt.md"
  "````markdown"
  $edit
  "````"
  ""
  "### instructions/global.readonly.instructions.md"
  "````markdown"
  $global
  "````"
  ""
) -join "`n"

$outputPath = Join-Path $WorkspaceRoot $OutputRelativePath
Set-Content -LiteralPath $outputPath -Value $content -Encoding utf8

Write-Host "Regenerated: $outputPath"
