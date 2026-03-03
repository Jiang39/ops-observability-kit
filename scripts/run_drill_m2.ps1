param(
  [string]$RuntimeDir = ".runtime"
)

$ErrorActionPreference = "Stop"
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$evidenceDir = Join-Path (Join-Path $repoRoot $RuntimeDir) "evidence\\m2"
New-Item -ItemType Directory -Path $evidenceDir -Force | Out-Null

$alertsFile = Join-Path $repoRoot "configs\prometheus\alerts.yml"
$amFile = Join-Path $repoRoot "configs\alertmanager\alertmanager.yml"
$summaryFile = Join-Path $evidenceDir "summary.json"

$requiredAlerts = @("High5xxRatio", "HighP95Latency", "InstanceDown")
$missing = @()
foreach ($a in $requiredAlerts) {
  if (-not (Select-String -Path $alertsFile -Pattern $a -SimpleMatch -Quiet)) {
    $missing += $a
  }
}

$hasRoute = Select-String -Path $amFile -Pattern "route:" -SimpleMatch -Quiet
$hasReceiver = Select-String -Path $amFile -Pattern "receivers:" -SimpleMatch -Quiet
$promtool = Get-Command promtool -ErrorAction SilentlyContinue

$summary = [pscustomobject]@{
  alerts_file_exists = (Test-Path $alertsFile)
  alertmanager_file_exists = (Test-Path $amFile)
  required_alerts_present = ($missing.Count -eq 0)
  missing_alerts = ($missing -join ",")
  alertmanager_route_present = $hasRoute
  alertmanager_receivers_present = $hasReceiver
  promtool_available = [bool]$promtool
  generated_at = (Get-Date -Format "yyyy-MM-dd HH:mm:ss K")
}

$summary | ConvertTo-Json | Set-Content -Path $summaryFile -Encoding UTF8
$summary | Format-List
