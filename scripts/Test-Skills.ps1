[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$skillsRoot = Join-Path $repoRoot 'skills'
$errors = [System.Collections.Generic.List[string]]::new()

if (-not (Test-Path -LiteralPath $skillsRoot -PathType Container)) {
    throw "Missing skills directory: $skillsRoot"
}

$groupDirectories = @(Get-ChildItem -LiteralPath $skillsRoot -Directory | Sort-Object Name)
$skillDirectories = [System.Collections.Generic.List[System.IO.DirectoryInfo]]::new()
$seenSkillNames = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)

if ($groupDirectories.Count -eq 0) {
    $errors.Add('skills/: no scenario groups found')
}

for ($index = 0; $index -lt $groupDirectories.Count; $index++) {
    $group = $groupDirectories[$index]
    $expectedPrefix = '{0:D2}-' -f ($index + 1)

    if ($group.Name -cnotmatch '^\d{2}-[a-z0-9]+(?:-[a-z0-9]+)*$') {
        $errors.Add("$($group.Name): scenario directory must use NN-kebab-case")
    }
    elseif (-not $group.Name.StartsWith($expectedPrefix, [System.StringComparison]::Ordinal)) {
        $errors.Add("$($group.Name): scenario numbering must be consecutive from 01")
    }

    $groupFiles = @(Get-ChildItem -LiteralPath $group.FullName -File)
    foreach ($groupFile in $groupFiles) {
        $errors.Add("$($group.Name): unexpected file at scenario root: $($groupFile.Name)")
    }

    $groupSkills = @(Get-ChildItem -LiteralPath $group.FullName -Directory | Sort-Object Name)
    if ($groupSkills.Count -eq 0) {
        $errors.Add("$($group.Name): scenario group contains no skills")
    }

    foreach ($directory in $groupSkills) {
        $skillDirectories.Add($directory)
    }
}

foreach ($directory in $skillDirectories) {
    $relativeSkill = "$($directory.Parent.Name)/$($directory.Name)"

    if ($directory.Name -cnotmatch '^[a-z0-9]+(?:-[a-z0-9]+)*$') {
        $errors.Add("${relativeSkill}: skill directory name must use kebab-case")
    }

    if (-not $seenSkillNames.Add($directory.Name)) {
        $errors.Add("${relativeSkill}: duplicate skill directory name '$($directory.Name)'")
    }

    $skillFile = Join-Path $directory.FullName 'SKILL.md'
    if (-not (Test-Path -LiteralPath $skillFile -PathType Leaf)) {
        $errors.Add("${relativeSkill}: missing SKILL.md")
        continue
    }

    $content = Get-Content -LiteralPath $skillFile -Raw -Encoding UTF8
    if ($content -notmatch '(?s)^---\r?\n(.*?)\r?\n---(?:\r?\n|$)') {
        $errors.Add("${relativeSkill}: SKILL.md must start with YAML frontmatter")
    }
    else {
        $frontmatter = $Matches[1]
        $nameMatch = [regex]::Match($frontmatter, '(?m)^name:\s*["'']?([^"''\r\n]+)["'']?\s*$')
        $descriptionMatch = [regex]::Match($frontmatter, '(?m)^description:\s*.+$')

        if (-not $nameMatch.Success) {
            $errors.Add("${relativeSkill}: frontmatter is missing name")
        }
        elseif ($nameMatch.Groups[1].Value.Trim() -cne $directory.Name) {
            $errors.Add("${relativeSkill}: frontmatter name '$($nameMatch.Groups[1].Value.Trim())' does not match directory")
        }

        if (-not $descriptionMatch.Success) {
            $errors.Add("${relativeSkill}: frontmatter is missing description")
        }
    }

    $agentFile = Join-Path $directory.FullName 'agents\openai.yaml'
    if (-not (Test-Path -LiteralPath $agentFile -PathType Leaf)) {
        $errors.Add("${relativeSkill}: missing agents/openai.yaml")
    }
    else {
        $agentContent = Get-Content -LiteralPath $agentFile -Raw -Encoding UTF8
        foreach ($field in @('display_name', 'short_description')) {
            if ($agentContent -notmatch "(?m)^\s{2}$($field):\s*.+$") {
                $errors.Add("${relativeSkill}: agents/openai.yaml is missing interface.$field")
            }
        }
    }
}

$knownSkillFiles = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
foreach ($directory in $skillDirectories) {
    [void]$knownSkillFiles.Add((Join-Path $directory.FullName 'SKILL.md'))
}

$allSkillFiles = @(Get-ChildItem -LiteralPath $skillsRoot -Recurse -File -Filter 'SKILL.md')
foreach ($skillFile in $allSkillFiles) {
    if (-not $knownSkillFiles.Contains($skillFile.FullName)) {
        $errors.Add("$($skillFile.FullName): skill must be exactly one level below a scenario group")
    }
}

if ($errors.Count -gt 0) {
    Write-Host "Skill validation failed with $($errors.Count) error(s):" -ForegroundColor Red
    $errors | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
    exit 1
}

$referenceFiles = @(Get-ChildItem -LiteralPath $skillsRoot -Recurse -File | Where-Object { $_.FullName -like '*\references\*' })
$scriptFiles = @(Get-ChildItem -LiteralPath $skillsRoot -Recurse -File | Where-Object { $_.FullName -like '*\scripts\*' })

Write-Host 'Skill validation passed.' -ForegroundColor Green
Write-Host "  Scenario groups: $($groupDirectories.Count)"
Write-Host "  Skills:          $($skillDirectories.Count)"
Write-Host "  References:      $($referenceFiles.Count)"
Write-Host "  Skill scripts:   $($scriptFiles.Count)"
