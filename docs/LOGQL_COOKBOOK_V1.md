# Ops Observability Kit - LogQL 手册 v1

最后更新：2026-03-02  
版本：v1

## 使用约定
- 默认日志流：`{service=~".+"}`
- 时间窗：`[$__interval]` 或 `[5m]`
- 字段来自 `LOG_FIELD_SPEC.md`

## 查询清单（12 条）
1. 指定服务最近错误日志
```logql
{service="order-api", level=~"error|warn"}
```

2. 按错误码统计（5 分钟）
```logql
sum by (errorCode) (count_over_time({service="order-api", level="error"}[5m]))
```

3. 按路径统计错误
```logql
sum by (path) (count_over_time({service="order-api", level="error"}[5m]))
```

4. 指定 `traceId` 定位单次请求
```logql
{service="order-api"} |= "traceId=bootstrap-trace-001"
```

5. 文本检索超时异常
```logql
{service="order-api"} |= "timeout"
```

6. 统计高延迟日志（latencyMs > 500）
```logql
{service="order-api"} | json | unwrap latencyMs | latencyMs > 500
```

7. 统计每分钟错误条数
```logql
sum(count_over_time({service="order-api", level="error"}[1m]))
```

8. 环境维度错误对比
```logql
sum by (env) (count_over_time({service="order-api", level="error"}[5m]))
```

9. 过滤噪声（排除 health）
```logql
{service="order-api"} != "/health"
```

10. Top N 服务错误量
```logql
topk(5, sum by (service) (count_over_time({level="error"}[10m])))
```

11. 按 `module` 聚合告警来源
```logql
sum by (module) (count_over_time({service="order-api", level=~"error|warn"}[5m]))
```

12. 最近 30 分钟含 `errorCode` 的异常明细
```logql
{service="order-api", level="error"} | json | errorCode!=""
```

## 预期结果
1. 可按 `traceId` 与 `errorCode` 快速定位问题范围。
2. 可在 5-10 分钟内得到服务、路径、模块三个维度的错误分布。
