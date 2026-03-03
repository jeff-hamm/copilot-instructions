param(
  [string]$WorkspaceRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..\..\..")).Path,
  [string]$CompiledRelativePath = "dist/initial-setup.readonly.prompt.md"
)

$ErrorActionPreference = "Stop"

$builderPath = Join-Path $PSScriptRoot "..\..\regenerate-initial-setup\scripts\initial-setup-builder.ps1"
. $builderPath

$compiledPath = Join-Path $WorkspaceRoot $CompiledRelativePath
if (-not (Test-Path -LiteralPath $compiledPath)) {
  Write-Error "Compiled prompt not found: $compiledPath"
  exit 2
}

$expectedModel = Build-InitialSetupContent -WorkspaceRoot $WorkspaceRoot
$expected = Normalize-Content -Text $expectedModel.Content
$actual = Normalize-Content -Text (Get-Content -LiteralPath $compiledPath -Raw)

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
