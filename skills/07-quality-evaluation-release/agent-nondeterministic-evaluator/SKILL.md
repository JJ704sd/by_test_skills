---
name: agent-nondeterministic-evaluator
description: 将已批准的 Agent 场景物化为版本化评测集，执行基线、重复采样、非确定性语义质量、运行 NFR 和在线漂移评测。用于首版或变更 Agent、独立基准和漂移监控；确定性服务/API/UI 门禁交给测试流程，生产放量、停止和回滚交给发布门禁。
---

# Agent 非确定性评测

拥有数据集物化、重复采样、指标、基线差异、人工证据、离线门禁和在线质量信号。场景意图与判据归范围 owner，runner/Judge 绑定归工具 owner，生产流量归发布 owner；本技能应用已批准契约，不批准阈值或执行停止/回滚。

模式：`evaluate` 比较离线基线；`create_baseline` 建立待批准首版；`online_monitor` 引用既有离线 `PASS` 并只输出在线信号。深度：`preflight` 只校验契约；`impacted` 运行影响与高风险子集但不能准出；`required_gate` 完成批准计划后才可 `PASS`。

## 工作流

1. 校验用例基线、runner/Judge 绑定、脱敏数据、baseline、threshold/NFR profile、环境、Trace 和 sampling plan；用 [产物模板](assets/evaluation-templates.md) 固定输入。
2. 物化版本化数据集并按 [测试集方法](references/testset-and-methods.md) 检查核心、增量、鲁棒、对抗和长尾覆盖；若需改变场景意图或判据，退回范围 owner。
3. dry-run 后按批准计划批量执行，分开记录技术与语义失败；运行质量读取 [Agent NFR](references/operational-nfr.md)。
4. 按确定性判定、语义量表和人工复核逐层升级，用 [指标门禁](references/metrics-and-gates.md) 计算公式、置信与基线变化。
5. 在线模式按 [在线信号与缺陷分域](references/online-and-severity.md) 评估；按 [快照契约](references/execution-contracts.md) 归档证据并回流失败案例。

## 不可违反

- Agent 相关确定性子门禁未 `PASS`、数据未脱敏、高风险判据缺失或环境不可信时不得准出。
- sampling 与扩样规则在运行前批准；高风险有效失败不得被平均，技术失败与语义失败分域，重试不抹除首次失败。
- 候选与基线使用可比数据、判定、环境和配置，否则 `REVIEW_REQUIRED`；LLM 评审不能独占计费、权限、安全或核心业务判定。
- 线上采样不能替代离线门禁；`STOP_RECOMMENDED` 只是证据信号。没有 `$release-gatekeeper` 当前阶段许可时不得开始生产采样、改变流量、停止或回滚。
