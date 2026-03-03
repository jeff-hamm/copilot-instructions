param(
  [string]$WorkspaceRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..\..\..")).Path,
  [string]$OutputRelativePath = "prompts/initial-setup.readonly.prompt.md"
)

$ErrorActionPreference = "Stop"

$builderPath = Join-Path $PSScriptRoot "initial-setup-builder.ps1"
. $builderPath

$model = Build-InitialSetupContent -WorkspaceRoot $WorkspaceRoot -EmitTemporaryGlobalInstructions
$content = $model.Content

$outputPath = Join-Path $WorkspaceRoot $OutputRelativePath
Set-Content -LiteralPath $outputPath -Value $content -Encoding utf8

Write-Host "Regenerated: $outputPath"
if (-not [string]::IsNullOrWhiteSpace($model.TemporaryGlobalInstructionsPath)) {
  Write-Host "Temporary global instructions: $($model.TemporaryGlobalInstructionsPath)"
}

Write-Host "Included prompts: $($model.PromptSources.Count); included user-skill markdown files: $($model.SkillSources.Count)"
