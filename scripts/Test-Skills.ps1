[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$skillsRoot = Join-Path $repoRoot 'skills'
$errors = [System.Collections.Generic.List[string]]::new()

if (-not (Test-Path -LiteralPath $skillsRoot -PathType Container)) {
    throw "Missing skills directory: $skillsRoot"
}

$skillDirectories = @(Get-ChildItem -LiteralPath $skillsRoot -Directory | Sort-Object Name)

foreach ($directory in $skillDirectories) {
    if ($directory.Name -cnotmatch '^[a-z0-9]+(?:-[a-z0-9]+)*$') {
        $errors.Add("$($directory.Name): directory name must use kebab-case")
    }

    $skillFile = Join-Path $directory.FullName 'SKILL.md'
    if (-not (Test-Path -LiteralPath $skillFile -PathType Leaf)) {
        $errors.Add("$($directory.Name): missing SKILL.md")
        continue
    }

    $content = Get-Content -LiteralPath $skillFile -Raw -Encoding UTF8
    if ($content -notmatch '(?s)^---\r?\n(.*?)\r?\n---(?:\r?\n|$)') {
        $errors.Add("$($directory.Name): SKILL.md must start with YAML frontmatter")
    }
    else {
        $frontmatter = $Matches[1]
        $nameMatch = [regex]::Match($frontmatter, '(?m)^name:\s*["'']?([^"''\r\n]+)["'']?\s*$')
        $descriptionMatch = [regex]::Match($frontmatter, '(?m)^description:\s*.+$')

        if (-not $nameMatch.Success) {
            $errors.Add("$($directory.Name): frontmatter is missing name")
        }
        elseif ($nameMatch.Groups[1].Value.Trim() -cne $directory.Name) {
            $errors.Add("$($directory.Name): frontmatter name '$($nameMatch.Groups[1].Value.Trim())' does not match directory")
        }

        if (-not $descriptionMatch.Success) {
            $errors.Add("$($directory.Name): frontmatter is missing description")
        }
    }

    $agentFile = Join-Path $directory.FullName 'agents\openai.yaml'
    if (-not (Test-Path -LiteralPath $agentFile -PathType Leaf)) {
        $errors.Add("$($directory.Name): missing agents/openai.yaml")
    }
    else {
        $agentContent = Get-Content -LiteralPath $agentFile -Raw -Encoding UTF8
        foreach ($field in @('display_name', 'short_description')) {
            if ($agentContent -notmatch "(?m)^\s{2}$($field):\s*.+$") {
                $errors.Add("$($directory.Name): agents/openai.yaml is missing interface.$field")
            }
        }
    }
}

$skillFiles = @(Get-ChildItem -LiteralPath $skillsRoot -Recurse -File -Filter 'SKILL.md')
$nestedSkills = @($skillFiles | Where-Object { $_.Directory.Parent.FullName -cne $skillsRoot })
foreach ($nestedSkill in $nestedSkills) {
    $errors.Add("$($nestedSkill.FullName): nested skill detected; skills must be direct children of skills/")
}

if ($errors.Count -gt 0) {
    Write-Host "Skill validation failed with $($errors.Count) error(s):" -ForegroundColor Red
    $errors | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
    exit 1
}

$referenceFiles = @(Get-ChildItem -LiteralPath $skillsRoot -Recurse -File | Where-Object { $_.FullName -like '*\references\*' })
$scriptFiles = @(Get-ChildItem -LiteralPath $skillsRoot -Recurse -File | Where-Object { $_.FullName -like '*\scripts\*' })

Write-Host 'Skill validation passed.' -ForegroundColor Green
Write-Host "  Skills:        $($skillDirectories.Count)"
Write-Host "  References:    $($referenceFiles.Count)"
Write-Host "  Skill scripts: $($scriptFiles.Count)"
