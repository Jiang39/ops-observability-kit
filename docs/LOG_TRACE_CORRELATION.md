# Ops Observability Kit - 日志与链路关联规则

最后更新：2026-03-02  
版本：v1

## 关联主键
1. `traceId`（主关联键）
2. `service` + `timestamp`（辅助）

## 日志到 Trace
1. 在日志详情提取 `traceId`。
2. 在 Tempo 搜索使用 `traceId` 过滤。
3. 定位异常 span 后回看调用链上下文。

## Trace 到日志
1. 从 span 获取 `service.name` 与时间窗。
2. 在 Loki 中按 `service` + `traceId` 查询：
```logql
{service="demo-service"} |= "traceId=<trace-id>"
```
3. 汇总同一 trace 下的 error/warn 日志。

## 失败回退
1. 若缺 `traceId`，用 `path` + `timestamp` + `service` 近似定位。
2. 回填缺失字段到采集流水线中，避免二次丢失。
