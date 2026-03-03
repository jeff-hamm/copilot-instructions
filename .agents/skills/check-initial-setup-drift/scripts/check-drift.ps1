param(
  [string]$WorkspaceRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..\..\..")).Path,
  [string]$CompiledRelativePath = "prompts/initial-setup.readonly.prompt.md"
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

function Normalize {
  param([string]$Text)

  return ($Text -replace "`r`n", "`n").TrimEnd("`n")
}

function Build-Expected {
  param([string]$Root)

  $edit = Read-Source -Path (Join-Path $Root "src/edit-global-files.readonly.prompt.md")
  $envPrep = Read-Source -Path (Join-Path $Root "src/environment-setup.readonly.prompt.md")
  $global = Read-Source -Path (Join-Path $Root "src/global.readonly.instructions.md")

  $header = @(
    "# Initial Copilot Setup",
    "Use this prompt when reusable prompts or global instructions are missing, or when preparing a fresh environment."
  ) -join "`n"

  $recreate = @(
    "## Recreate prompts and instructions",
    "Create or update these files under `$VSCODE_PROFILE`, for each section title is the filename. Use the section's markdown as the file contents (copy verbatim)"
  ) -join "`n"

  return (@(
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
  ) -join "`n")
}

$compiledPath = Join-Path $WorkspaceRoot $CompiledRelativePath
if (-not (Test-Path -LiteralPath $compiledPath)) {
  Write-Error "Compiled prompt not found: $compiledPath"
  exit 2
}

$expected = Normalize -Text (Build-Expected -Root $WorkspaceRoot)
$actual = Normalize -Text (Get-Content -LiteralPath $compiledPath -Raw)

if ($actual -eq $expected) {
  Write-Host "No drift detected."
  exit 0
}

Write-Host "Drift detected between source files and compiled prompt."
$expectedLines = $expected -split "`n"
$actualLines = $actual -split "`n"
Compare-Object -ReferenceObject $expectedLines -DifferenceObject $actualLines -SyncWindow 3 |
  Select-Object -First 80

exit 1
