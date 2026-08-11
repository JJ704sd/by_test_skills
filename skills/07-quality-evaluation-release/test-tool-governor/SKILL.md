---
name: test-tool-governor
description: 按测试目标、风险、团队标准和安全边界选择或审计测试工具，并治理版本、环境、权限、凭据、CI/CD 与资产生命周期。用于引入工具、标准化测试栈、设计 NFR 测试环境或审计脚本证据；不定义测试范围、质量阈值、测试准出或生产发布结论。
---

# 测试工具选型与治理

决定复用还是引入工具，以及如何安全实施和维护；只验证工具能否测量已批准目标。没有实施授权时，只输出决策、边界和落地计划。

决策深度：`reuse_check` 检查现有标准；`selection_record` 比较少量合格候选；`implementation_plan` 仅在用户要求落地时补充试用、迁移、CI、培训和退出方案。

## 工作流

1. 明确对象、风险、规模、验收指标、证据格式和 CI/CD 需求。
2. 核对团队标准、许可证、维护状态、人员能力和既有资产；记录来源与核验日期。
3. 先应用安全、环境、许可和必需能力否决项；命中时给出整改条件。
4. 复用失败时，按 [tool-catalog.md](references/tool-catalog.md) 建立能力短名单；NFR 同时读取 [nfr-tooling.md](references/nfr-tooling.md)。
5. 需要试用或正式决策时，按 [governance.md](references/governance.md) 在隔离环境验证能力、证据和生命周期成本。
6. 输出采用、限定采用、不采用或 `REVIEW_REQUIRED`，并分列选择结论、执行授权、适用范围和失效条件。

## 安全否决项

- 不用测试工具对生产执行压测、容量摸底、安全扫描、渗透、破坏性故障注入、删除或修改；审批不能解除。
- 主动测试脚本不得默认或回退指向生产。
- 不使用共享账号、超额权限，或在仓库、脚本、日志、Trace 和报告中明文保存 Secret 或隐私数据。
- Agent 资产必须固化模型、参数、Prompt、工具、知识库、数据集和评测版本。
- 长期资产必须有断言、原始失败、日志、统计、版本和可复现路径。
- LLM 评审不能作为计费、权限、安全或核心业务的唯一证据。

范围和用例交给 `$test-scope-case-designer`，测试阶段门禁交给 `$test-process-governor`，Agent 质量交给 `$agent-nondeterministic-evaluator`，生产发布交给 `$release-regression-gatekeeper`。
