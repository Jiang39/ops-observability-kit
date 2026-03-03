param(
  [string]$RuntimeDir = ".runtime"
)

$ErrorActionPreference = "Stop"
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$runtimePath = Join-Path $repoRoot $RuntimeDir
$logPath = Join-Path $runtimePath "logs"
$pidFile = Join-Path $runtimePath "pids.json"
$envFile = Join-Path $repoRoot ".env"

New-Item -ItemType Directory -Path $logPath -Force | Out-Null

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

function Resolve-Binary {
  param(
    [string]$EnvName,
    [string[]]$Candidates
  )

  $fromEnv = [Environment]::GetEnvironmentVariable($EnvName)
  if ($fromEnv -and (Test-Path $fromEnv)) {
    return (Resolve-Path $fromEnv).Path
  }

  foreach ($c in $Candidates) {
    $cmd = Get-Command $c -ErrorAction SilentlyContinue
    if ($cmd) {
      return $cmd.Source
    }
  }

  return $null
}

$components = @(
  @{
    Name = "loki"
    Env = "LOKI_BIN"
    Candidates = @("loki", "loki.exe")
    Args = @("-config.file=$repoRoot\configs\loki\loki-config.yaml")
    Url = "http://127.0.0.1:3100/ready"
  },
  @{
    Name = "promtail"
    Env = "PROMTAIL_BIN"
    Candidates = @("promtail", "promtail.exe")
    Args = @("-config.file=$repoRoot\configs\promtail\promtail-config.yaml")
    Url = ""
  },
  @{
    Name = "prometheus"
    Env = "PROMETHEUS_BIN"
    Candidates = @("prometheus", "prometheus.exe")
    Args = @("--config.file=$repoRoot\configs\prometheus\prometheus.yml", "--web.enable-lifecycle")
    Url = "http://127.0.0.1:9090/-/ready"
  },
  @{
    Name = "tempo"
    Env = "TEMPO_BIN"
    Candidates = @("tempo", "tempo.exe")
    Args = @("-config.file=$repoRoot\configs\tempo\tempo.yaml")
    Url = "http://127.0.0.1:3200/ready"
  },
  @{
    Name = "otel-collector"
    Env = "OTEL_BIN"
    Candidates = @("otelcol-contrib", "otelcol-contrib.exe")
    Args = @("--config=$repoRoot\configs\otel\collector.yaml")
    Url = "http://127.0.0.1:13133/"
  },
  @{
    Name = "alertmanager"
    Env = "ALERTMANAGER_BIN"
    Candidates = @("alertmanager", "alertmanager.exe")
    Args = @("--config.file=$repoRoot\configs\alertmanager\alertmanager.yml")
    Url = "http://127.0.0.1:9093/-/ready"
  },
  @{
    Name = "grafana"
    Env = "GRAFANA_BIN"
    Candidates = @("grafana-server", "grafana-server.exe")
    Args = @()
    Url = "http://127.0.0.1:3000/api/health"
  }
)

$results = @()
foreach ($c in $components) {
  $bin = Resolve-Binary -EnvName $c.Env -Candidates $c.Candidates
  if (-not $bin) {
    $results += [pscustomobject]@{
      name = $c.Name
      status = "SKIPPED"
      pid = $null
      binary = ""
      note = "binary not found (set $($c.Env) or install command)"
      healthUrl = $c.Url
    }
    continue
  }

  $logOut = Join-Path $logPath "$($c.Name).out.log"
  $logErr = Join-Path $logPath "$($c.Name).err.log"

  $p = Start-Process -FilePath $bin -ArgumentList $c.Args -RedirectStandardOutput $logOut -RedirectStandardError $logErr -PassThru
  Start-Sleep -Milliseconds 300

  $status = if ($p.HasExited) { "FAILED" } else { "STARTED" }
  $results += [pscustomobject]@{
    name = $c.Name
    status = $status
    pid = $p.Id
    binary = $bin
    note = ""
    healthUrl = $c.Url
  }
}

$results | ConvertTo-Json | Set-Content -Encoding UTF8 -Path $pidFile
$results | Format-Table -AutoSize

Write-Host ""
Write-Host "Runtime manifest saved to: $pidFile"
