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
  $result = @()

  foreach ($file in $files) {
    $relative = Get-RelativePathNormalized -FullPath $file.FullName -BasePath $skillRoot
    $content = Read-Source -Path $file.FullName
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

  return $result
}

function Build-DynamicGlobalInstructions {
  param(
    [string]$WorkspaceRoot,
    [array]$PromptSources,
    [array]$SkillSources
  )

  $base = Read-Source -Path (Join-Path $WorkspaceRoot "src/global.readonly.instructions.md")
  $baseLines = @($base -split "`n")

  $routerStart = [Array]::IndexOf($baseLines, "## Global Edit Routing")
  if ($routerStart -lt 0) {
    throw "Missing '## Global Edit Routing' section in src/global.readonly.instructions.md"
  }

  $nextSection = -1
  for ($i = $routerStart + 1; $i -lt $baseLines.Count; $i++) {
    if ($baseLines[$i] -like "## *") {
      $nextSection = $i
      break
    }
  }

  $prefix = @()
  if ($routerStart -gt 0) {
    $prefix = @($baseLines[0..($routerStart - 1)])
  }

  $routerSection = if ($nextSection -gt 0) {
    @($baseLines[$routerStart..($nextSection - 1)])
  }
  else {
    @($baseLines[$routerStart..($baseLines.Count - 1)])
  }

  $routerOnlyBase = ((@($prefix + $routerSection) -join "`n").TrimEnd("`n"))
  $lines = @($routerOnlyBase, "")

  $lines += "## Included Prompt Files (Generated)"
  if ($PromptSources.Count -eq 0) {
    $lines += '- None detected in `src/prompts/`.'
  }
  else {
    foreach ($prompt in $PromptSources) {
      $lines += ('- `{0}`: {1}' -f $prompt.Name, $prompt.Summary)
    }
  }

  $lines += ""
  $lines += "## Included User Skills (Generated)"
  $skillItems = @($SkillSources | Where-Object { $_.IsSkill })
  if ($skillItems.Count -eq 0) {
    $lines += '- None detected in `src/user-skills/`.'
  }
  else {
    foreach ($skill in $skillItems) {
      $lines += ('- `/{0}`: {1}' -f $skill.SkillName, $skill.Summary)
    }
  }

  return ($lines -join "`n")
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
