# Ops Observability Kit - 小任务拆解

最后更新：2026-03-02  
适用阶段：M0-M4

## 使用说明
- 状态取值：`TODO` / `DOING` / `DONE` / `BLOCKED`。
- 优先级取值：`P0` / `P1` / `P2`。
- 每个任务要求：有明确前置依赖、有可验证产出、有量化验收标准。
- 单任务建议控制在 1-4 小时，可跨会话直接续做。

## 任务健康检查（本次修正）
已修正的问题：
1. 依赖链不完整：原计划中 Grafana 仪表盘任务缺少“数据源与自动导入配置”前置。
2. 可验证性不足：部分验收标准仅描述“可用”，缺少量化阈值和验证命令。
3. 链路关联断点：原 M3 未明确“示例应用埋点”任务，日志与 trace 可能无法形成闭环。
4. 试点评估缺口：原 M4 没有“接入前基线采样”，无法证明 MTTR 改善。

已新增/调整：
- 新增 O-M0-06、O-M0-07、O-M0-09（数据源、告警路由、验证脚本）。
- 新增 O-M3-02（示例服务埋点）确保 log-metric-trace 打通。
- 新增 O-M4-02（试点前基线测量）用于效果对比。
- 全面补充量化验收口径。

## 当前迭代任务（建议先做，按顺序）
- [x] O-M0-01 初始化目录骨架（状态：DONE，优先级：P0）
- [x] O-M0-02 编写核心服务编排（compose 参考 + 本地脚本）（状态：DONE，优先级：P0）
- [x] O-M0-03 Loki 最小配置（状态：DONE，优先级：P0）
- [x] O-M0-04 Promtail 最小配置（状态：DONE，优先级：P0）
- [x] O-M0-05 Prometheus 最小配置（状态：DONE，优先级：P0）
- [x] O-M0-06 Grafana 数据源自动配置（状态：DONE，优先级：P0）
- [x] O-M0-07 Alertmanager 路由模板（状态：DONE，优先级：P1）
- [x] O-M0-08 README + `.env.example`（状态：DONE，优先级：P0）
- [x] O-M0-09 启动验证脚本（状态：DONE，优先级：P0，备注：本地模式验证脚本已落地）
- [x] O-M0-10 验证报告落文档（状态：DONE，优先级：P0，备注：已完成本地模式首版验证记录，运行告警待二进制补齐）
- [x] O-M1-01 日志字段字典 v1（状态：DONE，优先级：P0）
- [x] O-M1-02 采集解析流水线 v1（状态：DONE，优先级：P0）
- [x] O-M1-03 标签基数控制规则（状态：DONE，优先级：P1）
- [x] O-M1-04 LogQL 手册 v1（状态：DONE，优先级：P0）
- [x] O-M1-05 Top5 排障剧本（状态：DONE，优先级：P0）
- [ ] O-M1-06 日志可用性演练（状态：DOING，优先级：P1，备注：离线预演已完成，待 Grafana/Loki 实测）
- [x] O-M2-01 指标命名与标签规范（状态：DONE，优先级：P1）
- [x] O-M2-02 抓取模板完善（状态：DONE，优先级：P1）
- [x] O-M2-03 API 健康仪表盘（状态：DONE，优先级：P1）
- [x] O-M2-04 错误定位仪表盘（状态：DONE，优先级：P1）
- [x] O-M2-05 基础告警规则（状态：DONE，优先级：P1）
- [ ] O-M2-06 告警演练报告（状态：DOING，优先级：P1，备注：静态演练已完成，待运行态告警实测）
- [x] O-M3-01 OTel Collector 基线（状态：DONE，优先级：P1）
- [x] O-M3-02 示例服务埋点（状态：DONE，优先级：P1）
- [x] O-M3-03 Trace 仪表盘与数据源联动（状态：DONE，优先级：P1）
- [x] O-M3-04 日志-链路跳转规则（状态：DONE，优先级：P1）
- [ ] O-M3-05 链路演练报告（状态：DOING，优先级：P1，备注：离线关联预演已完成，待 Tempo 实测）
- [x] O-M4-01 试点范围确认（状态：DONE，优先级：P1）
- [x] O-M4-02 试点前基线测量（状态：DONE，优先级：P1）
- [ ] O-M4-03 真实服务接入（状态：DOING，优先级：P1，备注：接入执行指南与变更记录模板已就绪）
- [ ] O-M4-04 试点故障演练与对比（状态：DOING，优先级：P1，备注：对比模板已就绪）
- [x] O-M4-05 差距与风险报告（状态：DONE，优先级：P1）
- [x] O-M4-06 V1 加固计划（状态：DONE，优先级：P1）

## 阶段进度快照（2026-03-02）
- M0：O-M0-01~O-M0-10 已完成（本地模式）
- M1：O-M1-01~O-M1-05 已产出；O-M1-06 为 DRAFT 待实测
- M2：O-M2-01~O-M2-05 已产出；O-M2-06 为 DRAFT 待实测
- M3：O-M3-01~O-M3-04 已产出；O-M3-05 为 DRAFT 待实测
- M4：O-M4-01~O-M4-02 与 O-M4-05~O-M4-06 已产出；O-M4-03~O-M4-04 待真实接入/演练

## M0 仓库初始化（1-2 天）
### O-M0-01 初始化目录骨架
- 预估工时：1h
- 前置依赖：无
- 目标：创建 `compose/`、`configs/`、`dashboards/`、`docs/`、`scripts/`
- 产出：目录结构提交
- 验收：目录与 `MASTER_PLAN.md` 完全一致

### O-M0-02 编写核心 compose
- 预估工时：2h
- 前置依赖：O-M0-01
- 目标：定义 Prometheus/Grafana/Loki/Promtail/Tempo/OTel Collector 服务编排（非 Docker 主路径）
- 产出：`compose/docker-compose.yml`（参考） + `scripts/start_local_stack.ps1`（主路径）
- 验收：本地启动脚本可拉起核心服务进程，且端口监听符合预期

### O-M0-03 Loki 最小配置
- 预估工时：1h
- 前置依赖：O-M0-02
- 目标：可写入并保留最小日志
- 产出：`configs/loki/loki-config.yaml`
- 验收：Loki `/ready` 返回成功，日志写入无报错

### O-M0-04 Promtail 最小配置
- 预估工时：1.5h
- 前置依赖：O-M0-02、O-M0-03
- 目标：采集容器日志并注入基础标签
- 产出：`configs/promtail/promtail-config.yaml`
- 验收：Grafana Explore 中 5 分钟内可检索到至少 1 条日志流

### O-M0-05 Prometheus 最小配置
- 预估工时：1h
- 前置依赖：O-M0-02
- 目标：抓取基础目标（Prometheus 自身 + OTel Collector）
- 产出：`configs/prometheus/prometheus.yml`
- 验收：Targets 页面 up 比例 >= 90%

### O-M0-06 Grafana 数据源自动配置
- 预估工时：1h
- 前置依赖：O-M0-02、O-M0-03、O-M0-05
- 目标：预配置 Prometheus/Loki/Tempo 数据源
- 产出：`configs/grafana/provisioning/datasources/*.yaml`
- 验收：Grafana 启动后无需手动配置即可查询数据源

### O-M0-07 Alertmanager 路由模板
- 预估工时：1h
- 前置依赖：O-M0-02
- 目标：提供默认告警分组与接收路由
- 产出：`configs/alertmanager/alertmanager.yml`
- 验收：测试告警可路由到默认接收器

### O-M0-08 README 与环境模板
- 预估工时：1h
- 前置依赖：O-M0-02
- 目标：提供 30 分钟内可复现启动文档
- 产出：`README.md`、`.env.example`
- 验收：按文档从零启动成功，且无隐式步骤

### O-M0-09 启动验证脚本
- 预估工时：1h
- 前置依赖：O-M0-04、O-M0-05、O-M0-06
- 目标：自动检查本地进程状态、端口可达性、核心 API 就绪
- 产出：`scripts/validate_m0.ps1`
- 验收：脚本执行后输出 pass/fail 汇总

### O-M0-10 启动验证报告
- 预估工时：0.5h
- 前置依赖：O-M0-08、O-M0-09
- 目标：沉淀本地模式验证过程与问题处理
- 产出：`docs/VALIDATION_M0.md`
- 验收：包含命令、结果、问题与修复记录

## M1 日志可用性基线（1 周）
### O-M1-01 日志字段字典 v1
- 预估工时：2h
- 前置依赖：O-M0-10
- 产出：`docs/LOG_FIELD_SPEC.md`
- 验收：字段具备名称、类型、示例、是否必填、脱敏要求

### O-M1-02 采集解析流水线 v1
- 预估工时：3h
- 前置依赖：O-M1-01
- 产出：`configs/promtail/pipelines/*.yaml`
- 验收：`traceId`、`errorCode`、`service` 可被稳定提取

### O-M1-03 标签基数控制规则
- 预估工时：1h
- 前置依赖：O-M1-02
- 产出：`docs/LABEL_CARDINALITY_RULES.md`
- 验收：高基数字段不进入 label，写明替代策略

### O-M1-04 LogQL 手册 v1
- 预估工时：3h
- 前置依赖：O-M1-02
- 产出：`docs/LOGQL_COOKBOOK_V1.md`
- 验收：不少于 10 条查询；每条含用途、语句、期望结果

### O-M1-05 Top5 排障剧本
- 预估工时：2h
- 前置依赖：O-M1-04
- 产出：`docs/TROUBLESHOOT_PLAYBOOK_TOP5.md`
- 验收：覆盖超时、5xx、依赖失败、慢查询、流量突增

### O-M1-06 日志可用性演练
- 预估工时：2h
- 前置依赖：O-M1-05
- 产出：`docs/DRILL_LOGGING_M1.md`
- 验收：可在 10 分钟内通过 `traceId` 定位单请求链路

## M2 指标与告警基线（1 周）
### O-M2-01 指标命名与标签规范
- 预估工时：1.5h
- 前置依赖：O-M0-10
- 产出：`docs/METRIC_NAMING_SPEC.md`
- 验收：命名、单位、标签规范可直接用于代码埋点

### O-M2-02 抓取模板完善
- 预估工时：2h
- 前置依赖：O-M2-01
- 产出：`configs/prometheus/prometheus.yml`
- 验收：至少 3 类目标（平台、应用、中间件）可抓取

### O-M2-03 API 健康仪表盘
- 预估工时：3h
- 前置依赖：O-M2-02、O-M0-06
- 产出：`dashboards/api-health.json`
- 验收：QPS、p95/p99、5xx 比例面板齐全且无空图

### O-M2-04 错误定位仪表盘
- 预估工时：3h
- 前置依赖：O-M2-02、O-M0-06
- 产出：`dashboards/error-triage.json`
- 验收：支持服务/接口维度筛选和下钻

### O-M2-05 基础告警规则
- 预估工时：2h
- 前置依赖：O-M2-02、O-M0-07
- 产出：`configs/prometheus/alerts.yml`
- 验收：可模拟触发 5xx、延迟、实例 down 三类告警

### O-M2-06 告警演练报告
- 预估工时：1.5h
- 前置依赖：O-M2-05
- 产出：`docs/DRILL_ALERTING_M2.md`
- 验收：记录触发、通知、恢复全流程与耗时

## M3 链路关联（1 周）
### O-M3-01 OTel Collector 基线
- 预估工时：2h
- 前置依赖：O-M2-02
- 产出：`configs/otel/collector.yaml`
- 验收：metrics/logs/traces 三路转发正常

### O-M3-02 示例服务埋点
- 预估工时：3h
- 前置依赖：O-M3-01
- 产出：`examples/demo-service/` 或埋点说明
- 验收：示例请求可生成可关联的 `traceId` 日志与 trace

### O-M3-03 Trace 仪表盘与数据源联动
- 预估工时：2h
- 前置依赖：O-M3-02、O-M0-06
- 产出：`dashboards/trace-overview.json`
- 验收：Grafana 中可按 `traceId` 查看完整链路

### O-M3-04 日志-链路跳转规则
- 预估工时：1.5h
- 前置依赖：O-M3-03
- 产出：`docs/LOG_TRACE_CORRELATION.md`
- 验收：从日志跳 trace、从 trace 查日志均可复现

### O-M3-05 链路演练报告
- 预估工时：1h
- 前置依赖：O-M3-04
- 产出：`docs/DRILL_TRACING_M3.md`
- 验收：演练包含至少 1 次跨服务调用定位案例

## M4 企业集成试点（1-2 周）
### O-M4-01 试点范围确认
- 预估工时：1h
- 前置依赖：O-M3-05
- 产出：`docs/PILOT_SCOPE.md`
- 验收：服务边界、负责人、回滚策略明确

### O-M4-02 试点前基线测量
- 预估工时：2h
- 前置依赖：O-M4-01
- 产出：`docs/PILOT_BASELINE_METRICS.md`
- 验收：记录当前 MTTR、告警到定位耗时、误报率

### O-M4-03 真实服务接入
- 预估工时：4h
- 前置依赖：O-M4-02
- 产出：接入配置与变更记录
- 验收：试点服务日志/指标/链路可统一观测

### O-M4-04 试点故障演练与对比
- 预估工时：2h
- 前置依赖：O-M4-03
- 产出：`docs/PILOT_DRILL_COMPARE.md`
- 验收：与基线相比，定位耗时下降趋势明确

### O-M4-05 差距与风险报告
- 预估工时：2h
- 前置依赖：O-M4-04
- 产出：`docs/GAP_ANALYSIS_V1.md`
- 验收：风险含优先级、影响面、建议处置

### O-M4-06 V1 加固计划
- 预估工时：1.5h
- 前置依赖：O-M4-05
- 产出：`docs/HARDENING_BACKLOG_V1.md`
- 验收：每项具备负责人、优先级、工时、截止日期

## 执行节奏建议（10 个工作日）
1. D1-D2：完成 M0（O-M0-01 到 O-M0-10）
2. D3-D4：完成 M1（O-M1-01 到 O-M1-06）
3. D5-D6：完成 M2（O-M2-01 到 O-M2-06）
4. D7-D8：完成 M3（O-M3-01 到 O-M3-05）
5. D9-D10：完成 M4（O-M4-01 到 O-M4-06）

## 待确认参数（启动前补齐）
1. 试点“定位耗时下降”目标阈值（建议先设 20%-30%）。
2. 告警噪声可接受上限（建议以“误报率”或“日均无效告警数”定义）。
3. M2 告警触发阈值的初值（5xx 比例、p95 延迟）按试点服务基线定标。

## 会话更新模板
每次结束会话追加：
- 日期：
- 本次完成任务 ID：
- 阻塞项与原因：
- 下次首要任务 ID：
- 是否更新 `MASTER_PLAN.md` 的当前焦点/下一步/风险：是/否
