[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$skillsRoot = Join-Path $repoRoot 'skills'
$errors = [System.Collections.Generic.List[string]]::new()

$expectedScenarioCount = 8
$expectedSkillCount = 25
$maxSkillLines = 100
$maxTotalSkillLines = 1600
$maxTotalSkillChars = 100000
$maxDescriptionChars = 300
$allowedSkillDirectories = @('agents', 'assets', 'references', 'scripts')
$retiredSkillNames = @(
    'ask-matt',
    'setup-matt-pocock-skills',
    'grill-me',
    'grill-with-docs',
    'implement',
    'improve-codebase-architecture',
    'code-review',
    'teach',
    'wait-what',
    'writing-for-agents'
)

function Test-MarkdownLinks {
    param(
        [Parameter(Mandatory)]
        [System.IO.FileInfo]$File
    )

    $markdown = Get-Content -LiteralPath $File.FullName -Raw -Encoding UTF8
    $outsideFences = [regex]::Replace(
        $markdown,
        '(?ms)^[ \t]*(```|~~~)[^\r\n]*\r?\n.*?^[ \t]*\1[ \t]*(?:\r?\n|$)',
        ''
    )
    $relativeFile = $File.FullName.Substring($repoRoot.Length + 1)

    foreach ($linkMatch in [regex]::Matches($outsideFences, '\[[^\]]*\]\(([^)]+)\)')) {
        $target = $linkMatch.Groups[1].Value.Trim().Trim('<', '>')
        if ($target -match '^(?:[A-Za-z][A-Za-z0-9+.-]*:|#)') {
            continue
        }

        $targetPath = ($target -split '#', 2)[0]
        if ([string]::IsNullOrWhiteSpace($targetPath)) {
            continue
        }

        $resolvedTarget = Join-Path $File.DirectoryName $targetPath
        if (-not (Test-Path -LiteralPath $resolvedTarget)) {
            $errors.Add("${relativeFile}: Markdown link does not resolve: $target")
        }
    }
}

if (-not (Test-Path -LiteralPath $skillsRoot -PathType Container)) {
    throw "Missing skills directory: $skillsRoot"
}

$groupDirectories = @(Get-ChildItem -LiteralPath $skillsRoot -Directory | Sort-Object Name)
$skillDirectories = [System.Collections.Generic.List[System.IO.DirectoryInfo]]::new()
$seenSkillNames = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)

if ($groupDirectories.Count -eq 0) {
    $errors.Add('skills/: no scenario groups found')
}
elseif ($groupDirectories.Count -ne $expectedScenarioCount) {
    $errors.Add("skills/: expected $expectedScenarioCount scenario groups, found $($groupDirectories.Count)")
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

    foreach ($groupFile in @(Get-ChildItem -LiteralPath $group.FullName -File)) {
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

if ($skillDirectories.Count -ne $expectedSkillCount) {
    $errors.Add("skills/: expected $expectedSkillCount skills, found $($skillDirectories.Count)")
}

$totalSkillLines = 0
$totalSkillChars = 0
$referenceCount = 0
$assetCount = 0
$scriptCount = 0

foreach ($directory in $skillDirectories) {
    $relativeSkill = "$($directory.Parent.Name)/$($directory.Name)"

    if ($directory.Name -cnotmatch '^[a-z0-9]+(?:-[a-z0-9]+)*$') {
        $errors.Add("${relativeSkill}: skill directory name must use kebab-case")
    }

    if (-not $seenSkillNames.Add($directory.Name)) {
        $errors.Add("${relativeSkill}: duplicate skill directory name '$($directory.Name)'")
    }

    foreach ($entry in @(Get-ChildItem -LiteralPath $directory.FullName -Force)) {
        if ($entry.PSIsContainer) {
            if ($entry.Name -notin $allowedSkillDirectories) {
                $errors.Add("${relativeSkill}: unexpected directory at skill root: $($entry.Name)")
            }
        }
        elseif ($entry.Name -cne 'SKILL.md') {
            $errors.Add("${relativeSkill}: unexpected file at skill root: $($entry.Name)")
        }
    }

    $skillFile = Join-Path $directory.FullName 'SKILL.md'
    if (-not (Test-Path -LiteralPath $skillFile -PathType Leaf)) {
        $errors.Add("${relativeSkill}: missing SKILL.md")
        continue
    }

    $skillLines = @(Get-Content -LiteralPath $skillFile -Encoding UTF8)
    $content = Get-Content -LiteralPath $skillFile -Raw -Encoding UTF8
    $totalSkillLines += $skillLines.Count
    $totalSkillChars += $content.Length

    if ($skillLines.Count -gt $maxSkillLines) {
        $errors.Add("${relativeSkill}: SKILL.md has $($skillLines.Count) lines; maximum is $maxSkillLines")
    }

    if ($content -notmatch '(?s)^---\r?\n(.*?)\r?\n---(?:\r?\n|$)') {
        $errors.Add("${relativeSkill}: SKILL.md must start with YAML frontmatter")
    }
    else {
        $frontmatter = $Matches[1]
        $frontmatterKeys = @(
            [regex]::Matches($frontmatter, '(?m)^([A-Za-z0-9_-]+):') |
                ForEach-Object { $_.Groups[1].Value }
        )

        foreach ($key in @($frontmatterKeys | Where-Object { $_ -notin @('name', 'description') })) {
            $errors.Add("${relativeSkill}: unsupported frontmatter field '$key'")
        }

        foreach ($requiredKey in @('name', 'description')) {
            if (@($frontmatterKeys | Where-Object { $_ -ceq $requiredKey }).Count -ne 1) {
                $errors.Add("${relativeSkill}: frontmatter must contain exactly one '$requiredKey' field")
            }
        }

        $nameMatch = [regex]::Match($frontmatter, '(?m)^name:\s*["'']?([^"''\r\n]+)["'']?\s*$')
        $descriptionMatch = [regex]::Match($frontmatter, '(?m)^description:\s*(.+?)\s*$')

        if (-not $nameMatch.Success) {
            $errors.Add("${relativeSkill}: frontmatter is missing name")
        }
        elseif ($nameMatch.Groups[1].Value.Trim() -cne $directory.Name) {
            $errors.Add("${relativeSkill}: frontmatter name '$($nameMatch.Groups[1].Value.Trim())' does not match directory")
        }

        if (-not $descriptionMatch.Success -or [string]::IsNullOrWhiteSpace($descriptionMatch.Groups[1].Value)) {
            $errors.Add("${relativeSkill}: frontmatter is missing description")
        }
        else {
            $description = $descriptionMatch.Groups[1].Value.Trim().Trim('"').Trim("'")
            if ($description.Length -gt $maxDescriptionChars) {
                $errors.Add("${relativeSkill}: description has $($description.Length) characters; maximum is $maxDescriptionChars")
            }
        }
    }

    $agentDirectory = Join-Path $directory.FullName 'agents'
    $agentFile = Join-Path $agentDirectory 'openai.yaml'
    if (-not (Test-Path -LiteralPath $agentFile -PathType Leaf)) {
        $errors.Add("${relativeSkill}: missing agents/openai.yaml")
    }
    else {
        foreach ($agentEntry in @(Get-ChildItem -LiteralPath $agentDirectory -Force)) {
            if ($agentEntry.PSIsContainer -or $agentEntry.Name -cne 'openai.yaml') {
                $errors.Add("${relativeSkill}: unexpected entry in agents/: $($agentEntry.Name)")
            }
        }

        $agentContent = Get-Content -LiteralPath $agentFile -Raw -Encoding UTF8
        if (@([regex]::Matches($agentContent, '(?m)^interface:\s*$')).Count -ne 1) {
            $errors.Add("${relativeSkill}: agents/openai.yaml must contain exactly one top-level interface mapping")
        }

        $interfaceValues = @{}
        foreach ($field in @('display_name', 'short_description', 'default_prompt')) {
            $fieldPattern = '(?m)^\s{{2}}{0}:\s*"([^"]+)"\s*$' -f [regex]::Escape($field)
            $fieldMatch = [regex]::Match($agentContent, $fieldPattern)
            if (-not $fieldMatch.Success) {
                $errors.Add("${relativeSkill}: agents/openai.yaml must contain quoted interface.$field")
            }
            else {
                $interfaceValues[$field] = $fieldMatch.Groups[1].Value
            }
        }

        if ($interfaceValues.ContainsKey('short_description')) {
            $shortLength = $interfaceValues['short_description'].Length
            if ($shortLength -lt 25 -or $shortLength -gt 64) {
                $errors.Add("${relativeSkill}: short_description has $shortLength characters; expected 25-64")
            }
        }

        if ($interfaceValues.ContainsKey('default_prompt')) {
            $skillToken = '$' + $directory.Name
            if (-not $interfaceValues['default_prompt'].Contains($skillToken)) {
                $errors.Add("${relativeSkill}: default_prompt must mention $skillToken")
            }
        }

        if ($agentContent -match '(?m)^policy:\s*$' -and
            $agentContent -notmatch '(?m)^\s{2}allow_implicit_invocation:\s*(?:true|false)\s*$') {
            $errors.Add("${relativeSkill}: policy must define allow_implicit_invocation as true or false")
        }
    }

    $referencesDirectory = Join-Path $directory.FullName 'references'
    if (Test-Path -LiteralPath $referencesDirectory -PathType Container) {
        foreach ($nestedDirectory in @(Get-ChildItem -LiteralPath $referencesDirectory -Directory)) {
            $errors.Add("${relativeSkill}: references must stay one level deep: $($nestedDirectory.Name)")
        }

        $referenceFiles = @(Get-ChildItem -LiteralPath $referencesDirectory -File)
        $referenceCount += $referenceFiles.Count
        foreach ($referenceFile in $referenceFiles) {
            if ($referenceFile.Extension -ieq '.md') {
                $referenceLines = @(Get-Content -LiteralPath $referenceFile.FullName -Encoding UTF8)
                if ($referenceLines.Count -gt 100) {
                    $referenceContent = Get-Content -LiteralPath $referenceFile.FullName -Raw -Encoding UTF8
                    if ($referenceContent -notmatch '(?im)^##\s+(?:contents|table of contents|\u76EE\u5F55)\s*$') {
                        $errors.Add("${relativeSkill}: long reference lacks a contents section: references/$($referenceFile.Name)")
                    }
                }
            }
        }
    }

    $assetsDirectory = Join-Path $directory.FullName 'assets'
    if (Test-Path -LiteralPath $assetsDirectory -PathType Container) {
        $assetCount += @(Get-ChildItem -LiteralPath $assetsDirectory -Recurse -File).Count
    }

    $scriptsDirectory = Join-Path $directory.FullName 'scripts'
    if (Test-Path -LiteralPath $scriptsDirectory -PathType Container) {
        $scriptCount += @(Get-ChildItem -LiteralPath $scriptsDirectory -Recurse -File).Count
    }

    foreach ($markdownFile in @(Get-ChildItem -LiteralPath $directory.FullName -Recurse -File -Filter '*.md')) {
        Test-MarkdownLinks -File $markdownFile
    }
}

$knownSkillFiles = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
foreach ($directory in $skillDirectories) {
    [void]$knownSkillFiles.Add((Join-Path $directory.FullName 'SKILL.md'))
}

foreach ($skillFile in @(Get-ChildItem -LiteralPath $skillsRoot -Recurse -File -Filter 'SKILL.md')) {
    if (-not $knownSkillFiles.Contains($skillFile.FullName)) {
        $errors.Add("$($skillFile.FullName): skill must be exactly one level below a scenario group")
    }
}

foreach ($instructionFile in @(
    Get-ChildItem -LiteralPath $skillsRoot -Recurse -File |
        Where-Object { $_.Extension -in @('.md', '.yaml', '.yml', '.sh', '.ps1') }
)) {
    $instructionContent = Get-Content -LiteralPath $instructionFile.FullName -Raw -Encoding UTF8
    $relativeFile = $instructionFile.FullName.Substring($repoRoot.Length + 1)

    foreach ($retiredName in $retiredSkillNames) {
        $pattern = '(?<![a-z0-9-])(?:\$|/)' + [regex]::Escape($retiredName) + '(?![a-z0-9-])'
        if ($instructionContent -match $pattern) {
            $errors.Add("${relativeFile}: references retired skill '$retiredName'")
        }
    }

    foreach ($activeName in $seenSkillNames) {
        $dollarCall = '$' + $activeName
        $slashPattern = '(?<![A-Za-z0-9._-])/' + [regex]::Escape($activeName) + '(?![a-z0-9-])'
        if ($instructionContent -match $slashPattern) {
            $errors.Add("${relativeFile}: uses slash-style invocation '/$activeName'; use '$dollarCall'")
        }
    }
}

if ($totalSkillLines -gt $maxTotalSkillLines) {
    $errors.Add("skills/: SKILL.md total is $totalSkillLines lines; maximum is $maxTotalSkillLines")
}

if ($totalSkillChars -gt $maxTotalSkillChars) {
    $errors.Add("skills/: SKILL.md total is $totalSkillChars characters; maximum is $maxTotalSkillChars")
}

if ($errors.Count -gt 0) {
    Write-Host "Skill validation failed with $($errors.Count) error(s):" -ForegroundColor Red
    $errors | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
    exit 1
}

Write-Host 'Skill validation passed.' -ForegroundColor Green
Write-Host "  Scenario groups:  $($groupDirectories.Count)"
Write-Host "  Skills:           $($skillDirectories.Count)"
Write-Host "  SKILL.md lines:   $totalSkillLines"
Write-Host "  SKILL.md chars:   $totalSkillChars"
Write-Host "  References:       $referenceCount"
Write-Host "  Assets:           $assetCount"
Write-Host "  Skill scripts:    $scriptCount"
