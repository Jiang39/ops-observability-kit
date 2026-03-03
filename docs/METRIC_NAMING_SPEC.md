# Ops Observability Kit - 指标命名与标签规范

最后更新：2026-03-02  
版本：v1

## 命名规则
1. 统一格式：`<domain>_<object>_<metric>_<unit>`
2. 使用小写与下划线，不使用驼峰。
3. Counter 以 `_total` 结尾；Histogram 使用 `_bucket/_sum/_count`。

## 推荐指标
1. `http_requests_total`
2. `http_request_duration_seconds_bucket`
3. `http_request_duration_seconds_sum`
4. `http_request_duration_seconds_count`
5. `service_dependency_failures_total`

## 标签规则
1. 必选：`service`, `env`
2. 可选：`path`, `method`, `status`
3. 禁止：`traceId`, `userId`, 任意高基数字段

## 单位要求
1. 时间统一秒（`seconds`）
2. 大小统一字节（`bytes`）
3. 比率统一通过计算得到，不直接埋点百分比

## 评审准入
1. 新指标必须说明用途、预期图表、预期告警。
2. 新标签必须提供基数评估。
