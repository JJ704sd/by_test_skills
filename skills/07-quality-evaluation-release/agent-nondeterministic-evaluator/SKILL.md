---
name: agent-nondeterministic-evaluator
description: 将已批准的 Agent 场景物化为版本化评测集，执行基线、重复采样、非确定性语义质量、运行 NFR 和在线漂移评测。用于首版或变更 Agent、独立基准和漂移监控；确定性服务/API/UI 门禁交给测试流程，生产放量、停止和回滚交给发布门禁。
---

# Agent 非确定性评测

## 决策权

负责测试集、采样、指标计算、基线差异、人工证据、离线门禁和在线质量信号。范围技能定义场景和判据，产品、业务、架构等适用角色批准阈值；本技能不自行批准阈值，也不执行流量停止或回滚。

- 确定性门禁由 $test-process-governor 提供。
- 场景、影响和用例需求由 $test-scope-case-designer 提供。
- 工具、环境、权限、Secret 和生产采样授权由 $test-tool-governor 提供。
- $release-regression-gatekeeper 消费离线门禁与在线信号并拥有生产动作。

## 模式与深度

模式：

- evaluate：执行离线评测和可比基线判断。
- create_baseline：建立待批准首版基线，不输出相对基线通过。
- online_monitor：引用既有 offline_gate=PASS，只输出当前窗口在线质量信号。

执行深度：

- preflight：校验契约和少量 dry-run，不产生离线门禁。
- impacted：运行受影响、高风险和历史失败集合；成功不能替代正式门禁。
- required_gate：完成批准计划的全部集合、采样和复核后，才可 PASS。

## 工作流

1. 读取 [templates.md](references/templates.md) 校验版本清单、确定性门禁、脱敏数据集、基线、阈值、环境、runner、Judge、Trace 和采样计划。
2. 冻结模式、执行深度、版本、测试集、阈值、min_runs/max_runs/escalation_rule 和重试策略。
3. 检查核心、增量、鲁棒、对抗和长尾覆盖；读取 [testset-and-methods.md](references/testset-and-methods.md)。
4. 先做代表性 dry-run；管线可靠后按批准计划批量执行，并分开记录技术失败和语义失败。运行 NFR 时读取 [operational-nfr.md](references/operational-nfr.md)。
5. 按“精确/Schema -> 业务规则 -> 语义量表 -> 人工复核”级联判定；读取 [metrics-and-gates.md](references/metrics-and-gates.md) 计算指标、置信与基线变化。
6. 输出门禁或在线信号、归档版本化证据并回流失败案例；在线模式读取 [online-and-severity.md](references/online-and-severity.md)。

## 不可违反

- Agent 相关确定性 API、服务、基础对话和工具子门禁必须 PASS；FAIL、PAUSED 或 BLOCKED 时停止评测准出。
- 未脱敏数据、高风险判据缺失或环境不可信时 BLOCKED，不能用假设补齐。
- 采样次数和扩样条件在运行前声明，不能看到结果后临时追加。
- 高风险有效失败不得被平均；impacted 可按批准计划早失败，但子集成功不能 PASS。
- 技术失败与语义失败分域；重试不得掩盖不稳定性。
- 候选和基线使用同一数据集、判定和可比配置；不可比时 REVIEW_REQUIRED。
- 精确规则优先，LLM 评审只能辅助计费、权限、安全和核心业务判定。
- 线上采样不能替代离线门禁；STOP_RECOMMENDED 只是信号，不代表已停止或回滚。

## 输出与参考

先给离线门禁或在线信号，再给版本、采样、指标、失败聚类和证据。状态字段、深度约束、JSON 用例、报告和交接包统一读取 [templates.md](references/templates.md)，不要复制契约。

- 测试集来源、分层、方法和频率：[testset-and-methods.md](references/testset-and-methods.md)
- 指标、阈值、采样、基线和门禁：[metrics-and-gates.md](references/metrics-and-gates.md)
- 在线指标、停止信号和缺陷分域：[online-and-severity.md](references/online-and-severity.md)
- 运行 NFR、负载/故障、降级与恢复：[operational-nfr.md](references/operational-nfr.md)
- 输入输出、状态、JSON、报告和交接：[templates.md](references/templates.md)
