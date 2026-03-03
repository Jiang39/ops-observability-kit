# Ops Observability Kit - 阻碍台账

最后更新：2026-03-02

字段规范：`GOVERNANCE_FIELD_SCHEMA.md`（阻碍字段规范）

## 使用规则
- 每条阻碍必须有负责人、目标解除日期、临时绕行方案。
- 每日更新一次状态：`OPEN` / `MITIGATING` / `RESOLVED` / `ACCEPTED_RISK`。
- 严重级别：`S0` / `S1` / `S2` / `S3`。

## 当前阻碍清单（已分配负责人与日期）
| ID | 级别 | 类别 | 阻碍描述 | 影响任务 | 负责人 | 目标解除日期 | 临时绕行方案 | 状态 | 证据链接 | 复审日期 |
|---|---|---|---|---|---|---|---|---|---|---|
| OB-O-001 | S1 | 规范冲突 | 现网第三方 Loki 字段命名可能与新规范冲突 | O-M1-01, O-M1-02 | Jiang39 | 2026-03-05 | 在 Promtail 做双写映射（新旧字段并存） | MITIGATING | docs/BLOCKER_RESOLUTION_PLAYBOOK.md#ob-o-001; docs/DECISION_LOG.md (DEC-O-002); docs/LOG_FIELD_SPEC.md; configs/promtail/pipelines/app-json.yaml | 2026-03-03 |
| OB-O-002 | S2 | 资源限制 | 本地机器资源不足可能导致全栈本地进程并发不稳定 | O-M0-02, O-M0-09 | Jiang39 | 2026-03-03 | 优先启动核心三件套（Loki+Promtail+Grafana），其余组件按需启动 | OPEN | docs/BLOCKER_RESOLUTION_PLAYBOOK.md#ob-o-002; docs/DEPENDENCY_VERIFICATION_CHECKLIST.md (DEP-O-001, DEP-O-002) | 2026-03-03 |
| OB-O-003 | S1 | 告警噪声 | 告警阈值无历史数据支撑，初期误报高 | O-M2-05, O-M2-06 | Jiang39 | 2026-03-10 | 先按保守阈值运行一周再回调 | OPEN | docs/BLOCKER_RESOLUTION_PLAYBOOK.md#ob-o-003; docs/GO_NO_GO_REVIEW_2026-03-02.md | 2026-03-03 |
| OB-O-004 | S2 | 采纳风险 | 查询手册质量不足导致团队不用 | O-M1-04, O-M1-05 | Jiang39 | 2026-03-07 | 先做 Top5 场景可直接复制查询 | MITIGATING | docs/BLOCKER_RESOLUTION_PLAYBOOK.md#ob-o-004; docs/LOGQL_COOKBOOK_V1.md; docs/TROUBLESHOOT_PLAYBOOK_TOP5.md | 2026-03-05 |
| OB-O-005 | S1 | 环境缺失 | 当前工作机缺少 Docker 运行时，无法执行 `docker compose` | O-M0-02, O-M0-09, O-M0-10 | Jiang39 | 2026-03-02 | 切换到非 Docker 本地进程模式，Docker 改为可选路径 | RESOLVED | docs/DECISION_LOG.md (DEC-O-008); docs/DEPENDENCY_MATRIX.md (DEP-O-001) | 2026-03-03 |

## 阻碍统计（当前）
- S0：0
- S1：2
- S2：2
- S3：0
- 结论：S1 仍未清零（OB-O-001、OB-O-003 未解除），但 Docker 缺失阻碍已通过架构切换解除。

## 新增阻碍模板
| ID | 级别 | 类别 | 阻碍描述 | 影响任务 | 负责人 | 目标解除日期 | 临时绕行方案 | 状态 | 证据链接 | 复审日期 |
|---|---|---|---|---|---|---|---|---|---|---|
| OB-O-XXX | SX | 类别 | 描述 | 任务ID | 姓名 | YYYY-MM-DD | 方案 | OPEN | 文档路径 | YYYY-MM-DD |
