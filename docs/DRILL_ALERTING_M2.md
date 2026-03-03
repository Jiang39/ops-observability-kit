# Ops Observability Kit - 告警演练报告（M2）

最后更新：2026-03-02  
状态：PARTIAL（静态演练完成，待运行态告警实测）

## 演练目标
1. 验证 5xx、延迟、实例 down 三类告警可触发与恢复。
2. 验证 Alertmanager 路由可到达默认接收器。

## 演练步骤
1. 触发模拟 5xx 比例异常。
2. 触发 p95 延迟超阈值。
3. 触发实例不可用（停止目标进程）。
4. 观察告警触发、通知、恢复时间。

## 静态演练记录（已执行）
- 演练时间：2026-03-02 16:47:22 +08:00
- 执行命令：`.\scripts\run_drill_m2.ps1`
- 证据文件：`.runtime/evidence/m2/summary.json`
- 结果摘要：
1. `required_alerts_present=true`（3 条核心规则齐全）
2. `alertmanager_route_present=true`
3. `alertmanager_receivers_present=true`
4. `promtool_available=false`
- 结论：通过（静态规则检查通过）

## 待补运行态证据
1. 触发真实告警并记录触发时间。
2. 记录通知送达时间、恢复时间、总耗时。
3. 回填是否符合阈值与改进项。
