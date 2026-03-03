param(
  [string]$WorkspaceRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..\..\..")).Path,
  [string]$CompiledRelativePath = "prompts/initial-setup.readonly.prompt.md"
)

$ErrorActionPreference = "Stop"

$builderPath = Join-Path $PSScriptRoot "..\..\regenerate-initial-setup\scripts\initial-setup-builder.ps1"
. $builderPath

$compiledPath = Join-Path $WorkspaceRoot $CompiledRelativePath
$editPath = Join-Path $WorkspaceRoot "src/edit-global-files.readonly.prompt.md"
$globalBootstrapPath = Join-Path $WorkspaceRoot "src/global.bootstrap.readonly.instructions.md"
$globalPath = Join-Path $WorkspaceRoot "src/global.readonly.instructions.md"
$profileResolutionPath = Join-Path $WorkspaceRoot "src/user-skills/common/profile-resolution.md"

$expectedModel = Build-InitialSetupContent -WorkspaceRoot $WorkspaceRoot
$expected = Normalize-Content -Text $expectedModel.Content
$actual = Normalize-Content -Text (Read-Source -Path $compiledPath)

if ($actual -ne $expected) {
  Write-Error "Verification failed: compiled prompt does not match generated content."
  exit 1
}

$requiredMarkers = @(
  "### prompts/edit-global-files.readonly.prompt.md",
  "### instructions/global.readonly.instructions.md",
  "## Global Edit Routing",
  "## Included Prompt Files (Generated)",
  "## Included User Skills (Generated)",
  "## Setup-only references (do not install)",
  "### src/global.bootstrap.readonly.instructions.md",
  "Code - Insiders",
  "Windows (Cursor)"
)

$requiredMarkers += @($expectedModel.PromptSources | ForEach-Object { "### $($_.Section)" })
$requiredMarkers += @($expectedModel.SkillSources | ForEach-Object { "### $($_.Section)" })

foreach ($marker in $requiredMarkers) {
  if ($actual -notlike "*${marker}*") {
    Write-Error "Verification failed: missing marker '$marker' in compiled prompt."
    exit 1
  }
}

$editText = Read-Source -Path $editPath
$globalBootstrapText = Read-Source -Path $globalBootstrapPath
$profileResolutionText = Read-Source -Path $profileResolutionPath

$pathCoverageText = @($editText, $globalBootstrapText, $profileResolutionText) -join "`n"
if ($pathCoverageText -notlike "*Insiders*") {
  Write-Error "Verification failed: source files are missing expected Insiders paths."
  exit 1
}

if ($pathCoverageText -notlike "*Cursor*") {
  Write-Error "Verification failed: source files are missing expected Cursor paths."
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
