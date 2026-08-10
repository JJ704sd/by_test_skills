---
name: release-regression-gatekeeper
description: 根据批准范围和风险选择回归层级，消费测试、NFR、Agent、审批、监控与回滚证据，决定 GO、CONDITIONAL_GO、NO_GO、BLOCKED 或 ROLLBACK。用于部署前评审、灰度阶段推进、发布关闭或回滚响应；本技能独占生产放量、停止和回滚决策。
---

# 版本回归与发布门禁

## 决策权

把测试准出证据转化为回归层级、发布方式、灰度阶段、停止/回滚动作和发布关闭结论。产品、业务、架构等适用角色批准 NFR/SLO 与风险接受标准；本技能消费证据，不发明阈值。

- $test-scope-case-designer 提供影响、风险、范围和用例。
- $test-process-governor 提供确定性测试准出、缺陷和验收证据。
- $test-tool-governor 提供工具、环境、权限、监控和安全就绪证据。
- $agent-nondeterministic-evaluator 提供离线门禁与在线质量信号。

没有真实部署授权时，只输出决策和操作清单，不声称已经发布、放量、停止或回滚。门禁决策、操作者授权和动作进度分开记录：当前操作者无权不改变已由证据确定的 NO_GO 或 ROLLBACK，只把授权标为 NOT_AUTHORIZED、进度标为实际状态，并立即移交给授权负责人。

## 决策模式

- regression_only：只选择或审核 smoke、core、full 回归。
- pre_release：汇总部署前回归、门禁、审批、监控和回滚证据。
- stage_update：只处理当前灰度或全量阶段的新增指标、异常和确认。
- close_or_rollback：判断发布关闭、停止、回滚和恢复验证。

## 工作流

1. 加载上一 release_snapshot，确认版本类型、变更、影响、风险、窗口和新增事实。
2. 读取 [regression-model.md](references/regression-model.md)，选择 smoke、core 或 full 回归并审核执行证据。
3. 先检查 P0/P1、核心失败、上游 FAIL/BLOCKED/PAUSED、审批、监控、回滚和硬阈值；失败时立即给出阻断动作。
4. 按风险选择全量、灰度或 Hotfix；读取 [release-gates.md](references/release-gates.md) 完成审批、准备和状态映射。涉及 NFR、迁移或 SLO 时读取 [nfr-release.md](references/nfr-release.md)。
5. 仅在真实授权下按批准方式部署；stage_update 只追加当前窗口证据并复用未失效快照。
6. 命中阶段阈值或硬回滚条件时读取 [rollout-rollback.md](references/rollout-rollback.md)，立即停止推进并执行已授权动作。
7. 线上验证、观察、记录和通知全部完成后关闭发布，并将逃逸问题回流测试与监控。

## 不可绕过

- 新增、修改、修复点、影响面、核心流程和 CP0/CP1 场景必须回归。
- 核心流程必须 100% 通过，缺陷严重度 P0/P1 零遗留；无证据不能推定通过。
- 无审批、发布文档、回归证据、回滚方案、值守或监控时不得发布。
- 高风险或影响面大必须灰度；阶段未确认、监控缺失或指标越界时不得放量。
- CONDITIONAL_GO 只适用于已批准的非阻塞风险，必须有补偿、责任人和期限，不能绕过硬门禁。
- 命中硬回滚条件即停止并回滚；若回滚不安全，保持停止并升级事故指挥，不得继续放量。
- Hotfix 先判断配置切换或回滚能否恢复；部署前仍需可追溯授权、回滚方案和测试/产品确认。
- 上游状态和 Agent 在线信号必须按 [release-gates.md](references/release-gates.md) 显式映射，不能静默放行。

## 输出与参考

先给决策、最关键证据、当前阶段和下一动作。状态定义、上游映射、快照字段、灰度增量、结论和回滚记录统一读取 references。

- 回归原则、层级、版本矩阵和准入准出：[regression-model.md](references/regression-model.md)
- 发布方式、审批、状态映射、验证和关闭：[release-gates.md](references/release-gates.md)
- 灰度、Hotfix、硬回滚和恢复：[rollout-rollback.md](references/rollout-rollback.md)
- NFR/SLO、错误预算和阶段阈值：[nfr-release.md](references/nfr-release.md)
- 快照、结论、阶段、回滚和关闭模板：[templates.md](references/templates.md)
