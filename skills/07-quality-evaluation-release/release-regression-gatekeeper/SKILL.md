---
name: release-regression-gatekeeper
description: 根据批准范围和风险选择回归层级，消费测试、NFR、Agent、审批、监控与回滚证据，决定 GO、CONDITIONAL_GO、NO_GO、BLOCKED 或 ROLLBACK。用于部署前评审、灰度阶段推进、发布关闭或回滚响应；本技能独占生产放量、停止和回滚决策。
---

# 版本回归与发布门禁

把上游证据转化为回归层级、发布方式、灰度阶段、停止/回滚动作和关闭结论。适用角色批准 NFR/SLO 与风险接受标准；本技能不发明阈值。

决策模式：`regression_only` 只选回归层级；`pre_release` 汇总部署前证据；`stage_update` 只处理当前阶段增量；`close_or_rollback` 判断关闭、停止、回滚和恢复。

## 工作流

1. 加载上一发布快照，确认版本类型、变更、影响、风险、窗口和新增事实。
2. 按 [regression-model.md](references/regression-model.md) 选择 smoke、core 或 full，并审核执行证据。
3. 先检查 P0/P1、核心失败、上游状态、审批、监控、回滚和硬阈值；失败时立即给出阻断动作。
4. 按 [release-gates.md](references/release-gates.md) 选择全量、灰度或 Hotfix；NFR、迁移或 SLO 读取 [nfr-release.md](references/nfr-release.md)。
5. 仅在真实授权下部署；阶段更新只追加当前窗口证据并复用未失效快照。
6. 命中硬条件时按 [rollout-rollback.md](references/rollout-rollback.md) 停止推进并执行已授权动作。
7. 按 [templates.md](references/templates.md) 分开记录决策、操作者授权、动作进度和恢复证据；验证、观察和通知完成后才能关闭。

## 不可绕过

- 变更、修复点、影响面、核心流程和 CP0/CP1 必须回归；核心流程 100% 通过且 P0/P1 零遗留。
- 无审批、发布文档、回归证据、回滚方案、值守或监控时不得发布。
- 高风险或影响面大必须灰度；阶段未确认、监控缺失或指标越界时不得放量。
- `CONDITIONAL_GO` 只适用于已批准的非阻塞风险，不能绕过硬门禁。
- 命中硬回滚条件即停止并回滚；回滚不安全时保持停止并升级事故指挥。
- 上游状态和 Agent 在线信号必须显式映射，不能静默放行。

没有真实部署授权时，只输出决策和操作清单。操作者无权不改变已由证据确定的 `NO_GO` 或 `ROLLBACK`；只把授权和动作进度记录为实际状态。
