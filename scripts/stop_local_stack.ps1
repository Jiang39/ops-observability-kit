param(
  [string]$RuntimeDir = ".runtime"
)

$ErrorActionPreference = "Stop"
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$pidFile = Join-Path (Join-Path $repoRoot $RuntimeDir) "pids.json"

if (-not (Test-Path $pidFile)) {
  Write-Host "No runtime manifest found at $pidFile"
  exit 0
}

$entries = Get-Content -Raw -Path $pidFile | ConvertFrom-Json
foreach ($e in $entries) {
  if (-not $e.pid) {
    continue
  }

  $proc = Get-Process -Id $e.pid -ErrorAction SilentlyContinue
  if (-not $proc) {
    Write-Host "[$($e.name)] already stopped (pid=$($e.pid))"
    continue
  }

  try {
    Stop-Process -Id $e.pid -Force -ErrorAction Stop
    Write-Host "[$($e.name)] stopped (pid=$($e.pid))"
  } catch {
    Write-Host "[$($e.name)] failed to stop (pid=$($e.pid)): $($_.Exception.Message)"
  }
}
