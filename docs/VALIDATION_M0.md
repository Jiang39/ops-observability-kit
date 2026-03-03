# Ops Observability Kit - M0 验证报告（本地模式）

最后更新：2026-03-02  
验证人：Jiang39

## 1. 验证范围
- O-M0-01 到 O-M0-10
- 启动模式：本地进程脚本（非 Docker 主路径）

## 2. 执行命令
```powershell
Copy-Item .env.example .env
.\scripts\start_local_stack.ps1
.\scripts\validate_m0.ps1
```

## 3. 当前结果摘要
- 结构与配置文件：已落地（PASS）
- 本地启动脚本：已执行（全部组件返回 `SKIPPED`，原因为本机未安装对应二进制）
- 端口占用检查：通过（3000/3100/3200/4317/4318/9090/9093 均空闲）
- 服务健康检查：无硬失败；因未启动进程产生 `WARN`，符合当前环境预期

## 3.1 本次执行记录（2026-03-02）
- 执行命令：`.\scripts\start_local_stack.ps1`
- 结果：生成 `.runtime/pids.json`，各组件状态为 `SKIPPED`（binary not found）
- 执行命令：`.\scripts\validate_m0.ps1`
- 结果：`M0 validation result: PASS (no hard failures; WARN/INFO may remain)`

## 4. 已知问题
1. 如本机缺少对应二进制，`start_local_stack.ps1` 会显示 `SKIPPED`。
2. Grafana/Tempo/OTel 等健康接口检查依赖实际进程启动。

## 5. 后续补证据项
1. 安装并接入本地二进制后，补充“组件实际启动 + 健康检查通过”证据。
2. 将 DEP-O-003 / DEP-O-004 / DEP-O-006 从 PENDING 评估为 READY（若验证通过）。
3. 增补至少一次真实日志写入与 Grafana Explore 命中截图/摘要。
