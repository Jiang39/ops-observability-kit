param(
  [string]$RuntimeDir = ".runtime"
)

$ErrorActionPreference = "Stop"
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path

Write-Host "[1/3] Running M1 offline drill..."
powershell -ExecutionPolicy Bypass -File (Join-Path $PSScriptRoot "run_drill_m1.ps1") -RuntimeDir $RuntimeDir

Write-Host "[2/3] Running M2 offline drill..."
powershell -ExecutionPolicy Bypass -File (Join-Path $PSScriptRoot "run_drill_m2.ps1") -RuntimeDir $RuntimeDir

Write-Host "[3/3] Running M3 offline drill..."
powershell -ExecutionPolicy Bypass -File (Join-Path $PSScriptRoot "run_drill_m3.ps1") -RuntimeDir $RuntimeDir

$m1 = Join-Path $repoRoot "$RuntimeDir\evidence\m1\summary.json"
$m2 = Join-Path $repoRoot "$RuntimeDir\evidence\m2\summary.json"
$m3 = Join-Path $repoRoot "$RuntimeDir\evidence\m3\summary.json"

Write-Host ""
Write-Host "Offline drill evidence:"
Write-Host " - $m1"
Write-Host " - $m2"
Write-Host " - $m3"
