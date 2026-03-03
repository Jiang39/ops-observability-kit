# Ops Observability Kit - 链路演练报告（M3）

最后更新：2026-03-02  
状态：PARTIAL（离线关联预演完成，待 Tempo 实测）

## 演练目标
1. 验证日志与 Trace 可双向跳转。
2. 通过一次跨服务调用定位故障根因。

## 演练步骤
1. 触发 demo-service 正常请求与错误请求（`/error`）。
2. 在日志中提取 `traceId` 并检索 Tempo。
3. 在 Trace 中定位异常 span，再回查关联日志。
4. 输出定位结论与耗时。

## 离线预演记录（已执行）
- 演练时间：2026-03-02 16:47:48 +08:00
- 执行命令：`.\scripts\run_drill_m3.ps1`
- 证据文件：`.runtime/evidence/m3/summary.json`
- traceId：`drill-m3-trace-001`
- 结果摘要：
1. `matched_trace_logs=2`
2. `has_error=true`
3. `has_info=true`
- 根因结论：可通过同一 `traceId` 关联到正常/异常日志样本。
- 结论：通过（离线关联预演通过）

## 待补运行态证据
1. 在 Tempo 中检索同一 `traceId` 并回填结果。
2. 记录日志->Trace 与 Trace->日志实际耗时。
