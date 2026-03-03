# Ops Observability Kit - 项目进度快照（2026-03-02）

## 当前结论
- 项目模式：单人开发轻门禁
- 启动路径：非 Docker 本地进程模式（Docker 仅可选参考）
- 当前阶段：M1-M3 产物完成，待实测回填

## 已完成任务
- M0：O-M0-01 ~ O-M0-10（已完成）
- M1：O-M1-01 ~ O-M1-05（已完成）
- M2：O-M2-01 ~ O-M2-05（已完成）
- M3：O-M3-01 ~ O-M3-04（已完成）
- M4：O-M4-01、O-M4-02、O-M4-05、O-M4-06（已完成）

## 进行中 / 待实测
- O-M1-06 日志演练报告（离线预演已完成，待实测）
- O-M2-06 告警演练报告（静态演练已完成，待实测）
- O-M3-05 链路演练报告（离线预演已完成，待实测）
- O-M4-03 真实服务接入（待真实环境）
- O-M4-04 试点对比演练（待真实环境）

## 关键产物位置
- 主计划与任务：`docs/MASTER_PLAN.md`、`docs/TASK_BREAKDOWN.md`
- 门禁与治理：`docs/READINESS_GATE.md`、`docs/GO_NO_GO_REVIEW_2026-03-02.md`
- 依赖与阻碍：`docs/DEPENDENCY_MATRIX.md`、`docs/BLOCKER_REGISTER.md`
- 本地脚本：`scripts/start_local_stack.ps1`、`scripts/validate_m0.ps1`
- 核心配置：`configs/` 下各组件配置
- 仪表盘：`dashboards/api-health.json`、`dashboards/error-triage.json`、`dashboards/trace-overview.json`

## 回到项目时的首要动作
1. 选择可用运行环境（本地二进制或远端现成环境）。
2. 把离线预演升级为运行态实测并回填三份演练：`DRILL_LOGGING_M1.md`、`DRILL_ALERTING_M2.md`、`DRILL_TRACING_M3.md`。
3. 推进 O-M4-03/O-M4-04，完成真实接入与对比结论。
