---
name: test-execution-governor
description: 选择或审计测试工具、环境、权限与凭据，并治理功能测试和通用确定性 NFR 的生命周期门禁。工具选型或资产治理使用 tool_selection；build 的准入、暂停、准出或关闭使用 lifecycle_gate。不要用它定义测试范围、评估 Agent 非确定性质量或决定生产流量。
---

# 测试执行治理

维护测试执行能力与生命周期门禁，但始终把选择结论、执行授权、门禁、进度和生命周期作为独立状态。

## 选择模式

| 当前问题 | 模式 |
| --- | --- |
| 复用、选择或审计工具、runner、Judge、环境、权限、凭据或长期资产 | `tool_selection` |
| 判断 build 能否进入、继续、暂停、准出测试，或执行/生命周期能否关闭 | `lifecycle_gate` |

一次请求需要两个模式时，先冻结 `tool_selection` 交接包，再让 `lifecycle_gate` 消费；工具被采用不能推导执行授权或门禁通过。

## 共同边界

读取 `$test-scope-case-designer` 批准的范围、回归层级、判据和用例，不得为获得通过而缩减它们。Agent 的可执行数据集、采样和质量证据交给 `$agent-nondeterministic-evaluator`；生产流量、停止与回滚只交给 `$release-gatekeeper`。

## tool_selection

1. 明确对象、风险、规模、验收指标、证据格式和 CI/CD 需求；Agent 评测只提取 runner 与 Judge 所需能力，不改写批准的场景意图。
2. 核对团队标准、许可证、维护状态、人员能力和既有资产；记录来源与核验日期，优先复用满足全部必需能力的现有标准。
3. 先应用安全、环境、许可和能力否决项；需要候选时读取 [tool-catalog.md](references/tool-catalog.md)，NFR 同时读取 [nfr-tooling.md](references/nfr-tooling.md)。
4. 需要试用或正式决策时，按 [tool-governance.md](references/tool-governance.md) 在隔离环境验证能力、证据和生命周期成本。
5. 分开输出 `selection_decision` 与 `execution_authorization`，并记录适用范围、资产、失效条件和落地计划。采用结论不能授权实施或执行。

## lifecycle_gate

1. 固定版本/build、当前决策点、范围、工具与环境交接包、外部授权来源、阈值、用例和证据快照，只记录变化。依赖新工具时必须验证有效的选型快照和执行授权引用，否则 `BLOCKED`。
2. 按 [process-policy.md](references/process-policy.md) 建立当前门禁、阶段或全生命周期台账；NFR 读取 [nfr-evidence.md](references/nfr-evidence.md)。
3. 检查范围、判据、数据、工具、环境和 NFR 计划的就绪度，治理提测准入、冒烟、系统测试、缺陷、修复点和影响面回归。
4. 仅在 `decision_point=EXIT_GATE` 时判定测试准出，并核对完成度、P0/P1、产品验收、NFR、报告和遗留风险。
5. 按 [execution-contracts.md](references/execution-contracts.md) 输出门禁与证据；把测试报告和恢复关注点交给 `$release-gatekeeper`。

## 不可混淆

- `selection_decision`、`execution_authorization`、`machine_status`、`test_execution_status` 和 `test_lifecycle_status` 互不推定。
- 缺失证据不能推定通过；环境、工具或构建不可信时暂停。P0/P1 未修复并回归通过时不得准出。
- 没有执行授权时只给决策、门禁结论和操作清单，不声称动作已完成。
- 不在生产执行压测、容量摸底、安全扫描、渗透或破坏性故障注入；主动脚本不得默认或回退指向生产。
- 不使用共享账号、超额权限或明文 Secret；长期资产必须可版本化、可复现并有维护与退出条件。
- `PASS_WITH_ACCEPTED_RISK` 必须带批准、范围、补偿、责任人和期限；测试准出不能推导生产发布。
