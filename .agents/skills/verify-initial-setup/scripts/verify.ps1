param(
  [string]$WorkspaceRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..\..\..")).Path,
  [string]$CompiledRelativePath = "prompts/initial-setup.readonly.prompt.md"
)

$ErrorActionPreference = "Stop"

function Read-Source {
  param([string]$Path)

  if (-not (Test-Path -LiteralPath $Path)) {
    throw "Missing file: $Path"
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
$editPath = Join-Path $WorkspaceRoot "src/edit-global-files.readonly.prompt.md"
$globalPath = Join-Path $WorkspaceRoot "src/global.readonly.instructions.md"

$expected = Normalize -Text (Build-Expected -Root $WorkspaceRoot)
$actual = Normalize -Text (Read-Source -Path $compiledPath)

if ($actual -ne $expected) {
  Write-Error "Verification failed: compiled prompt does not match generated content."
  exit 1
}

$requiredMarkers = @(
  "### prompts/edit-global-files.readonly.prompt.md",
  "### instructions/global.readonly.instructions.md",
  "Code - Insiders"
)

foreach ($marker in $requiredMarkers) {
  if ($actual -notlike "*${marker}*") {
    Write-Error "Verification failed: missing marker '$marker' in compiled prompt."
    exit 1
  }
}

$editText = Read-Source -Path $editPath
$globalText = Read-Source -Path $globalPath
if (($editText -notlike "*Insiders*") -or ($globalText -notlike "*Insiders*")) {
  Write-Error "Verification failed: source files are missing expected Insiders paths."
  exit 1
}

Write-Host "Verification checks passed."

$gitCommand = Get-Command git -ErrorAction SilentlyContinue
if ($null -eq $gitCommand) {
  Write-Warning "git is not available; skipping status and diff summary."
  exit 0
}

Push-Location $WorkspaceRoot
try {
  Write-Host "`nGit status:"
  git status --short

  Write-Host "`nDiff summary:"
  git diff --stat
}
finally {
  Pop-Location
}

exit 0
