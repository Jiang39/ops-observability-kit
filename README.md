# Ops Observability Kit

Minimal local observability stack for logs, metrics, and traces.

## Components
- Grafana
- Prometheus
- Loki
- Promtail
- Tempo
- OpenTelemetry Collector
- Alertmanager

## Quick Start (Local Process Mode)
1. Copy environment template:
```powershell
Copy-Item .env.example .env
```
2. Start services:
```powershell
.\scripts\start_local_stack.ps1
```
3. Validate:
```powershell
.\scripts\validate_m0.ps1
```
4. Open UI:
- Grafana: `http://localhost:3000`
- Prometheus: `http://localhost:9090`
- Loki API: `http://localhost:3100/ready`
- Alertmanager: `http://localhost:9093`

## Default Credentials
- Grafana user: `admin`
- Grafana password: `admin`

## Config Paths
- Compose (optional reference): `compose/docker-compose.yml`
- Loki: `configs/loki/loki-config.yaml`
- Promtail: `configs/promtail/promtail-config.yaml`
- Prometheus: `configs/prometheus/prometheus.yml`
- Tempo: `configs/tempo/tempo.yaml`
- OTel Collector: `configs/otel/collector.yaml`
- Grafana datasources: `configs/grafana/provisioning/datasources/datasources.yaml`
- Alertmanager: `configs/alertmanager/alertmanager.yml`
- Start script: `scripts/start_local_stack.ps1`
- Stop script: `scripts/stop_local_stack.ps1`
- Validation script: `scripts/validate_m0.ps1`
- Demo service: `examples/demo-service/app.py`

## Notes
- A sample log file is available at `compose/sample-logs/app.log`.
- Docker is optional in current plan; default path is local process mode.
- M1-M4 draft artifacts are available under `docs/` and `dashboards/` for offline completion.
