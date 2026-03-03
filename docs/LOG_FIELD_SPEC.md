# Ops Observability Kit - 日志字段字典 v1

最后更新：2026-03-02  
版本：v1

## 字段定义
| 字段名 | 类型 | 必填 | 示例 | 说明 | 脱敏要求 |
|---|---|---|---|---|---|
| `timestamp` | string (RFC3339) | 是 | `2026-03-02T05:00:00Z` | 日志事件时间 | 无 |
| `service` | string | 是 | `order-api` | 服务名 | 无 |
| `module` | string | 否 | `checkout` | 子模块 | 无 |
| `env` | string | 是 | `staging` | 环境标识 | 无 |
| `traceId` | string | 否 | `f7f5a3...` | 分布式链路追踪 ID | 无 |
| `spanId` | string | 否 | `4ad91c...` | 链路 span ID | 无 |
| `errorCode` | string | 否 | `ORDER_TIMEOUT` | 业务错误码 | 无 |
| `userId` | string | 否 | `u_1024` | 用户标识（建议哈希） | 必须脱敏/哈希 |
| `path` | string | 否 | `/api/v1/orders` | 请求路径 | 无 |
| `latencyMs` | number | 否 | `128` | 请求耗时（毫秒） | 无 |
| `level` | string | 是 | `info` | 日志级别 | 无 |
| `message` | string | 是 | `request completed` | 日志消息 | 禁止敏感信息明文 |

## 约束规则
1. `service`、`env`、`level`、`timestamp` 为基础必填字段。
2. `traceId` 建议全链路打通，缺失时必须保证 `path` 和 `errorCode` 可用于排障。
3. `userId` 不得写入明文手机号、邮箱、身份证号。
4. 高基数字段（如 `requestId`、原始 URL query）默认不进入 label。

## 兼容与迁移
1. 对现网字段不一致场景，保持双写映射过渡（见 `DEC-O-002`）。
2. 新日志源优先按本字典写入，旧日志源通过 Promtail pipeline 做字段补齐。
