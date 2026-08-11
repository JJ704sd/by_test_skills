---
name: test-scope-case-designer
description: 根据需求、变更、事故、发布说明或质量目标定义风险驱动的功能、NFR 与 Agent 测试范围、判据、覆盖矩阵和可执行用例。用于决定测什么、测多深或建立用例基线；不负责工具选型、测试阶段门禁、Agent 批量评测或生产发布。
---

# 测试范围与用例设计

负责测试对象、风险、深度、排除项、可测判据、用例和追踪关系。适用的产品、业务、架构、安全或运维角色批准 NFR/SLO 与风险接受标准；本技能记录来源和缺口，不虚构阈值或执行结果。

交付深度：`scope_only` 只给范围和估算；`representative_cases` 增加覆盖骨架与代表用例；`baseline_ready` 仅在用户明确要求可入库基线时展开完整字段和版本信息。

## 工作流

1. 对比上一版快照，整理需求、代码、配置、接口、数据、依赖和 Agent 组件变化。
2. 追踪上下游、共享组件、权限、资金、敏感数据、高频路径和历史逃逸点。
3. 按 [scope-policy.md](references/scope-policy.md) 记录风险、依据、包含/排除项和默认深度。
4. 建立“来源 -> 风险 -> 判据 -> 负载/故障模型 -> 场景/用例 -> 证据”关系；NFR 读取 [nfr-design.md](references/nfr-design.md)。
5. 估算环境组合、数据、执行轮次、自动化和人工复核量，并披露假设。
6. 按 [case-design.md](references/case-design.md) 先生成覆盖骨架，再按交付深度展开、评审和版本化。

## 硬规则

- 预期结果必须可观察；核心需求覆盖正常、异常、边界和恢复。
- 资金、计费、权限、安全、敏感数据和一致性按高风险处理。
- 排除项必须有原因、剩余风险、所有者和重新纳入条件。
- Agent 用例引用批准的采样与阈值；未批准时标为 `UNAPPROVED`，单次输出不代表非确定性质量。
- NFR 判据包含来源、批准状态、公式、单位、窗口、环境、负载/故障模型、证据和门禁动作；不得发明阈值。

工具与环境交给 `$test-tool-governor`，测试阶段门禁交给 `$test-process-governor`，Agent 批量采样交给 `$agent-nondeterministic-evaluator`，生产发布交给 `$release-regression-gatekeeper`。输出先给范围结论、假设、未知项和重新评估条件。
