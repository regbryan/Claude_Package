# install.ps1 - installs this Claude Code setup on a Windows PC.
#
# Run from the folder you cloned or unzipped:
#     powershell -ExecutionPolicy Bypass -File .\install.ps1
#
# What it does:
#   1. Copies skills, agents and the /app-review command into ~/.claude
#   2. Installs the rules file (CLAUDE.md) if you don't already have one
#   3. Turns on the plugins and their marketplaces in ~/.claude/settings.json
#   4. Optionally creates one folder per project under Documents
#   5. Optionally installs the work timer
#
# It never deletes anything. Things that already exist are left alone unless
# you pass -Force, and settings.json is backed up before it is changed.
#
# Options:
#   -Projects "Client A","Client B"   create these project folders
#   -ProjectsRoot <path>              where to create them (default: Documents)
#   -Timer                            install the work timer hook
#   -Force                            replace skills/agents/commands that already exist
#   -ClaudeHome <path>                install somewhere other than ~/.claude (for testing)

param(
    [string[]]$Projects = @(),
    [string]$ProjectsRoot = [Environment]::GetFolderPath('MyDocuments'),
    [switch]$Timer,
    [switch]$Force,
    [string]$ClaudeHome = (Join-Path $env:USERPROFILE '.claude')
)

$ErrorActionPreference = 'Stop'
$Pkg = Join-Path $PSScriptRoot 'package'
if (-not (Test-Path $Pkg)) { throw "Cannot find the 'package' folder next to install.ps1." }

function Say([string]$msg) { Write-Host $msg }
function Write-Utf8([string]$path, [string]$text) {
    [IO.File]::WriteAllText($path, $text, (New-Object Text.UTF8Encoding($false)))
}
function Set-Prop($obj, [string]$name, $value) {
    if ($obj.PSObject.Properties[$name]) { $obj.$name = $value }
    else { $obj | Add-Member -NotePropertyName $name -NotePropertyValue $value }
}

New-Item -ItemType Directory -Force $ClaudeHome | Out-Null
Say "Installing into $ClaudeHome"
Say ''

# --- 1. Skills (one folder each) -------------------------------------------
$skillsDst = Join-Path $ClaudeHome 'skills'
New-Item -ItemType Directory -Force $skillsDst | Out-Null
$added = 0; $kept = 0
foreach ($s in Get-ChildItem (Join-Path $Pkg 'skills') -Directory) {
    $dst = Join-Path $skillsDst $s.Name
    if (Test-Path $dst) {
        if (-not $Force) { $kept++; continue }
        Remove-Item -Recurse -Force $dst -Confirm:$false
    }
    Copy-Item -Recurse $s.FullName $dst
    $added++
}
Say "Skills:    $added installed, $kept already there (left alone)"

# --- 2. Agents and commands (file by file) ---------------------------------
function Copy-Tree([string]$name) {
    $src = Join-Path $Pkg $name
    $dstRoot = Join-Path $ClaudeHome $name
    $a = 0; $k = 0
    foreach ($f in Get-ChildItem $src -Recurse -File) {
        $rel = $f.FullName.Substring($src.Length).TrimStart('\')
        $dst = Join-Path $dstRoot $rel
        if ((Test-Path $dst) -and -not $Force) { $k++; continue }
        New-Item -ItemType Directory -Force (Split-Path $dst) | Out-Null
        Copy-Item $f.FullName $dst -Force
        $a++
    }
    return @($a, $k)
}
$r = Copy-Tree 'agents';   Say "Agents:    $($r[0]) installed, $($r[1]) already there (left alone)"
$r = Copy-Tree 'commands'; Say "Commands:  $($r[0]) installed, $($r[1]) already there (left alone)"

# --- 3. Rules file ----------------------------------------------------------
$rulesDst = Join-Path $ClaudeHome 'CLAUDE.md'
if (Test-Path $rulesDst) {
    $alt = Join-Path $ClaudeHome 'CLAUDE.from-package.md'
    Copy-Item (Join-Path $Pkg 'CLAUDE.md') $alt -Force
    Say "Rules:     you already have a CLAUDE.md, so it was left alone."
    Say "           The packaged one is saved beside it as CLAUDE.from-package.md."
} else {
    Copy-Item (Join-Path $Pkg 'CLAUDE.md') $rulesDst
    Say "Rules:     CLAUDE.md installed"
}

# --- 4. Plugins and marketplaces (settings.json) ----------------------------
$settingsPath = Join-Path $ClaudeHome 'settings.json'
$settings = New-Object PSObject
if (Test-Path $settingsPath) {
    $raw = Get-Content $settingsPath -Raw
    if (-not [string]::IsNullOrWhiteSpace($raw)) { $settings = $raw | ConvertFrom-Json }
    $backup = "$settingsPath.backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    Copy-Item $settingsPath $backup
    Say "Settings:  existing settings.json backed up to $(Split-Path $backup -Leaf)"
}
$want = Get-Content (Join-Path $Pkg 'plugins.json') -Raw | ConvertFrom-Json
$pluginsAdded = 0
foreach ($section in 'enabledPlugins', 'extraKnownMarketplaces') {
    if (-not $settings.PSObject.Properties[$section]) { Set-Prop $settings $section (New-Object PSObject) }
    foreach ($p in $want.$section.PSObject.Properties) {
        # Never override a choice already made on this PC (for example a plugin turned off).
        if (-not $settings.$section.PSObject.Properties[$p.Name]) {
            Set-Prop $settings.$section $p.Name $p.Value
            if ($section -eq 'enabledPlugins') { $pluginsAdded++ }
        }
    }
}
Say "Plugins:   $pluginsAdded turned on ($(@($want.enabledPlugins.PSObject.Properties).Count) in the package)"

# --- 5. Work timer (optional) -----------------------------------------------
if ($Timer) {
    $hooksDst = Join-Path $ClaudeHome 'hooks'
    New-Item -ItemType Directory -Force $hooksDst | Out-Null
    $timerPath = Join-Path $hooksDst 'claude-timer.ps1'
    Copy-Item (Join-Path $Pkg 'hooks\claude-timer.ps1') $timerPath -Force
    if (-not $settings.PSObject.Properties['hooks']) { Set-Prop $settings 'hooks' (New-Object PSObject) }
    $events = @{ UserPromptSubmit = 'start'; Stop = 'stop'; StopFailure = 'failed' }
    foreach ($ev in $events.Keys) {
        $existing = @()
        if ($settings.hooks.PSObject.Properties[$ev]) { $existing = @($settings.hooks.$ev) }
        if (($existing | ConvertTo-Json -Depth 10 -Compress) -match 'claude-timer') { continue }
        $cmd = 'powershell -NoProfile -ExecutionPolicy Bypass -File "' + $timerPath + '" ' + $events[$ev]
        $entry = [pscustomobject]@{ hooks = @([pscustomobject]@{ type = 'command'; command = $cmd; timeout = 10 }) }
        Set-Prop $settings.hooks $ev @($existing + $entry)
    }
    Say "Timer:     installed (log: $ClaudeHome\timer\time-log.csv)"
}

Write-Utf8 $settingsPath ($settings | ConvertTo-Json -Depth 20)

# --- 6. Project folders (optional) ------------------------------------------
# "powershell -File" passes "A","B" as one string, so split on commas too.
$Projects = @($Projects | ForEach-Object { $_ -split ',' } | ForEach-Object { $_.Trim() } | Where-Object { $_ })
if ($Projects.Count -gt 0) {
    foreach ($p in $Projects) {
        $dir = Join-Path $ProjectsRoot $p
        if (Test-Path $dir) { Say "Project:   $dir already exists" }
        else { New-Item -ItemType Directory -Force $dir | Out-Null; Say "Project:   created $dir" }
    }
}

Say ''
Say 'Done. Next:'
Say '  1. Close Claude completely and open it again.'
Say '  2. If it asks whether to trust or install the plugin marketplaces, say yes.'
Say '  3. Sign in to each connector you use (Google, HubSpot and so on). Those cannot be copied.'
