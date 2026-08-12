[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$skillsRoot = Join-Path $repoRoot 'skills'
$errors = [System.Collections.Generic.List[string]]::new()

$maxSkillLines = 100
$maxTotalSkillLines = 500
$maxTotalSkillChars = 40500
$maxTotalResourceLines = 1900
$maxTotalResourceChars = 76000
$qualityGroupName = '07-quality-evaluation-release'
$maxQualitySkillLines = 135
$maxQualityResourceLines = 950
$maxSkillNameChars = 64
$maxDescriptionChars = 300
$allowedSkillDirectories = @('agents', 'assets', 'references', 'scripts')
$repositoryTextExtensions = @('.md', '.yaml', '.yml', '.sh', '.ps1', '.json', '.txt')
$retiredSkillNames = @(
    'ask-matt',
    'setup-matt-pocock-skills',
    'grill-me',
    'grill-with-docs',
    'grilling',
    'implement',
    'improve-codebase-architecture',
    'code-review',
    'handoff',
    'prototype',
    'review-codebase-architecture',
    'release-regression-gatekeeper',
    'research',
    'route-engineering-work',
    'run-learning-workspace',
    'teach',
    'test-process-governor',
    'test-tool-governor',
    'to-questionnaire',
    'to-spec',
    'to-tickets',
    'wayfinder',
    'wait-what',
    'wizard',
    'writing-for-agents'
)
$retiredSchemaPatterns = @('(?i)wayfinder:')

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

$totalSkillLines = 0
$totalSkillChars = 0
$totalResourceLines = 0
$totalResourceChars = 0
$referenceCount = 0
$assetCount = 0
$scriptCount = 0

foreach ($directory in $skillDirectories) {
    $relativeSkill = "$($directory.Parent.Name)/$($directory.Name)"

    if ($directory.Name -cnotmatch '^[a-z0-9]+(?:-[a-z0-9]+)*$') {
        $errors.Add("${relativeSkill}: skill directory name must use kebab-case")
    }
    elseif ($directory.Name.Length -gt $maxSkillNameChars) {
        $errors.Add("${relativeSkill}: skill name has $($directory.Name.Length) characters; maximum is $maxSkillNameChars")
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

    foreach ($resourceDirectoryName in @('references', 'assets', 'scripts')) {
        $resourceDirectory = Join-Path $directory.FullName $resourceDirectoryName
        if (-not (Test-Path -LiteralPath $resourceDirectory -PathType Container)) {
            continue
        }

        foreach ($resourceFile in @(Get-ChildItem -LiteralPath $resourceDirectory -Recurse -File)) {
            $relativeResource = $resourceFile.FullName.Substring($directory.FullName.Length + 1).Replace('\', '/')
            if (-not $content.Contains($relativeResource)) {
                $errors.Add("${relativeSkill}: resource is not directly routed from SKILL.md: $relativeResource")
            }

            if ($resourceFile.Extension -in $repositoryTextExtensions) {
                $resourceContent = Get-Content -LiteralPath $resourceFile.FullName -Raw -Encoding UTF8
                $totalResourceLines += @(Get-Content -LiteralPath $resourceFile.FullName -Encoding UTF8).Count
                $totalResourceChars += $resourceContent.Length
            }
        }
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
            if ($description -match '[<>]') {
                $errors.Add("${relativeSkill}: description cannot contain angle brackets")
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
            if ($referenceFile.BaseName -match '(?i)(?:^|-)templates?$') {
                $errors.Add("${relativeSkill}: pure output templates belong in assets/: references/$($referenceFile.Name)")
            }
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
        $scriptFiles = @(Get-ChildItem -LiteralPath $scriptsDirectory -Recurse -File)
        $scriptCount += $scriptFiles.Count
        foreach ($scriptFile in $scriptFiles) {
            if ($scriptFile.Extension -in @('.sh', '.ps1')) {
                $scriptContent = Get-Content -LiteralPath $scriptFile.FullName -Raw -Encoding UTF8
                if ($scriptContent -match '(?im)^\s*Read-Host\b' -or
                    $scriptContent -match '(?im)^\s*read\b[^\r\n]*\s-p(?:\s|$)') {
                    $errors.Add("${relativeSkill}: interactive scripts must be user-run artifacts, not skill scripts: scripts/$($scriptFile.Name)")
                }
            }
        }
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

    foreach ($retiredSchemaPattern in $retiredSchemaPatterns) {
        if ($instructionContent -match $retiredSchemaPattern) {
            $errors.Add("${relativeFile}: references retired tracker schema '$($Matches[0])'")
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

# Guard active repository guidance as well as skill-local instructions. Historical
# migration records intentionally retain old names, but current entry points must
# never advertise retired invocations.
$activeGuidanceFiles = @(
    (Join-Path $repoRoot 'README.md'),
    (Join-Path $repoRoot 'CONTRIBUTING.md'),
    (Join-Path $repoRoot 'docs\skills-distribution.md'),
    (Join-Path $repoRoot 'docs\development-orchestration-efficiency-spec.md')
)
foreach ($guidancePath in $activeGuidanceFiles) {
    if (-not (Test-Path -LiteralPath $guidancePath -PathType Leaf)) {
        continue
    }
    $guidanceContent = Get-Content -LiteralPath $guidancePath -Raw -Encoding UTF8
    $relativeGuidance = $guidancePath.Substring($repoRoot.Length + 1)
    foreach ($retiredName in $retiredSkillNames) {
        $pattern = '(?<![a-z0-9-])(?:\$|/)' + [regex]::Escape($retiredName) + '(?![a-z0-9-])'
        if ($guidanceContent -match $pattern) {
            $errors.Add("${relativeGuidance}: references retired skill '$retiredName'")
        }
    }

    foreach ($retiredSchemaPattern in $retiredSchemaPatterns) {
        if ($guidanceContent -match $retiredSchemaPattern) {
            $errors.Add("${relativeGuidance}: references retired tracker schema '$($Matches[0])'")
        }
    }

    foreach ($activeName in $seenSkillNames) {
        $dollarCall = '$' + $activeName
        $slashPattern = '(?<![A-Za-z0-9._-])/' + [regex]::Escape($activeName) + '(?![a-z0-9-])'
        if ($guidanceContent -match $slashPattern) {
            $errors.Add("${relativeGuidance}: uses slash-style invocation '/$activeName'; use '$dollarCall'")
        }
    }
}

# Validate every repository Markdown link, not only links bundled inside skills.
$repositoryMarkdownFiles = @(
    Get-ChildItem -LiteralPath $repoRoot -File -Filter '*.md'
    Get-ChildItem -LiteralPath (Join-Path $repoRoot 'docs') -Recurse -File -Filter '*.md'
) | Sort-Object FullName -Unique
foreach ($markdownFile in $repositoryMarkdownFiles) {
    Test-MarkdownLinks -File $markdownFile
}

# Reject undecodable text and final-tree whitespace even when the current Git diff
# does not expose the file (for example, on a shallow CI checkout).
$strictUtf8 = [System.Text.UTF8Encoding]::new($false, $true)
$repositoryTextFiles = @(
    Get-ChildItem -LiteralPath $repoRoot -Recurse -File |
        Where-Object {
            $_.FullName -notmatch '[\\/]\.git[\\/]' -and
            $_.FullName -notmatch '[\\/]tmp[\\/]' -and
            $_.Extension -in $repositoryTextExtensions
        }
)
foreach ($textFile in $repositoryTextFiles) {
    $relativeTextFile = $textFile.FullName.Substring($repoRoot.Length + 1)
    try {
        $decodedText = $strictUtf8.GetString([System.IO.File]::ReadAllBytes($textFile.FullName))
    }
    catch {
        $errors.Add("${relativeTextFile}: file is not strict UTF-8")
        continue
    }

    if ($decodedText -match '(?m)[\t ]+$') {
        $errors.Add("${relativeTextFile}: contains trailing whitespace")
    }
}

if ($totalSkillLines -gt $maxTotalSkillLines) {
    $errors.Add("skills/: SKILL.md total is $totalSkillLines lines; maximum is $maxTotalSkillLines")
}

if ($totalSkillChars -gt $maxTotalSkillChars) {
    $errors.Add("skills/: SKILL.md total is $totalSkillChars characters; maximum is $maxTotalSkillChars")
}

if ($totalResourceLines -gt $maxTotalResourceLines) {
    $errors.Add("skills/: text resources total $totalResourceLines lines; maximum is $maxTotalResourceLines")
}

if ($totalResourceChars -gt $maxTotalResourceChars) {
    $errors.Add("skills/: text resources total $totalResourceChars characters; maximum is $maxTotalResourceChars")
}

$qualityGroup = Join-Path $skillsRoot $qualityGroupName
$qualitySkillLines = 0
$qualityResourceLines = 0

if (Test-Path -LiteralPath $qualityGroup -PathType Container) {
    $qualitySkillFiles = @(Get-ChildItem -LiteralPath $qualityGroup -Recurse -File -Filter 'SKILL.md')
    $qualitySkillLines = (
        $qualitySkillFiles |
            ForEach-Object { @(Get-Content -LiteralPath $_.FullName -Encoding UTF8).Count } |
            Measure-Object -Sum
    ).Sum
    $qualityResourceFiles = @(
        Get-ChildItem -LiteralPath $qualityGroup -Recurse -File |
            Where-Object {
                $_.Name -cne 'SKILL.md' -and
        $_.FullName -notmatch '[\\/]agents[\\/]' -and
                $_.Extension -in $repositoryTextExtensions
            }
    )
    $qualityResourceLines = (
        $qualityResourceFiles |
            ForEach-Object { @(Get-Content -LiteralPath $_.FullName -Encoding UTF8).Count } |
            Measure-Object -Sum
    ).Sum
}

if ($qualitySkillLines -gt $maxQualitySkillLines) {
    $errors.Add("${qualityGroupName}: SKILL.md total is $qualitySkillLines lines; maximum is $maxQualitySkillLines")
}

if ($qualityResourceLines -gt $maxQualityResourceLines) {
    $errors.Add("${qualityGroupName}: text resources total $qualityResourceLines lines; maximum is $maxQualityResourceLines")
}

$efficiencySpecPath = Join-Path $repoRoot 'docs/development-orchestration-efficiency-spec.md'
$simplificationSpecPath = Join-Path $repoRoot 'docs/skill-simplification-v3-spec.md'
$distributionPath = Join-Path $repoRoot 'docs/skills-distribution.md'
$readmePath = Join-Path $repoRoot 'README.md'
if (-not (Test-Path -LiteralPath $efficiencySpecPath -PathType Leaf)) {
    $errors.Add('docs/: missing development-orchestration-efficiency-spec.md')
}
if (-not (Test-Path -LiteralPath $simplificationSpecPath -PathType Leaf)) {
    $errors.Add('docs/: missing skill-simplification-v3-spec.md')
}
if (-not (Test-Path -LiteralPath $readmePath -PathType Leaf)) {
    $errors.Add('repository: missing README.md')
}
else {
    $readmeContent = Get-Content -LiteralPath $readmePath -Raw -Encoding UTF8
    if ($readmeContent -notmatch '\(docs/development-orchestration-efficiency-spec\.md\)') {
        $errors.Add('README.md: missing development orchestration efficiency spec link')
    }
    if ($readmeContent -notmatch '\(docs/skill-simplification-v3-spec\.md\)') {
        $errors.Add('README.md: missing current skill simplification spec link')
    }

    $skillBadge = [regex]::Match($readmeContent, 'skills-(\d+)-')
    $scenarioBadge = [regex]::Match($readmeContent, 'scenarios-(\d+)-')
    $projectedSkillBadge = if ($skillBadge.Success) { [int]$skillBadge.Groups[1].Value } else { -1 }
    $projectedScenarioBadge = if ($scenarioBadge.Success) { [int]$scenarioBadge.Groups[1].Value } else { -1 }
    if ($projectedSkillBadge -ne $skillDirectories.Count) {
        $errors.Add("README.md: skills badge must match discovered count $($skillDirectories.Count)")
    }
    if ($projectedScenarioBadge -ne $groupDirectories.Count) {
        $errors.Add("README.md: scenarios badge must match discovered count $($groupDirectories.Count)")
    }

    foreach ($directory in $skillDirectories) {
        if (-not $readmeContent.Contains($directory.Name)) {
            $errors.Add("README.md: missing active skill '$($directory.Name)'")
        }
    }
}

if (-not (Test-Path -LiteralPath $distributionPath -PathType Leaf)) {
    $errors.Add('docs/: missing skills-distribution.md')
}
else {
    $distributionContent = Get-Content -LiteralPath $distributionPath -Raw -Encoding UTF8
    $distributionScenarioCount = [regex]::Match($distributionContent, '(?m)^\|\s*\u573A\u666F\u7EC4\s*\|\s*(\d+)\s*\|\s*$')
    $distributionSkillCount = [regex]::Match($distributionContent, '(?m)^\|\s*Skill \u76EE\u5F55 / `SKILL\.md`\s*\|\s*(\d+)\s*\|\s*$')
    $distributionAgentCount = [regex]::Match($distributionContent, '(?m)^\|\s*`agents/openai\.yaml`\s*\|\s*(\d+)\s*\|\s*$')

    $projectedScenarioCount = if ($distributionScenarioCount.Success) { [int]$distributionScenarioCount.Groups[1].Value } else { -1 }
    $projectedSkillCount = if ($distributionSkillCount.Success) { [int]$distributionSkillCount.Groups[1].Value } else { -1 }
    $projectedAgentCount = if ($distributionAgentCount.Success) { [int]$distributionAgentCount.Groups[1].Value } else { -1 }

    if ($projectedScenarioCount -ne $groupDirectories.Count) {
        $errors.Add("docs/skills-distribution.md: scenario count must match discovered count $($groupDirectories.Count)")
    }
    if ($projectedSkillCount -ne $skillDirectories.Count) {
        $errors.Add("docs/skills-distribution.md: skill count must match discovered count $($skillDirectories.Count)")
    }
    if ($projectedAgentCount -ne $skillDirectories.Count) {
        $errors.Add("docs/skills-distribution.md: agent metadata count must match discovered count $($skillDirectories.Count)")
    }

    $projectedSkillLinks = @(
        [regex]::Matches($distributionContent, '\.\./skills/[^/\s)]+/[^/\s)]+/SKILL\.md') |
            ForEach-Object { $_.Value }
    )
    if ($projectedSkillLinks.Count -ne $skillDirectories.Count) {
        $errors.Add("docs/skills-distribution.md: active skill link count must match discovered count $($skillDirectories.Count)")
    }

    foreach ($directory in $skillDirectories) {
        $expectedLink = "../skills/$($directory.Parent.Name)/$($directory.Name)/SKILL.md"
        $matchingLinks = @($projectedSkillLinks | Where-Object { $_ -ceq $expectedLink })
        if ($matchingLinks.Count -ne 1) {
            $errors.Add("docs/skills-distribution.md: expected exactly one active skill link '$expectedLink'")
        }
    }
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
Write-Host "  Text resources:   $totalResourceLines lines / $totalResourceChars chars"
Write-Host "  Quality SKILLs:   $qualitySkillLines lines"
Write-Host "  Quality resources: $qualityResourceLines lines"
Write-Host "  References:       $referenceCount"
Write-Host "  Assets:           $assetCount"
Write-Host "  Skill scripts:    $scriptCount"
