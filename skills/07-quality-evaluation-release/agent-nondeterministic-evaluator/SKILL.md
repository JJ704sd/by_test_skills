---
name: agent-nondeterministic-evaluator
description: 将已批准的 Agent 场景物化为版本化评测集，执行基线、重复采样、非确定性语义质量、运行 NFR 和在线漂移评测。用于首版或变更 Agent、独立基准和漂移监控；确定性服务/API/UI 门禁交给测试流程，生产放量、停止和回滚交给发布门禁。
---

# Agent 非确定性评测

从已批准的 `agent_case_baseline` 物化可执行数据集，负责采样、指标、基线差异、人工证据、离线门禁和在线质量信号。场景意图与判据归测试范围，runner/Judge 工具绑定归工具治理；本技能应用它们但不能擅自改写。适用角色批准阈值；本技能不批准阈值，也不执行生产停止或回滚。

模式：`evaluate` 比较离线基线；`create_baseline` 建立待批准首版基线；`online_monitor` 引用既有 `offline_gate=PASS` 并只输出在线信号。

深度：`preflight` 只校验契约；`impacted` 运行受影响和高风险子集，成功不能准出；`required_gate` 完成批准计划后才可 `PASS`。

## 工作流

1. 按 [templates.md](references/templates.md) 校验批准的用例基线、runner/Judge 工具绑定、脱敏数据集、基线、阈值、环境、Trace 和采样计划。
2. 从用例基线物化并冻结版本化 `dataset_manifest`、模式、深度、阈值、`min_runs/max_runs`、扩样和重试规则；若转换需要改变场景意图或判据，退回范围所有者。
3. 按 [testset-and-methods.md](references/testset-and-methods.md) 检查核心、增量、鲁棒、对抗和长尾覆盖。
4. dry-run 通过后按计划批量执行，分开记录技术与语义失败；运行 NFR 读取 [operational-nfr.md](references/operational-nfr.md)。
5. 按“精确/Schema -> 业务规则 -> 语义量表 -> 人工复核”判定，并用 [metrics-and-gates.md](references/metrics-and-gates.md) 计算指标、置信和基线变化。
6. 在线模式按 [online-and-severity.md](references/online-and-severity.md) 输出信号；归档版本化证据并回流失败案例。

## 不可违反

- Agent 相关确定性子门禁未 `PASS` 时停止评测准出。
- 未脱敏数据、高风险判据缺失或环境不可信时 `BLOCKED`。
- 采样与扩样条件在运行前声明；高风险有效失败不得被平均。
- 技术失败与语义失败分域；重试不得掩盖不稳定性。
- 候选和基线必须使用可比数据、判定和配置，否则 `REVIEW_REQUIRED`。
- LLM 评审不能作为计费、权限、安全或核心业务的唯一证据。
- 线上采样不能替代离线门禁；`STOP_RECOMMENDED` 只是信号。

范围、用例意图和判据由 `$test-scope-case-designer` 提供；确定性门禁由 `$test-execution-governor` 的 `lifecycle_gate` 模式提供，runner/Judge 绑定、采集工具与数据安全由其 `tool_selection` 模式校验。既有运维授权只作为 `actor_authorization` 证据；`$release-gatekeeper` 仍是本技能集内唯一生产门禁 owner。没有其当前发布阶段许可时，本技能不能因已有权限自行开始生产采样或改变流量。
