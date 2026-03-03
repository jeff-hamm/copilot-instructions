param(
  [string]$WorkspaceRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..\..\..")).Path,
  [string]$OutputRelativePath = "dist/initial-setup.readonly.prompt.md",
  [string]$BootstrapRelativePath = "dist/new-install.readonly.prompt.md"
)

$ErrorActionPreference = "Stop"

$builderPath = Join-Path $PSScriptRoot "initial-setup-builder.ps1"
. $builderPath

$model = Build-InitialSetupContent -WorkspaceRoot $WorkspaceRoot -EmitTemporaryGlobalInstructions
$content = $model.Content
$bootstrapContent = Build-NewInstallPromptContent -WorkspaceRoot $WorkspaceRoot -CanonicalRelativePath $OutputRelativePath

$outputPath = Join-Path $WorkspaceRoot $OutputRelativePath
$bootstrapPath = Join-Path $WorkspaceRoot $BootstrapRelativePath

$outputDir = Split-Path -Path $outputPath -Parent
if (-not (Test-Path -LiteralPath $outputDir)) {
  New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
}

$bootstrapDir = Split-Path -Path $bootstrapPath -Parent
if (-not (Test-Path -LiteralPath $bootstrapDir)) {
  New-Item -ItemType Directory -Path $bootstrapDir -Force | Out-Null
}

Set-Content -LiteralPath $outputPath -Value $content -Encoding utf8
Set-Content -LiteralPath $bootstrapPath -Value $bootstrapContent -Encoding utf8

Write-Host "Regenerated: $outputPath"
Write-Host "Regenerated: $bootstrapPath"
if (-not [string]::IsNullOrWhiteSpace($model.TemporaryGlobalInstructionsPath)) {
  Write-Host "Temporary global instructions: $($model.TemporaryGlobalInstructionsPath)"
}

Write-Host "Included prompts: $($model.PromptSources.Count); included user-skill markdown files: $($model.SkillSources.Count)"
