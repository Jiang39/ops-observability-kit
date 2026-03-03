# Ops Observability Kit - 标签基数控制规则

最后更新：2026-03-02  
版本：v1

## 目标
降低 Loki/Prometheus 标签爆炸风险，避免查询变慢与存储成本失控。

## 必须进入标签的字段
1. `service`
2. `env`
3. `level`
4. `errorCode`（有值时）

## 禁止进入标签的字段
1. `traceId`
2. `spanId`
3. `userId`
4. 原始 URL query / request body
5. 任意高基数 ID（订单号、会话 ID、请求 ID）

## 替代策略
1. 高基数字段保留在日志内容中，通过全文过滤查询。
2. 需要聚合时，使用低基数字段（`service`、`path`、`errorCode`）做切片。
3. 对 `path` 先归一化（如 `/orders/:id`）再入指标维度。

## Promtail 实施建议
1. JSON 解析后只将低基数字段放入 `labels`。
2. 对可疑字段使用 `replace` 或 `template` 降维后再考虑打标。
3. 每次新增标签前评估基数并记录影响。

## 评审准入
1. 新标签必须附带“基数预估 + 查询收益说明”。
2. 若预估基数超过 1000，默认拒绝，除非有书面例外批准。
