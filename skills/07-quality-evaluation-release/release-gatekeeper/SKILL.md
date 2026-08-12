---
name: release-gatekeeper
description: 消费已批准的测试、NFR、Agent、审批、监控与恢复证据，决定 GO、CONDITIONAL_GO、NO_GO、BLOCKED 或 ROLLBACK。用于部署前评审、灰度推进、发布关闭或回滚响应；仅本技能拥有生产放量、停止和回滚决策，不定义测试范围或回归层级。
---

# 生产发布门禁

把上游证据转化为发布方式、灰度阶段、停止或回滚动作和关闭结论。测试范围与回归层级必须由 `$test-scope-case-designer` 提供，测试准出必须由 `$test-execution-governor` 的 `lifecycle_gate` 模式提供；本技能只验证证据仍适用于当前发布快照。适用角色批准 NFR/SLO 与风险接受标准，本技能不发明阈值。

决策模式：`pre_release` 汇总部署前证据；`stage_update` 只处理当前阶段增量；`close_or_rollback` 判断关闭、停止、回滚和恢复。

## 工作流

1. 加载上一发布快照，确认版本、已批准测试范围、测试准出、变更、影响、风险、窗口和新增事实。
2. 先检查 P0/P1、核心失败、上游状态、审批、监控、恢复资产和硬阈值；失败时立即给出阻断动作，不重新设计回归范围。
3. 按 [release-gates.md](references/release-gates.md) 选择全量、灰度或 Hotfix；NFR、迁移或 SLO 读取 [nfr-release.md](references/nfr-release.md)。
4. 仅在真实授权下部署；阶段更新只追加当前窗口证据并复用未失效快照。
5. 命中硬条件时按 [rollout-rollback.md](references/rollout-rollback.md) 停止推进并执行已授权动作。
6. 按 [templates.md](references/templates.md) 分开记录决策、操作者授权、动作进度和恢复证据；验证、观察和通知完成后才能关闭。

## 不可绕过

- 已批准范围内的变更、修复点、影响面、核心流程和 CP0/CP1 必须有可信回归证据；核心流程 100% 通过且 P0/P1 零遗留。
- 无测试准出、审批、发布文档、恢复方案、值守或监控时不得发布。
- 高风险或影响面大必须灰度；阶段未确认、监控缺失或指标越界时不得放量。
- `CONDITIONAL_GO` 只适用于已批准的非阻塞风险，不能绕过硬门禁。
- 命中硬回滚条件即停止并回滚；回滚不安全时保持停止并升级事故指挥。
- 上游状态和 Agent 在线信号必须显式映射，不能静默放行。

没有真实部署授权时，只输出决策和操作清单。操作者无权不改变已由证据确定的 `NO_GO` 或 `ROLLBACK`；只把授权和动作进度记录为实际状态。
