# Ops Observability Kit - Top5 排障剧本

最后更新：2026-03-02  
版本：v1

## 场景 1：接口超时
1. 看板先看 `p95/p99` 是否上升。
2. LogQL 检索 `timeout` 与高延迟日志：
```logql
{service="order-api"} |= "timeout"
```
3. 按 `path` 聚合确认热点接口。

## 场景 2：5xx 激增
1. 查看 `5xx ratio` 面板趋势。
2. 按 `errorCode` 聚合定位主因：
```logql
sum by (errorCode) (count_over_time({service="order-api", level="error"}[5m]))
```
3. 回看最近发布或配置变更。

## 场景 3：依赖调用失败
1. 检索关键关键字：`upstream`, `dependency`, `connect`.
2. 按 `module` 统计异常来源。
3. 如果有 `traceId`，进入链路看下游 span。

## 场景 4：慢查询
1. 使用高延迟过滤：
```logql
{service="order-api"} | json | unwrap latencyMs | latencyMs > 500
```
2. 关联 `path` 与 `module` 定位 SQL 来源。
3. 回退到慢 SQL 清单或索引检查。

## 场景 5：流量突增
1. 看 QPS 是否异常抬升。
2. 对比 `status` 结构变化（2xx/4xx/5xx）。
3. 检查限流或缓存命中变化。

## 统一收口动作
1. 输出“影响面、主因、回滚/缓解动作”三行摘要。
2. 记录复盘链接并回填到决策/风险文档。
