# Ops Observability Kit - 依赖矩阵

最后更新：2026-03-02

字段规范：`GOVERNANCE_FIELD_SCHEMA.md`（依赖字段规范）

## 状态定义
- `READY`：已可用且已验证。
- `PENDING`：已识别但未完成。
- `BLOCKED`：存在阻碍，需升级处理。

## 关键依赖矩阵
| 依赖ID | 依赖项 | 类型 | 影响任务 | 验证方式 | 当前状态 | 负责人 | 目标就绪日期 | 证据链接 | 复审日期 | 备注 |
|---|---|---|---|---|---|---|---|---|---|---|
| DEP-O-001 | 本地运行时基础环境（非 Docker） | 环境 | O-M0-* | `.\scripts\start_local_stack.ps1` 可执行并生成运行清单 | READY | Jiang39 | 2026-03-02 | scripts/start_local_stack.ps1; .runtime/pids.json; docs/DECISION_LOG.md (DEC-O-008); docs/RISK_ACCEPTANCE_REGISTER.md (RA-O-001) | 2026-03-03 | Docker 已降级为可选参考 |
| DEP-O-002 | 本地网络与端口可用 | 环境 | O-M0-02, O-M0-09 | 端口连通检查脚本通过 | READY | Jiang39 | 2026-03-02 | docs/DEPENDENCY_EVIDENCE_2026-02-27.md (DEP-O-002); docs/DEPENDENCY_VERIFICATION_CHECKLIST.md#dep-o-002 | 2026-03-03 | 关键端口空闲，满足本地模式启动前置 |
| DEP-O-003 | Grafana 数据源自动导入机制 | 配置 | O-M0-06, O-M2-* | 启动后无需手动配置 | PENDING | Jiang39 | 2026-03-03 | configs/grafana/provisioning/datasources/datasources.yaml; dashboards/api-health.json; dashboards/error-triage.json; docs/DEPENDENCY_VERIFICATION_CHECKLIST.md#dep-o-003 | 2026-03-03 | 配置与仪表盘已落地，待启动后核验数据源状态 |
| DEP-O-004 | 示例日志输入源 | 数据 | O-M0-04, O-M1-* | Explore 可查到测试日志 | PENDING | Jiang39 | 2026-03-03 | compose/sample-logs/app.log; configs/promtail/promtail-config.yaml; docs/LOGQL_COOKBOOK_V1.md; docs/DEPENDENCY_VERIFICATION_CHECKLIST.md#dep-o-004 | 2026-03-03 | 示例日志、采集配置与查询手册已落地，待完成写入与检索双向验证 |
| DEP-O-005 | 试点服务对接窗口 | 组织 | O-M4-* | `PILOT_SCOPE.md` 确认 | READY | Jiang39 | 2026-03-02 | docs/PILOT_SCOPE.md; docs/DECISION_LOG.md (DEC-O-006); docs/DEPENDENCY_VERIFICATION_CHECKLIST.md#dep-o-005 | 2026-03-03 | 单人开发模式下完成自确认，组织窗口依赖已满足 |
| DEP-O-006 | 告警接收通道（邮件/IM） | 集成 | O-M0-07, O-M2-06 | 测试告警可送达 | PENDING | Jiang39 | 2026-03-06 | configs/alertmanager/alertmanager.yml; docs/DRILL_ALERTING_M2.md; docs/DEPENDENCY_VERIFICATION_CHECKLIST.md#dep-o-006 | 2026-03-05 | 路由模板与演练模板已落地，待确认目标通道并发送测试告警 |

## 依赖统计（当前）
- READY：3
- PENDING：3
- BLOCKED：0
- 结论：非 Docker 模式下核心前置依赖已可执行，剩余为运行验证类依赖待补证据。

## 依赖变更记录
- 2026-02-27：初始化依赖矩阵。
- 2026-02-27：补齐负责人与目标就绪日期。
- 2026-02-27：补齐证据链接与复审日期字段。
- 2026-02-27：治理复核，补齐依赖证据链接并将 DEP-O-005 状态更新为 BLOCKED。
- 2026-02-27：完成 DEP-O-001/002 实测，新增证据文档并将 DEP-O-001 更新为 BLOCKED。
- 2026-02-27：根据 RA-O-001 将 DEP-O-001 标注为“风险接受后暂缓”，复审日期调整为 2026-03-03。
- 2026-03-02：将过期复审项统一滚动到 2026-03-03，并标注 DEP-O-002 目标日期已过期。
- 2026-03-02：新增 `PILOT_SCOPE.md` 模板作为 DEP-O-005 证据载体，待业务侧确认后再判定状态变更。
- 2026-03-02：补齐 `PILOT_SCOPE.md` 提议版内容（窗口/回滚/风险控制），DEP-O-005 仍保持 BLOCKED 直至签字确认。
- 2026-03-02：按单人开发模式完成 DEP-O-005 自确认，状态由 BLOCKED 调整为 READY。
- 2026-03-02：补充 DEP-O-003/004/006 的实现侧证据链接，状态保持 PENDING 直至运行验证完成。
- 2026-03-02：按 DEC-O-008 切换为非 Docker 主路径，DEP-O-001 从 BLOCKED 调整为 READY（可选依赖）。
- 2026-03-02：DEP-O-002 按本地端口实测结果调整为 READY。
- 2026-03-02：补充 DEP-O-003/004/006 与仪表盘/演练文档的关联证据。
