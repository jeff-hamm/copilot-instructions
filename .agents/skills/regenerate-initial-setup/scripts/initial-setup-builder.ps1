$ErrorActionPreference = "Stop"

function Read-Source {
  param([string]$Path)

  if (-not (Test-Path -LiteralPath $Path)) {
    throw "Missing source file: $Path"
  }

  $raw = Get-Content -LiteralPath $Path -Raw
  return $raw.TrimEnd("`r", "`n")
}

function Normalize-Content {
  param([string]$Text)

  return ($Text -replace "`r`n", "`n").TrimEnd("`n")
}

function Expand-TemplateTokens {
  param(
    [string]$Content,
    [hashtable]$TemplateMap
  )

  $expanded = $Content
  foreach ($token in $TemplateMap.Keys) {
    $expanded = $expanded.Replace($token, $TemplateMap[$token])
  }

  return $expanded
}

function Get-RelativePathNormalized {
  param(
    [string]$FullPath,
    [string]$BasePath
  )

  $relative = [System.IO.Path]::GetRelativePath($BasePath, $FullPath)
  return ($relative -replace "\\", "/")
}

function Unquote-Value {
  param([string]$Value)

  $trimmed = $Value.Trim()
  if (($trimmed.StartsWith("'") -and $trimmed.EndsWith("'")) -or ($trimmed.StartsWith('"') -and $trimmed.EndsWith('"'))) {
    return $trimmed.Substring(1, $trimmed.Length - 2)
  }

  return $trimmed
}

function Get-SkillMetadataFromContent {
  param([string]$Content)

  $name = $null
  $description = $null

  if ($Content -match "(?s)^---\s*\n(.*?)\n---\s*\n") {
    $frontmatter = $Matches[1]
    foreach ($line in ($frontmatter -split "`n")) {
      if (-not $name -and $line -match "^\s*name:\s*(.+?)\s*$") {
        $name = Unquote-Value -Value $Matches[1]
      }

      if (-not $description -and $line -match "^\s*description:\s*(.+?)\s*$") {
        $description = Unquote-Value -Value $Matches[1]
      }
    }
  }

  return [PSCustomObject]@{
    Name = $name
    Description = $description
  }
}

function Get-PromptSummary {
  param([string]$Content)

  foreach ($line in ($Content -split "`n")) {
    $trim = $line.Trim()
    if ([string]::IsNullOrWhiteSpace($trim)) { continue }
    if ($trim.StartsWith("#")) { continue }
    if ($trim.StartsWith('```')) { continue }
    return $trim
  }

  return "Reusable prompt workflow."
}

function Get-PromptSources {
  param([string]$WorkspaceRoot)

  $promptRoot = Join-Path $WorkspaceRoot "src/prompts"
  if (-not (Test-Path -LiteralPath $promptRoot)) {
    return @()
  }

  $files = Get-ChildItem -LiteralPath $promptRoot -File -Filter "*.prompt.md" | Sort-Object Name
  $result = @()

  foreach ($file in $files) {
    $content = Read-Source -Path $file.FullName
    $result += [PSCustomObject]@{
      SourcePath = $file.FullName
      Name = $file.Name
      Section = "prompts/$($file.Name)"
      Content = $content
      Summary = Get-PromptSummary -Content $content
    }
  }

  return $result
}

function Get-UserSkillSources {
  param([string]$WorkspaceRoot)

  $skillRoot = Join-Path $WorkspaceRoot "src/user-skills"
  if (-not (Test-Path -LiteralPath $skillRoot)) {
    return @()
  }

  $files = Get-ChildItem -LiteralPath $skillRoot -Recurse -File -Filter "*.md" | Sort-Object FullName
  $profileResolutionTemplatePath = Join-Path $WorkspaceRoot "src/profile-resolution-runner.template.md"
  $profileResolutionContent = Read-Source -Path $profileResolutionTemplatePath
  $templateMap = @{
    '{{PROFILE_RESOLUTION_CONTENT}}' = $profileResolutionContent
  }

  $resolverPs1Path = Join-Path $skillRoot "common/resolve-vscode-profile.ps1"
  $resolverShPath = Join-Path $skillRoot "common/resolve-vscode-profile.sh"
  $resolverPs1Content = Read-Source -Path $resolverPs1Path
  $resolverShContent = Read-Source -Path $resolverShPath

  $result = @()
  $resolverTargetDirs = New-Object System.Collections.Generic.HashSet[string]

  foreach ($file in $files) {
    $relative = Get-RelativePathNormalized -FullPath $file.FullName -BasePath $skillRoot
    $rawContent = Read-Source -Path $file.FullName
    $usesProfileResolutionTemplate = $rawContent.Contains('{{PROFILE_RESOLUTION_CONTENT}}')
    $content = $rawContent
    $content = Expand-TemplateTokens -Content $content -TemplateMap $templateMap
    $metadata = Get-SkillMetadataFromContent -Content $content

    $isSkill = ($file.Name -ieq "SKILL.md") -and -not [string]::IsNullOrWhiteSpace($metadata.Name)
    $summary = if ($isSkill -and -not [string]::IsNullOrWhiteSpace($metadata.Description)) {
      $metadata.Description
    }
    elseif ($isSkill) {
      "User skill workflow."
    }
    else {
      "Shared skill reference file."
    }

    if ($isSkill -and $usesProfileResolutionTemplate) {
      $skillDir = (Split-Path -Path $relative -Parent) -replace "\\", "/"
      if (-not [string]::IsNullOrWhiteSpace($skillDir)) {
        [void]$resolverTargetDirs.Add($skillDir)
      }
    }

    $result += [PSCustomObject]@{
      SourcePath = $file.FullName
      RelativePath = $relative
      Section = ".agents/skills/$relative"
      Content = $content
      IsSkill = $isSkill
      SkillName = $metadata.Name
      Summary = $summary
    }
  }

  foreach ($targetDir in ($resolverTargetDirs | Sort-Object)) {
    $result += [PSCustomObject]@{
      SourcePath = $resolverPs1Path
      RelativePath = "$targetDir/resolve-vscode-profile.ps1"
      Section = ".agents/skills/$targetDir/resolve-vscode-profile.ps1"
      Content = $resolverPs1Content
      IsSkill = $false
      SkillName = $null
      Summary = "Generated co-located profile resolver script."
    }

    $result += [PSCustomObject]@{
      SourcePath = $resolverShPath
      RelativePath = "$targetDir/resolve-vscode-profile.sh"
      Section = ".agents/skills/$targetDir/resolve-vscode-profile.sh"
      Content = $resolverShContent
      IsSkill = $false
      SkillName = $null
      Summary = "Generated co-located profile resolver script."
    }
  }

  return $result
}

function Build-DynamicGlobalInstructions {
  param(
    [string]$WorkspaceRoot,
    [array]$PromptSources,
    [array]$SkillSources
  )

  $templatePath = Join-Path $WorkspaceRoot "src/global.readonly.instructions.template.md"
  $template = Read-Source -Path $templatePath

  $promptItems = if ($PromptSources.Count -eq 0) {
    '- None detected in `src/prompts/`.'
  }
  else {
    (@($PromptSources | ForEach-Object { '- `{0}`: {1}' -f $_.Name, $_.Summary }) -join "`n")
  }

  $skillItems = @($SkillSources | Where-Object { $_.IsSkill })
  $skillItemsText = if ($skillItems.Count -eq 0) {
    '- None detected in `src/user-skills/`.'
  }
  else {
    (@($skillItems | ForEach-Object { '- `/{0}`: {1}' -f $_.SkillName, $_.Summary }) -join "`n")
  }

  if (-not $template.Contains('{{GENERATED_PROMPT_ITEMS}}')) {
    throw "Missing template placeholder '{{GENERATED_PROMPT_ITEMS}}' in $templatePath"
  }

  if (-not $template.Contains('{{GENERATED_SKILL_ITEMS}}')) {
    throw "Missing template placeholder '{{GENERATED_SKILL_ITEMS}}' in $templatePath"
  }

  $rendered = $template.Replace('{{GENERATED_PROMPT_ITEMS}}', $promptItems)
  $rendered = $rendered.Replace('{{GENERATED_SKILL_ITEMS}}', $skillItemsText)

  return $rendered
}

function Write-TemporaryGlobalInstructions {
  param([string]$Content)

  $tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) "copilot-instructions"
  if (-not (Test-Path -LiteralPath $tempRoot)) {
    New-Item -ItemType Directory -Path $tempRoot -Force | Out-Null
  }

  $filename = "global.readonly.instructions.generated.$([DateTime]::UtcNow.ToString('yyyyMMddHHmmss')).$([guid]::NewGuid().ToString('N')).md"
  $tempPath = Join-Path $tempRoot $filename
  Set-Content -LiteralPath $tempPath -Value $Content -Encoding utf8

  return $tempPath
}

function Resolve-OriginRawUrl {
  param(
    [string]$WorkspaceRoot,
    [string]$CanonicalRelativePath
  )

  $git = Get-Command git -ErrorAction SilentlyContinue
  if ($null -eq $git) {
    throw "git is required to generate dist/new-install.readonly.prompt.md"
  }

  $originUrl = (& git -C $WorkspaceRoot remote get-url origin 2>$null)
  $originUrl = if ($null -eq $originUrl) { "" } else { $originUrl.Trim() }
  if ([string]::IsNullOrWhiteSpace($originUrl)) {
    throw "Unable to resolve git remote 'origin' for $WorkspaceRoot"
  }

  $originHeadRef = (& git -C $WorkspaceRoot symbolic-ref refs/remotes/origin/HEAD 2>$null)
  $originHeadRef = if ($null -eq $originHeadRef) { "" } else { $originHeadRef.Trim() }

  $branch = "main"
  if ($originHeadRef -match "^refs/remotes/origin/(.+)$") {
    $branch = $Matches[1]
  }

  $owner = $null
  $repo = $null

  if ($originUrl -match "^https://github\.com/(?<owner>[^/]+)/(?<repo>[^/]+?)(?:\.git)?/?$") {
    $owner = $Matches['owner']
    $repo = $Matches['repo']
  }
  elseif ($originUrl -match "^git@github\.com:(?<owner>[^/]+)/(?<repo>[^/]+?)(?:\.git)?$") {
    $owner = $Matches['owner']
    $repo = $Matches['repo']
  }
  elseif ($originUrl -match "^ssh://git@github\.com/(?<owner>[^/]+)/(?<repo>[^/]+?)(?:\.git)?/?$") {
    $owner = $Matches['owner']
    $repo = $Matches['repo']
  }
  else {
    throw "Unsupported origin URL for raw GitHub generation: $originUrl"
  }

  $canonical = ($CanonicalRelativePath -replace "\\", "/")
  $rawUrl = "https://raw.githubusercontent.com/$owner/$repo/$branch/$canonical"

  return [PSCustomObject]@{
    OriginUrl = $originUrl
    Branch = $branch
    RawUrl = $rawUrl
    CanonicalRelativePath = $canonical
  }
}

function Build-NewInstallPromptContent {
  param(
    [string]$WorkspaceRoot,
    [string]$CanonicalRelativePath = "dist/initial-setup.readonly.prompt.md"
  )

  $origin = Resolve-OriginRawUrl -WorkspaceRoot $WorkspaceRoot -CanonicalRelativePath $CanonicalRelativePath
  $tempPath = '<TEMP_DIR>/copilot-instructions/initial-setup.readonly.prompt.md'
  $lines = @(
    "# Install Initial Setup",
    "Download and run the bootstrap prompt from this raw URL.",
    "",
    ('Raw URL: `{0}`' -f $origin.RawUrl),
    ('Temp file: `{0}`' -f $tempPath),
    "",
    ('1. Create `{0}` if it does not exist.' -f '<TEMP_DIR>/copilot-instructions'),
    ('2. Download `{0}` to `{1}`.' -f $origin.RawUrl, $tempPath),
    '3. Confirm the downloaded file starts with `# Initial Copilot Setup`.',
    ('4. Run `{0}` as a prompt.' -f $tempPath)
  )

  return ($lines -join "`n")
}

function Build-InitialSetupContent {
  param(
    [string]$WorkspaceRoot,
    [switch]$EmitTemporaryGlobalInstructions
  )

  $edit = Read-Source -Path (Join-Path $WorkspaceRoot "src/edit-global-files.readonly.prompt.md")
  $envPrep = Read-Source -Path (Join-Path $WorkspaceRoot "src/environment-setup.readonly.prompt.md")
  $profileResolverSetup = Read-Source -Path (Join-Path $WorkspaceRoot "src/profile-resolution-scripts.readonly.prompt.md")
  $globalBootstrap = Read-Source -Path (Join-Path $WorkspaceRoot "src/global.bootstrap.readonly.instructions.md")

  $promptSources = Get-PromptSources -WorkspaceRoot $WorkspaceRoot
  $skillSources = Get-UserSkillSources -WorkspaceRoot $WorkspaceRoot

  $generatedGlobal = Build-DynamicGlobalInstructions -WorkspaceRoot $WorkspaceRoot -PromptSources $promptSources -SkillSources $skillSources

  $temporaryGlobalPath = $null
  if ($EmitTemporaryGlobalInstructions.IsPresent) {
    $temporaryGlobalPath = Write-TemporaryGlobalInstructions -Content $generatedGlobal
  }

  $header = @(
    "# Initial Copilot Setup",
    "Use this prompt when reusable prompts or global instructions are missing, or when preparing a fresh environment."
  ) -join "`n"

  $recreate = @(
    "## Recreate prompts, instructions, and user-profile skills",
    "Create or update these files under `$VSCODE_PROFILE` and `~/.agents/skills`, where each section title is the filename. Use the section's markdown as the file contents (copy verbatim)"
  ) -join "`n"

  $lines = @(
    $header,
    "",
    $edit,
    "",
    $envPrep,
    "",
    $profileResolverSetup,
    "",
    $recreate,
    "",
    "### prompts/edit-global-files.readonly.prompt.md",
    '````markdown',
    $edit,
    '````',
    "",
    "### instructions/global.readonly.instructions.md",
    '````markdown',
    $generatedGlobal,
    '````',
    ""
  )

  foreach ($prompt in $promptSources) {
    $lines += "### $($prompt.Section)"
    $lines += '````markdown'
    $lines += $prompt.Content
    $lines += '````'
    $lines += ""
  }

  foreach ($skill in $skillSources) {
    $lines += "### $($skill.Section)"
    $lines += '````markdown'
    $lines += $skill.Content
    $lines += '````'
    $lines += ""
  }

  $lines += "## Setup-only references (do not install)"
  $lines += ""
  $lines += "### src/global.bootstrap.readonly.instructions.md"
  $lines += '````markdown'
  $lines += $globalBootstrap
  $lines += '````'
  $lines += ""

  return [PSCustomObject]@{
    Content = ($lines -join "`n")
    PromptSources = $promptSources
    SkillSources = $skillSources
    GeneratedGlobalInstructions = $generatedGlobal
    TemporaryGlobalInstructionsPath = $temporaryGlobalPath
  }
}
