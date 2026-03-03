# Ops Observability Kit - 日志可用性演练（M1）

最后更新：2026-03-02  
状态：PARTIAL（离线预演完成，待 Grafana/Loki 实测）

## 演练目标
1. 10 分钟内通过 `traceId` 定位单请求问题链路。
2. 通过 `errorCode` 和 `path` 聚合确认影响范围。

## 演练步骤
1. 生成一条含 `traceId`、`errorCode`、`path` 的测试日志。
2. 在 Grafana Explore 用 LogQL 查询命中日志。
3. 按 `errorCode` 聚合并输出 Top 原因。
4. 记录定位耗时与结论。

## 离线预演记录（已执行）
- 演练时间：2026-03-02 16:48:06 +08:00
- 参与人：Jiang39
- 输入 traceId：`drill-m1-trace-001`
- 执行命令：`.\scripts\run_drill_m1.ps1`
- 证据文件：`.runtime/evidence/m1/summary.json`
- 聚合结果摘要：
1. `total_json_logs=3`
2. `matched_trace_logs=3`
3. `error_logs=1`
4. `services=demo-service`
- 结论：通过（离线预演通过）

## 待补实测证据
1. 在 Grafana Explore 执行 LogQL 并截图命中结果。
2. 记录“命中日志时间”和“定位总耗时”。
