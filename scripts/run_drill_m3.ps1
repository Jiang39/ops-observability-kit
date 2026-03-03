param(
  [string]$RuntimeDir = ".runtime"
)

$ErrorActionPreference = "Stop"
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$evidenceDir = Join-Path (Join-Path $repoRoot $RuntimeDir) "evidence\\m3"
New-Item -ItemType Directory -Path $evidenceDir -Force | Out-Null

$logFile = Join-Path $evidenceDir "demo-service.log"
$errFile = Join-Path $evidenceDir "demo-service.err.log"
$summaryFile = Join-Path $evidenceDir "summary.json"
$traceId = "drill-m3-trace-001"

if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
  throw "python not found"
}

$svc = Start-Process -FilePath "python" -ArgumentList "$repoRoot\examples\demo-service\app.py" -RedirectStandardOutput $logFile -RedirectStandardError $errFile -PassThru
Start-Sleep -Seconds 1

try {
  Invoke-WebRequest -Uri "http://127.0.0.1:9101/ok" -Headers @{ "x-trace-id" = $traceId } -UseBasicParsing | Out-Null
  try {
    Invoke-WebRequest -Uri "http://127.0.0.1:9101/error" -Headers @{ "x-trace-id" = $traceId } -UseBasicParsing -ErrorAction Stop | Out-Null
  } catch {
    # Expected 500 response for drill.
  }
}
finally {
  Stop-Process -Id $svc.Id -Force -ErrorAction SilentlyContinue
}

$lines = Get-Content -Path $logFile -ErrorAction SilentlyContinue
$jsonLines = @()
foreach ($l in $lines) {
  try {
    $obj = $l | ConvertFrom-Json -ErrorAction Stop
    $jsonLines += $obj
  } catch {
  }
}

$matched = $jsonLines | Where-Object { $_.traceId -eq $traceId }
$summary = [pscustomobject]@{
  traceId = $traceId
  total_json_logs = $jsonLines.Count
  matched_trace_logs = $matched.Count
  has_error = [bool]($matched | Where-Object { $_.level -eq "error" })
  has_info = [bool]($matched | Where-Object { $_.level -eq "info" })
  generated_at = (Get-Date -Format "yyyy-MM-dd HH:mm:ss K")
}

$summary | ConvertTo-Json | Set-Content -Path $summaryFile -Encoding UTF8
$summary | Format-List
