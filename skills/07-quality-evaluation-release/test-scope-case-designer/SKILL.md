---
name: test-scope-case-designer
description: 根据需求、变更、事故、发布说明或质量目标定义风险驱动的功能、NFR 与 Agent 测试范围、回归层级、判据、覆盖矩阵和可执行用例。用于决定测什么、测多深或建立用例基线；不负责工具选型、测试阶段门禁、Agent 批量评测或生产发布。
---

# 测试范围与用例设计

拥有测试对象、风险、回归层级、深度、排除项、判据和用例意图。适用业务、产品、安全或运维角色批准阈值与风险接受；本技能只记录可核验来源、批准状态和缺口。

交付深度：`scope_only` 只给范围和估算；`representative_cases` 增加覆盖骨架；`baseline_ready` 生成可入库的版本化用例规范。Agent 产物是 `agent_case_baseline`，不是可执行数据集或 runner/Judge 绑定。

## 工作流

1. 对比快照，整理需求、代码、配置、接口、数据、依赖和 Agent 组件变化，追踪上下游、权限、资金、敏感数据和历史逃逸点。
2. 按 [范围策略](references/scope-policy.md) 记录风险、包含/排除与深度；按 [回归模型](references/regression-model.md) 选择并版本化 smoke、core 或 full。
3. 建立“来源 -> 风险 -> 判据 -> 负载/故障 -> 用例 -> 证据”关系；适用时读取 [NFR 设计](references/nfr-design.md)。
4. 估算环境、数据、执行与人工复核量；按 [用例方法](references/case-design.md) 生成覆盖骨架，并用 [用例模板](assets/case-templates.md) 按交付深度展开。

## 硬规则

- 核心需求覆盖正常、异常、边界和恢复；预期必须可观察。
- 资金、计费、权限、安全、敏感数据和一致性按高风险处理；排除项记录依据、剩余风险、所有者和重新纳入条件。
- NFR 与 Agent 采样只引用经批准的 threshold/profile；未批准时标 `UNAPPROVED`，不得发明数字或用单次输出代表非确定性质量。
- 工具与执行门禁归 `$test-execution-governor`，批量 Agent 评测归 `$agent-nondeterministic-evaluator`，生产动作归 `$release-gatekeeper`；下游不得反向改写已批准的场景意图和判据。
