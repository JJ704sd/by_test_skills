[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$utf8NoBom = [System.Text.UTF8Encoding]::new($false)
$hostExecutable = (Get-Process -Id $PID).Path
$failures = [System.Collections.Generic.List[string]]::new()

function Read-Utf8 {
    param([Parameter(Mandatory)][string]$Path)

    return [System.IO.File]::ReadAllText($Path, [System.Text.Encoding]::UTF8)
}

function Write-Utf8 {
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][string]$Content
    )

    [System.IO.File]::WriteAllText($Path, $Content, $utf8NoBom)
}

function Replace-Utf8 {
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][string]$Old,
        [Parameter(Mandatory)][string]$New
    )

    $content = Read-Utf8 -Path $Path
    if (-not $content.Contains($Old)) {
        throw "Mutation anchor not found in $Path"
    }
    Write-Utf8 -Path $Path -Content $content.Replace($Old, $New)
}

$mutations = @(
    @{
        Name = 'frontmatter-name'
        Apply = {
            param($root)
            Replace-Utf8 -Path (Join-Path $root 'skills/02-domain-modeling/domain-modeling/SKILL.md') -Old 'name: domain-modeling' -New 'name: wrong-name'
        }
    },
    @{
        Name = 'agent-field'
        Apply = {
            param($root)
            $path = Join-Path $root 'skills/02-domain-modeling/domain-modeling/agents/openai.yaml'
            $content = Read-Utf8 -Path $path
            Write-Utf8 -Path $path -Content ([regex]::Replace($content, '(?m)^  default_prompt:.*\r?\n?', ''))
        }
    },
    @{
        Name = 'orphan-resource'
        Apply = {
            param($root)
            $path = Join-Path $root 'skills/02-domain-modeling/domain-modeling/assets/orphan.md'
            [void](New-Item -ItemType Directory -Path (Split-Path -Parent $path) -Force)
            Write-Utf8 -Path $path -Content "# Orphan`n"
        }
    },
    @{
        Name = 'active-doc-link'
        Apply = {
            param($root)
            $path = Join-Path $root 'README.md'
            Write-Utf8 -Path $path -Content ((Read-Utf8 -Path $path) + "`n[broken](docs/does-not-exist.md)`n")
        }
    },
    @{
        Name = 'retired-invocation'
        Apply = {
            param($root)
            $path = Join-Path $root 'README.md'
            Write-Utf8 -Path $path -Content ((Read-Utf8 -Path $path) + "`nUse `$route-engineering-work.`n")
        }
    },
    @{
        Name = 'slash-invocation'
        Apply = {
            param($root)
            $path = Join-Path $root 'README.md'
            Write-Utf8 -Path $path -Content ((Read-Utf8 -Path $path) + "`nUse /domain-modeling.`n")
        }
    },
    @{
        Name = 'retired-tracker-schema'
        Apply = {
            param($root)
            $path = Join-Path $root 'README.md'
            Write-Utf8 -Path $path -Content ((Read-Utf8 -Path $path) + "`nLegacy tracker schema: wayfinder:map.`n")
        }
    },
    @{
        Name = 'context-budget'
        Apply = {
            param($root)
            $path = Join-Path $root 'skills/02-domain-modeling/domain-modeling/SKILL.md'
            Write-Utf8 -Path $path -Content ((Read-Utf8 -Path $path) + "`n" + ('x' * 41000) + "`n")
        }
    },
    @{
        Name = 'inventory-projection'
        Apply = {
            param($root)
            Replace-Utf8 -Path (Join-Path $root 'README.md') -Old 'skills-16-' -New 'skills-99-'
        }
    },
    @{
        Name = 'invalid-utf8'
        Apply = {
            param($root)
            [System.IO.File]::WriteAllBytes((Join-Path $root 'CONTRIBUTING.md'), [byte[]](0xC3, 0x28))
        }
    },
    @{
        Name = 'trailing-whitespace'
        Apply = {
            param($root)
            $path = Join-Path $root 'README.md'
            Write-Utf8 -Path $path -Content ((Read-Utf8 -Path $path) + "`ntrailing-space `n")
        }
    },
    @{
        Name = 'interactive-script'
        Apply = {
            param($root)
            $skillRoot = Join-Path $root 'skills/02-domain-modeling/domain-modeling'
            $scriptPath = Join-Path $skillRoot 'scripts/interactive.sh'
            [void](New-Item -ItemType Directory -Path (Split-Path -Parent $scriptPath) -Force)
            Write-Utf8 -Path $scriptPath -Content "#!/usr/bin/env bash`nread -r -p `"Continue? `" answer`n"
            $skillPath = Join-Path $skillRoot 'SKILL.md'
            Write-Utf8 -Path $skillPath -Content ((Read-Utf8 -Path $skillPath) + "`nUse scripts/interactive.sh.`n")
        }
    }
)

$tempBase = [System.IO.Path]::GetFullPath([System.IO.Path]::GetTempPath())

foreach ($mutation in $mutations) {
    $caseRoot = Join-Path $tempBase ("by-test-skills-validator-{0}-{1}" -f $mutation.Name, [guid]::NewGuid().ToString('N'))
    $resolvedCaseRoot = [System.IO.Path]::GetFullPath($caseRoot)
    if (-not $resolvedCaseRoot.StartsWith($tempBase, [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "Refusing to create mutation case outside the temporary directory: $resolvedCaseRoot"
    }

    try {
        [void](New-Item -ItemType Directory -Path $resolvedCaseRoot)
        Copy-Item -LiteralPath (Join-Path $repoRoot 'skills') -Destination $resolvedCaseRoot -Recurse
        Copy-Item -LiteralPath (Join-Path $repoRoot 'docs') -Destination $resolvedCaseRoot -Recurse
        Copy-Item -LiteralPath (Join-Path $repoRoot 'README.md') -Destination $resolvedCaseRoot
        Copy-Item -LiteralPath (Join-Path $repoRoot 'CONTRIBUTING.md') -Destination $resolvedCaseRoot
        [void](New-Item -ItemType Directory -Path (Join-Path $resolvedCaseRoot 'scripts'))
        Copy-Item -LiteralPath (Join-Path $repoRoot 'scripts/Test-Skills.ps1') -Destination (Join-Path $resolvedCaseRoot 'scripts/Test-Skills.ps1')

        & $mutation.Apply $resolvedCaseRoot

        $validator = Join-Path $resolvedCaseRoot 'scripts/Test-Skills.ps1'
        $output = & $hostExecutable -NoProfile -ExecutionPolicy Bypass -File $validator 2>&1
        if ($LASTEXITCODE -eq 0) {
            $failures.Add("$($mutation.Name): validator unexpectedly passed")
        }
        else {
            Write-Host "Mutation rejected: $($mutation.Name)" -ForegroundColor Green
        }
    }
    finally {
        if (Test-Path -LiteralPath $resolvedCaseRoot) {
            $verifiedRoot = [System.IO.Path]::GetFullPath($resolvedCaseRoot)
            if (-not $verifiedRoot.StartsWith($tempBase, [System.StringComparison]::OrdinalIgnoreCase) -or
                -not (Split-Path -Leaf $verifiedRoot).StartsWith('by-test-skills-validator-')) {
                throw "Refusing to remove unverified mutation directory: $verifiedRoot"
            }
            Remove-Item -LiteralPath $verifiedRoot -Recurse -Force
        }
    }
}

if ($failures.Count -gt 0) {
    Write-Host "Validator mutation tests failed with $($failures.Count) error(s):" -ForegroundColor Red
    $failures | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
    exit 1
}

Write-Host "Validator mutation tests passed ($($mutations.Count) cases)." -ForegroundColor Green
exit 0
