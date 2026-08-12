---
name: test-execution-governor
description: 选择或审计测试工具、环境、权限与凭据，并治理功能测试和通用确定性 NFR 的生命周期门禁。工具选型或资产治理使用 tool_selection；build 的准入、暂停、准出或关闭使用 lifecycle_gate。不要用它定义测试范围、评估 Agent 非确定性质量或决定生产流量。
---

# 测试执行治理

维护测试执行能力与确定性生命周期门禁。`tool_selection` 选择或审计工具、runner、Judge、环境、权限和长期资产；`lifecycle_gate` 判断 build 的准入、继续、暂停、准出、执行完成或关闭。一次请求需要两者时先冻结选型交接，再由门禁消费；选型不能推导授权或通过。

读取 `$test-scope-case-designer` 批准的范围、回归层级、判据和用例，不得为通过而缩减。Agent 非确定性质量归 `$agent-nondeterministic-evaluator`；生产流量、停止和回滚归 `$release-gatekeeper`。

## tool_selection

1. 明确对象、风险、规模、必需能力、证据格式和 CI/CD；核对团队标准、许可、维护、技能与既有资产。
2. 先应用安全、环境、许可和能力否决项；按 [能力目录](references/tool-catalog.md) 比较候选，按 [治理规则](references/tool-governance.md) 在隔离环境验证可信度和生命周期成本。
3. 用 [选型模板](assets/tool-selection-templates.md) 分开记录 `selection_decision`、`execution_authorization`、范围、版本、来源、失效条件和落地计划。

## lifecycle_gate

1. 固定 build、决策点、范围、工具/环境交接、外部授权、threshold/profile、用例和证据快照；依赖新工具时核验选型快照及授权引用。
2. 按 [生命周期策略](references/process-policy.md) 检查准入、冒烟、执行、缺陷、修复点、影响面回归和 NFR 证据；仅 `decision_point=EXIT_GATE` 可判测试准出。
3. 按 [状态契约](references/execution-contracts.md) 判定并用 [生命周期模板](assets/lifecycle-templates.md) 记录；把测试报告、监控和恢复关注点交给发布 owner。

## 不可混淆

- `selection_decision`、`execution_authorization`、`machine_status`、`test_execution_status` 和 `test_lifecycle_status` 互不推定；缺失证据不能推定通过。
- 无执行授权时只给决策、门禁结论和操作清单；环境、工具、build 或观测不可信时暂停或阻断。
- P0/P1 未修复并完成可信回归时不得准出；`PASS_WITH_ACCEPTED_RISK` 只容纳经批准的非阻塞风险。
- 不在生产执行压测、容量摸底、安全扫描、渗透或破坏性故障注入；不使用共享账号、超额权限、明文 Secret 或生产回退配置。
