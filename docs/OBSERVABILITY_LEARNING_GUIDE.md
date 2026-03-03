# Ops Observability Kit - 可观测学习指南（回顾版）

最后更新：2026-03-02

## 1. 先回答关键问题：现成方案都有了，这个项目还做什么？
`Loki + Promtail + Grafana + Prometheus` 本身是可用工具组合。  
本项目目标不是重复造轮子，而是把工具组合工程化为“可复用、可治理、可演进”的套件：
1. 统一标准：字段、标签、查询口径统一。
2. 可复制基线：配置、脚本、看板、告警可复用。
3. 排障闭环：从发现异常到定位根因有固定剧本。
4. 可审计治理：依赖、阻碍、决策、风险全留痕。
5. 试点落地：能接入真实服务并对比效果（如 MTTR）。

一句话：从“能用工具”升级到“能持续交付的观测体系模板”。

## 2. 组件速览
1. Prometheus：采集/存储指标（数值时间序列）。
2. Grafana：可视化与查询入口（连接数据源，不存业务数据）。
3. Loki：日志存储与检索后端。
4. Promtail：日志采集与解析器（推送到 Loki）。

## 3. 数据路径（最小理解）
1. 应用产生日志与指标。
2. 日志：Promtail -> Loki。
3. 指标：Prometheus <- 应用/Exporter（拉模式）。
4. Grafana 同时查询 Prometheus/Loki（以及 Tempo）做统一排障视图。

## 4. Prometheus 入门要点
核心配置文件：`configs/prometheus/prometheus.yml`
1. `scrape_interval`：抓取间隔。
2. `scrape_configs`：抓取目标列表。
3. `rule_files`：加载告警规则（`configs/prometheus/alerts.yml`）。
4. `alerting`：告警投递到 Alertmanager。

常用 PromQL：
1. QPS：`sum(rate(http_requests_total[5m]))`
2. 5xx 比例：`sum(rate(http_requests_total{status=~"5.."}[5m])) / clamp_min(sum(rate(http_requests_total[5m])), 1)`
3. p95：`histogram_quantile(0.95, sum by (le) (rate(http_request_duration_seconds_bucket[5m])))`
4. 实例存活：`up`

## 5. Grafana 入门要点
关键文件：
1. 数据源：`configs/grafana/provisioning/datasources/datasources.yaml`
2. 看板：`dashboards/api-health.json`、`dashboards/error-triage.json`、`dashboards/trace-overview.json`

看板价值：
1. API Health：QPS + 延迟 + 5xx 比例（健康总览）。
2. Error Triage：服务/接口/错误码聚合（快速定位热点）。
3. Trace Overview：链路搜索与时延（补足日志视角）。

## 6. Loki + Promtail 入门要点
关键文件：
1. Loki：`configs/loki/loki-config.yaml`
2. Promtail：`configs/promtail/promtail-config.yaml`
3. Pipeline 样例：`configs/promtail/pipelines/app-json.yaml`
4. 示例日志：`compose/sample-logs/app.log`

Pipeline 关键阶段：
1. `json`：提取字段（`traceId`、`errorCode` 等）。
2. `labels`：仅低基数字段入标签。
3. `timestamp`：使用日志时间。
4. `output`：控制输出字段。

标签基数规则（高优先级）：
1. `service/env/level/errorCode` 可作为标签。
2. `traceId/userId/requestId` 禁止直接作为标签。
3. 详见：`docs/LABEL_CARDINALITY_RULES.md`

## 7. 推荐排障路径（实战）
1. 先看指标（Prometheus/Grafana）：是否是流量、延迟、错误率异常。
2. 再查日志（Loki/LogQL）：按 `service/path/errorCode/traceId` 缩小范围。
3. 再看链路（Tempo）：确认慢点/失败点在调用链哪一层。
4. 输出收口：影响面、主因、缓解/回滚动作、后续改进。

## 8. 当前项目学习后行动建议
1. 对照 `docs/LOGQL_COOKBOOK_V1.md` 先读懂每条查询的意图。
2. 对照 `dashboards/*.json` 理解面板与 PromQL 的关系。
3. 回到项目时优先做三份演练回填：
   - `docs/DRILL_LOGGING_M1.md`
   - `docs/DRILL_ALERTING_M2.md`
   - `docs/DRILL_TRACING_M3.md`
