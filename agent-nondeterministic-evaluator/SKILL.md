---
name: agent-nondeterministic-evaluator
description: 将已批准的 Agent 场景物化为版本化评测集，联合评估 Agent 组件技术指标与非确定性语义质量，执行首版基线、重复采样、离线门禁、在线漂移，以及延迟、工具可靠性、负载下质量、降级和 Token/成本等运行 NFR。Use for a changed or first-version Agent, an independent benchmark, or drift monitoring; common service/API/UI deterministic NFRs stay with test-process-governor, and rollout/rollback stay with release-regression-gatekeeper.
---

# Agent 非确定性评测

## 职责边界

负责把“同样输入不一定得到同样输出”的质量拆成测试集、采样策略、指标、基线差异、人工证据和质量门禁。

范围技能定义场景与判据，本技能把已批准内容物化成数据集并计算结果；产品/业务/架构批准质量与 NFR 阈值，本技能不自行批准阈值。

- `test-process-governor` 负责 API 连通、服务可用、基础对话/UI、确定性功能和通用缺陷门禁。
- `test-scope-case-designer` 负责版本影响分析、逻辑测试范围和用例设计需求。
- `test-tool-governor` 负责评测工具、环境、权限、Secret 和生产采样审批。
- `release-regression-gatekeeper` 消费本技能的离线门禁和在线质量信号，执行最终 Go/No-Go、放量、停止和回滚。

本技能可以给出 `STOP_RECOMMENDED`，但不得声称已经停止流量或完成回滚。

## 运行模式与必需输入

先选择模式：

- `evaluate`：对候选版本执行离线评测和基线比较。
- `create_baseline`：首版或基线不可用时建立待批准基线；输出 `baseline_candidate_status=REVIEW_REQUIRED`，不输出“相对基线通过”。
- `online_monitor`：输入已批准发布/阶段和既有 `offline_gate=PASS`，只输出本次线上质量信号；不伪造新的离线结论，也不替代离线准出。既有门禁不是 `PASS` 时为 `BLOCKED`。

至少收集：

- 变更清单和 Agent/Prompt/模型参数/规则/工具/知识库/Schema 版本。
- 确定性门禁机器态与证据：Agent 相关的 API、服务、基础对话和工具子门禁必须是 `PASS`。整体状态为 `PASS_WITH_ACCEPTED_RISK` 时，只有另附 `agent_relevant_subgate=PASS`，且全部批准风险的 `impact_on_agent_evaluation=NONE`，才可按治理增强继续并保留条件；`FAIL/PAUSED/BLOCKED` 均输出 `BLOCKED`。这不能放宽 Agent 原规范的“相关确定性测试先通过”。
- 已脱敏且有来源、标签、风险和版本的测试集。
- 上一版本基线；若无基线，仅允许 `create_baseline` 或标为 `REVIEW_REQUIRED`。
- 项目批准的阈值、业务规则、数值容差和人工评审标准。
- 评测环境、脚本版本、采样参数、重试策略和 Trace/请求记录能力。
- 运行 NFR 适用时提供批准的 SLI/SLO、负载/故障模型、组件拆分、降级/恢复规则和用量口径。
- `online_monitor` 还需发布 ID、先前离线门禁、灰度阶段、批准的采样/隐私规则和阶段阈值。

使用 [templates.md](references/templates.md) 的输入契约记录缺失项。未经脱敏的数据、高风险判据缺失或确定性门禁失败时停止评测，不要用假设补齐。

## 不可违反的规则

1. **先确定性、后非确定性**：基础构建/服务/API/工具故障未通过时，不给 Agent 质量准出。
2. **预先声明采样**：按批准的采样策略运行；缺少项目策略时读取参考文件的规范默认值做计划，不在看到结果后随意改变次数。
3. **高风险失败不被平均**：计费、核心计算、权限、安全拒绝和对外承诺的每次有效语义运行都必须通过；一次有效失败即当前门禁 `FAIL` 并人工复核。
4. **分开技术与语义失败**：网络、限流、服务异常和脚本错误单独统计并保留原始失败；重试不得掩盖不稳定性。
5. **同集比较基线**：候选与基线使用相同测试集版本、判定规则和可比配置；不可比时标为 `REVIEW_REQUIRED`。
6. **规则优先于主观评分**：数值、单位、字段、Schema 和安全先用确定性规则；复杂语义再人工复核，LLM 评审只能辅助。
7. **阈值所有权清晰**：记录项目批准值和适用规范默认值。默认值可用于探索计算；未经批准只能 `REVIEW_REQUIRED`，高风险判据缺失则 `BLOCKED`。不同口径不能只按数字取“更严格”。
8. **在线不能替代离线**：线上采样用于灰度观察、漂移和问题回流，不作为缺失离线门禁的补偿。

## 工作流

1. **阶段 1 - 准入与计划**：验证输入、确定模式，冻结版本/参数/测试集/阈值/采样/重试，并区分高风险用例。
2. **阶段 2 - 数据集准备**：检查核心、增量问题、鲁棒、对抗和长尾覆盖；补充本次变更和最新失败案例。读取 [testset-and-methods.md](references/testset-and-methods.md)。
3. **阶段 3 - 批量执行**：记录每次运行的请求 ID、版本、参数、原始输出、Trace、错误和耗时；保持技术失败与语义失败分域。运行 NFR 场景读取 [operational-nfr.md](references/operational-nfr.md)。
4. **阶段 4 - 指标与基线**：按字段/用例公式计算分子、分母、值和置信信息；报告百分点和相对基线变化；执行规则校验与人工抽检。读取 [metrics-and-gates.md](references/metrics-and-gates.md)。
5. **阶段 5 - 门禁与归档**：所有模式先输出 `mode_execution_status=COMPLETED / REVIEW_REQUIRED / BLOCKED`。`evaluate` 再输出 `PASS / FAIL / REVIEW_REQUIRED / BLOCKED`；`create_baseline` 只有实际生成候选后才输出 `baseline_candidate_status=REVIEW_REQUIRED`，前置失败时该字段为 `null`；归档版本化资产并回流失败案例。
6. **在线观察（按需）**：在已批准的灰度方案下计算解析成功、用户修正、负面反馈、成功率和延迟信号；触发条件时向发布门禁发出停止建议。读取 [online-and-severity.md](references/online-and-severity.md)。

## evaluate 门禁状态

- `PASS`：全部强制指标和高风险用例达标，基线可比且无显著退化，人工复核无严重问题。
- `FAIL`：任一硬门禁失败，或有效高风险样本失败。
- `REVIEW_REQUIRED`：首版待批准基线、配置/数据不可完全比较、基线退化超过评审阈值，或复杂语义存在争议。
- `BLOCKED`：确定性门禁失败、数据未脱敏、关键输入缺失，或环境/脚本使结果不可信。

`online_monitor` 不产生新的 `offline_gate`：沿用并明确引用先前离线门禁，只输出 `OK / WATCH / STOP_RECOMMENDED / NOT_APPLICABLE`。`STOP_RECOMMENDED` 表示下游立即停止阶段推进；是否 `NO_GO` 或 `ROLLBACK` 由发布技能依据已批准硬条件判定。

若模式前置、数据或环境不足，使用 `mode_execution_status=BLOCKED`，该模式结果字段为 `null`，不要用 `REVIEW_REQUIRED` 假装已完成候选基线或用 `WATCH` 假装已计算线上信号。

不要把 `REVIEW_REQUIRED` 写成“有条件通过”。最终发布结论由 `release-regression-gatekeeper` 给出。

## 输出契约

先给离线门禁或在线质量信号，再给证据。至少包含：

1. 运行清单：候选、基线、数据集、阈值、环境、脚本、采样和重试版本。
2. 技术结果与语义结果，含有效/无效运行数。
3. 每项指标的分子、分母、值、阈值、基线、百分点变化、相对变化和结论。
4. 单位归一化、计算、上下文、幻觉、安全及专项测试状态。
5. 适用时提供运行 NFR 的负载/故障、组件延迟、工具可靠性、质量保持、降级/恢复和 Token/成本。
6. 失败样本、原始证据、人工复核、ND 缺陷和初步归因。
7. 输出 `mode_execution_status`，再按模式输出 `offline_gate`、`baseline_candidate_status` 或 `online_quality_signal`，以及发布建议和测试集回流项。

需要机器可读记录、JSON 用例或报告时读取 [templates.md](references/templates.md)。

## 参考文件路由

- 指标公式、阈值、数值容差、基线退化与门禁：读取 [metrics-and-gates.md](references/metrics-and-gates.md)。
- 测试集来源/规模/版本、测试方法和专项频率：读取 [testset-and-methods.md](references/testset-and-methods.md)。
- 在线指标、停止信号、ND 缺陷分域和职责：读取 [online-and-severity.md](references/online-and-severity.md)。
- 输入输出契约、JSON 用例和评测报告：读取 [templates.md](references/templates.md)。
- Agent 运行 NFR、负载/故障下质量、降级恢复和交接：读取 [operational-nfr.md](references/operational-nfr.md)。
