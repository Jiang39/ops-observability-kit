# Ops Observability Kit - 试点服务接入指南（O-M4-03）

最后更新：2026-03-02  
状态：READY-FOR-EXECUTION

## 目标
将一个真实服务接入到现有可观测基线，完成日志/指标/链路统一观测。

## 前置条件
1. 服务可执行（本地或测试环境）。
2. 可访问 Grafana/Prometheus/Loki/Tempo 任一运行环境。
3. 服务可输出结构化日志（JSON）并暴露基础指标端点。

## 接入步骤
1. 字段对齐  
将服务日志字段对齐到 `docs/LOG_FIELD_SPEC.md`。

2. 日志接入  
确认日志路径可被 Promtail 采集，必要时新增 `scrape_configs` 条目。

3. 指标接入  
在 `configs/prometheus/prometheus.yml` 中增加该服务抓取目标。

4. 链路接入（可选）  
服务接入 OTel SDK，向 OTel Collector 上报 traces。

5. 仪表盘验证  
在 `dashboards/api-health.json` 与 `dashboards/error-triage.json` 验证服务维度可筛选。

## 验收清单（O-M4-03）
1. 服务日志可在 Loki 按 `service` 与 `traceId` 查询到。
2. 服务指标可在 Prometheus `up` 与请求指标中看到。
3. 若启用 trace，可在 Tempo 检索到该服务的 trace。
4. 变更记录已写入 `docs/PILOT_INTEGRATION_CHANGELOG.md`。

## 回滚清单
1. 移除 Prometheus 新增抓取目标。
2. 移除/回退 Promtail 新增采集配置。
3. 回退服务侧观测相关配置。
4. 记录回滚结果到 `docs/PILOT_INTEGRATION_CHANGELOG.md`。
