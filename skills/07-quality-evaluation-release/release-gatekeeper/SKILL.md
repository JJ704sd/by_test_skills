---
name: release-gatekeeper
description: 消费已批准的测试、NFR、Agent、审批、监控与恢复证据，决定 GO、CONDITIONAL_GO、NO_GO、BLOCKED 或 ROLLBACK。用于部署前评审、灰度推进、发布关闭或回滚响应；仅本技能拥有生产放量、停止和回滚决策，不定义测试范围或回归层级。
---

# 生产发布门禁

拥有生产放量、停止、回滚和关闭决策。测试范围与层级来自 `$test-scope-case-designer`，确定性准出来自 `$test-execution-governor`，Agent 信号来自 `$agent-nondeterministic-evaluator`；本技能只验证它们仍适用于当前发布快照，不发明阈值。

模式：`pre_release` 汇总部署前证据；`stage_update` 只处理当前阶段增量；`close_or_rollback` 判断关闭、停止、回滚和恢复。

## 工作流

1. 加载快照，固定版本、变更、影响、批准范围、上游门禁、发布/threshold profile、监控、恢复资产和新增事实。
2. 按 [发布门禁](references/release-gates.md) 检查 P0/P1、核心失败、审批、值守、观测与上游状态；硬失败立即给出阻断动作，不重新设计测试范围。
3. NFR、迁移和 SLO 按 [NFR 证据](references/nfr-release.md) 判定；灰度、Hotfix、停止与恢复按 [放量回滚](references/rollout-rollback.md) 执行。
4. 只在真实授权下实施动作；用 [发布模板](assets/release-templates.md) 分开记录 `decision`、`actor_authorization` 和 `action_progress`，阶段更新只追加新窗口证据。

## 不可绕过

- 已批准的核心检查、变更、修复点和影响面必须有可信证据；P0/P1 或定性安全、权限、计费、数据硬失败不得遗留。
- 无测试准出、适用审批、发布/恢复方案、值守、监控或完整 threshold/profile 时不得开始或推进。
- `CONDITIONAL_GO` 只容纳经批准的非阻塞风险；指标缺失、版本漂移、采集失真或阶段未确认时保持 `BLOCKED` 或当前阶段。
- 命中批准的硬回滚规则即停止推进并执行已授权恢复；回滚不安全时保持停止并升级事故指挥。生产不得用于压测、安全扫描或破坏性故障注入。
- 无部署授权时只输出事实决策和操作清单。操作者无权不改变证据已确定的 `NO_GO/ROLLBACK`，未完成动作也不得伪装为已执行或恢复。
