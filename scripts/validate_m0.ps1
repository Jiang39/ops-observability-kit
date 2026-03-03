param(
  [string]$RuntimeDir = ".runtime"
)

$ErrorActionPreference = "Stop"
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$runtimePath = Join-Path $repoRoot $RuntimeDir
$pidFile = Join-Path $runtimePath "pids.json"
$envFile = Join-Path $repoRoot ".env"

$checks = @()

function Add-Check {
  param(
    [string]$Name,
    [string]$Status,
    [string]$Detail
  )
  $script:checks += [pscustomobject]@{
    Check = $Name
    Status = $Status
    Detail = $Detail
  }
}

function Import-DotEnv {
  param([string]$Path)
  if (-not (Test-Path $Path)) {
    return
  }

  foreach ($line in Get-Content -Path $Path) {
    $trimmed = $line.Trim()
    if (-not $trimmed -or $trimmed.StartsWith("#")) {
      continue
    }
    $idx = $trimmed.IndexOf("=")
    if ($idx -lt 1) {
      continue
    }
    $name = $trimmed.Substring(0, $idx).Trim()
    $value = $trimmed.Substring($idx + 1).Trim()
    [Environment]::SetEnvironmentVariable($name, $value, "Process")
  }
}

Import-DotEnv -Path $envFile

function Get-EnvInt {
  param(
    [string]$Name,
    [int]$Default
  )

  $value = [Environment]::GetEnvironmentVariable($Name)
  if ([string]::IsNullOrWhiteSpace($value)) {
    return $Default
  }

  $parsed = 0
  if ([int]::TryParse($value, [ref]$parsed)) {
    return $parsed
  }

  return $Default
}

# 1) Required files
$requiredFiles = @(
  "configs/loki/loki-config.yaml",
  "configs/promtail/promtail-config.yaml",
  "configs/prometheus/prometheus.yml",
  "configs/tempo/tempo.yaml",
  "configs/otel/collector.yaml",
  "configs/grafana/provisioning/datasources/datasources.yaml",
  "configs/alertmanager/alertmanager.yml",
  "scripts/start_local_stack.ps1",
  "scripts/stop_local_stack.ps1",
  "README.md"
)

foreach ($rel in $requiredFiles) {
  $abs = Join-Path $repoRoot $rel
  if (Test-Path $abs) {
    Add-Check -Name "file:$rel" -Status "PASS" -Detail "exists"
  } else {
    Add-Check -Name "file:$rel" -Status "FAIL" -Detail "missing"
  }
}

# 2) Port availability
$ports = @(
  (Get-EnvInt -Name "GRAFANA_PORT" -Default 3000),
  (Get-EnvInt -Name "LOKI_PORT" -Default 3100),
  (Get-EnvInt -Name "TEMPO_HTTP_PORT" -Default 3200),
  (Get-EnvInt -Name "OTEL_GRPC_PORT" -Default 4317),
  (Get-EnvInt -Name "OTEL_HTTP_PORT" -Default 4318),
  (Get-EnvInt -Name "PROMETHEUS_PORT" -Default 9090),
  (Get-EnvInt -Name "ALERTMANAGER_PORT" -Default 9093)
) | Select-Object -Unique
foreach ($p in $ports) {
  $listeners = Get-NetTCPConnection -State Listen -LocalPort $p -ErrorAction SilentlyContinue
  if ($listeners) {
    Add-Check -Name "port:$p" -Status "INFO" -Detail "in use by pid(s): $((($listeners | Select-Object -ExpandProperty OwningProcess -Unique) -join ','))"
  } else {
    Add-Check -Name "port:$p" -Status "PASS" -Detail "free"
  }
}

# 3) Process manifest + health checks
if (Test-Path $pidFile) {
  $entries = Get-Content -Raw -Path $pidFile | ConvertFrom-Json
  foreach ($e in $entries) {
    if (-not $e.pid) {
      Add-Check -Name "proc:$($e.name)" -Status "WARN" -Detail $e.note
      continue
    }

    $p = Get-Process -Id $e.pid -ErrorAction SilentlyContinue
    if ($p) {
      Add-Check -Name "proc:$($e.name)" -Status "PASS" -Detail "running pid=$($e.pid)"
    } else {
      Add-Check -Name "proc:$($e.name)" -Status "FAIL" -Detail "not running pid=$($e.pid)"
    }

    if ($e.healthUrl) {
      try {
        $resp = Invoke-WebRequest -Uri $e.healthUrl -UseBasicParsing -TimeoutSec 2
        Add-Check -Name "health:$($e.name)" -Status "PASS" -Detail "http $($resp.StatusCode)"
      } catch {
        Add-Check -Name "health:$($e.name)" -Status "WARN" -Detail "unreachable: $($e.healthUrl)"
      }
    }
  }
} else {
  Add-Check -Name "runtime:manifest" -Status "WARN" -Detail "missing $pidFile (start script may not have run)"
}

$checks | Format-Table -AutoSize

$failCount = ($checks | Where-Object { $_.Status -eq "FAIL" }).Count
if ($failCount -gt 0) {
  Write-Host ""
  Write-Host "M0 validation result: FAIL ($failCount hard failures)"
  exit 1
}

Write-Host ""
Write-Host "M0 validation result: PASS (no hard failures; WARN/INFO may remain)"
