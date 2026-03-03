# Ops Observability Kit - 会话执行手册

最后更新：2026-02-27

## 新会话启动步骤（固定流程）
1. 读取 `MASTER_PLAN.md` 的当前焦点/下一步/开放风险。
2. 读取 `TASK_BREAKDOWN.md` 的当前迭代任务与任务健康检查。
3. 读取 `READINESS_GATE.md`，确认当前是计划阶段还是可启动实现。
4. 读取 `BLOCKER_REGISTER.md` 与 `DEPENDENCY_MATRIX.md`，先处理 P0 阻碍。
5. 本次会话只选 1-3 个任务 ID，避免并行过多导致质量下降。

## 会话内执行规范
- 先更新状态：`TODO -> DOING`。
- 完成后补齐证据：命令、输出摘要、文档链接。
- 若卡住超过 30 分钟，必须新增阻碍条目并给出绕行方案。

## 会话结束清单
- [ ] 更新 `TASK_BREAKDOWN.md` 对应任务状态
- [ ] 更新 `MASTER_PLAN.md` 当前焦点/下一步/开放风险
- [ ] 更新 `BLOCKER_REGISTER.md` 状态与新阻碍
- [ ] 更新 `DEPENDENCY_MATRIX.md` 状态变化
- [ ] 记录下一会话首要任务 ID

## 会话记录模板
- 日期：
- 会话目标：
- 完成任务 ID：
- 未完成任务 ID：
- 新增阻碍：
- 依赖状态变化：
- 下一会话首要任务：
