# claude-timer.ps1 - tracks how long Claude works on each request.
#
#   start   (UserPromptSubmit hook) - you sent a message: start the clock
#   stop    (Stop / StopFailure hook) - Claude finished: stop the clock, log one row
#   report  (run by hand)            - totals per project
#
# Log:   ~/.claude/timer/time-log.csv
# State: ~/.claude/timer/state/<session_id>.json  (one open timer per session)
#
# The hook modes never fail loudly: any error is written to timer/errors.log and
# the script exits 0, so the timer can never block or break a Claude session.

param(
    [Parameter(Position = 0)][string]$Action = 'report',
    [Parameter(Position = 1)][int]$Days = 7,
    [string]$Project = ''
)

$ErrorActionPreference = 'Stop'
$Root     = Join-Path $env:USERPROFILE '.claude\timer'
$StateDir = Join-Path $Root 'state'
$LogFile  = Join-Path $Root 'time-log.csv'
$ErrFile  = Join-Path $Root 'errors.log'
$Header   = 'Date,Project,Folder,Session,Started,Ended,Seconds,Duration,Status,Prompt'

function Read-HookInput {
    [Console]::InputEncoding = [Text.Encoding]::UTF8
    $raw = [Console]::In.ReadToEnd()
    if ([string]::IsNullOrWhiteSpace($raw)) { return $null }
    return $raw | ConvertFrom-Json
}

function Csv([string]$s) { '"' + ($s -replace '"', '""') + '"' }

function Format-Duration([double]$sec) {
    $t = [TimeSpan]::FromSeconds([math]::Round($sec))
    if ($t.TotalHours -ge 1) { return '{0}h {1:D2}m' -f [int][math]::Floor($t.TotalHours), $t.Minutes }
    if ($t.TotalMinutes -ge 1) { return '{0}m {1:D2}s' -f $t.Minutes, $t.Seconds }
    return '{0}s' -f $t.Seconds
}

function Write-Row($state, [datetime]$ended, [string]$status) {
    $started = [datetime]::Parse($state.started, $null, [Globalization.DateTimeStyles]::RoundtripKind)
    if ($ended -lt $started) { $ended = $started }
    $sec = [math]::Round(($ended - $started).TotalSeconds, 1)
    if (-not (Test-Path $LogFile)) { Set-Content -Path $LogFile -Value $Header -Encoding UTF8 }
    $row = @(
        $started.ToString('yyyy-MM-dd'),
        (Csv $state.project),
        (Csv $state.cwd),
        $state.session,
        $started.ToString('yyyy-MM-dd HH:mm:ss'),
        $ended.ToString('yyyy-MM-dd HH:mm:ss'),
        $sec,
        (Format-Duration $sec),
        $status,
        (Csv $state.prompt)
    ) -join ','
    Add-Content -Path $LogFile -Value $row -Encoding UTF8
}

function Start-Timer {
    $in = Read-HookInput
    if (-not $in -or -not $in.session_id) { return }
    New-Item -ItemType Directory -Force -Path $StateDir | Out-Null
    $stateFile = Join-Path $StateDir ($in.session_id + '.json')

    # A timer still open here means the last turn never reached Stop (you pressed
    # Esc / stop). Close it at the transcript's last write, which is when Claude
    # last did anything, so the idle gap before this message isn't counted.
    if (Test-Path $stateFile) {
        $old = Get-Content $stateFile -Raw -Encoding UTF8 | ConvertFrom-Json
        $end = Get-Date
        if ($in.transcript_path -and (Test-Path $in.transcript_path)) {
            $end = (Get-Item $in.transcript_path).LastWriteTime
        }
        Write-Row $old $end 'interrupted'
    }

    $prompt = ([string]$in.prompt) -replace '\s+', ' '
    if ($prompt.Length -gt 100) { $prompt = $prompt.Substring(0, 100) + '...' }
    $cwd = [string]$in.cwd
    $state = [ordered]@{
        session = $in.session_id
        started = (Get-Date).ToString('o')
        cwd     = $cwd
        project = if ($cwd) { Split-Path $cwd -Leaf } else { '' }
        prompt  = $prompt.Trim()
    }
    $state | ConvertTo-Json | Set-Content -Path $stateFile -Encoding UTF8
}

function Stop-Timer([string]$status) {
    $in = Read-HookInput
    if (-not $in -or -not $in.session_id) { return }
    $stateFile = Join-Path $StateDir ($in.session_id + '.json')
    if (-not (Test-Path $stateFile)) { return }   # no open timer (e.g. a background wake-up)
    $state = Get-Content $stateFile -Raw -Encoding UTF8 | ConvertFrom-Json
    Write-Row $state (Get-Date) $status
    Remove-Item $stateFile -Force
}

function Show-Report {
    if (-not (Test-Path $LogFile)) { Write-Output 'No time logged yet.'; return }
    if ($Days -lt 1) { $Days = 1 }
    $since = (Get-Date).Date.AddDays(-($Days - 1))
    $rows = Import-Csv $LogFile | Where-Object { [datetime]$_.Started -ge $since }
    if ($Project) { $rows = $rows | Where-Object { $_.Project -like "*$Project*" } }
    if (-not $rows) { Write-Output "Nothing logged in the last $Days day(s)."; return }

    $label = if ($Days -eq 1) { 'today' } else { "last $Days days (since $($since.ToString('yyyy-MM-dd')))" }
    Write-Output "Claude working time, $label"
    Write-Output ''
    $rows | Group-Object Project | ForEach-Object {
        $sum = ($_.Group | Measure-Object -Property Seconds -Sum).Sum
        [pscustomobject]@{ Project = $_.Name; Requests = $_.Count; Seconds = $sum; Time = (Format-Duration $sum) }
    } | Sort-Object Seconds -Descending | Format-Table Project, Requests, Time -AutoSize | Out-String -Width 200 | ForEach-Object { $_.Trim() } | Write-Output
    Write-Output ''
    $total = ($rows | Measure-Object -Property Seconds -Sum).Sum
    Write-Output ("Total: {0} across {1} request(s)" -f (Format-Duration $total), @($rows).Count)
    Write-Output "Log: $LogFile"
}

try {
    New-Item -ItemType Directory -Force -Path $Root | Out-Null
    switch ($Action.ToLower()) {
        'start'   { Start-Timer }
        'stop'    { Stop-Timer 'done' }
        'failed'  { Stop-Timer 'api-error' }
        'report'  { Show-Report }
        default   { Write-Output 'Usage: claude-timer.ps1 [start|stop|failed|report] [-Days N] [-Project name]' }
    }
} catch {
    if ($Action -in 'start', 'stop', 'failed') {
        Add-Content -Path $ErrFile -Value ("{0} [{1}] {2}" -f (Get-Date -Format s), $Action, $_.Exception.Message)
        exit 0
    }
    throw
}
exit 0
