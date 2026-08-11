# 回归与发布记录模板

## 发布快照与交接

```yaml
handoff_packet:
  producer: release-regression-gatekeeper
  decision_mode: regression_only | pre_release | stage_update | close_or_rollback
  project_version: null
  release_snapshot_id: null
  previous_snapshot_id: null
  decision: GO | CONDITIONAL_GO | NO_GO | BLOCKED | ROLLBACK
  actor_authorization: AUTHORIZED | NOT_AUTHORIZED | UNKNOWN
  action_progress: NOT_STARTED | REQUESTED | ACKNOWLEDGED | IN_PROGRESS | PARTIAL | COMPLETED | FAILED | UNSAFE | RECOVERY_VERIFIED
  authorized_operator: null
  current_stage: null
  new_evidence_window: null
  artifact_refs: []
  blockers_or_triggers: []
  next_action: null
  invalidation_triggers: []
```

快照绑定版本包、代码/配置/数据/Agent 清单、上游门禁、阈值、审批、流量、监控和回滚资产。下一阶段只追加新窗口；绑定项变化时显式重验。

`decision`、`actor_authorization` 和 `action_progress` 相互独立。操作者无权不能把事实已确定的 `NO_GO/ROLLBACK` 改成 `BLOCKED`；只有操作证据才能推进动作状态。

## 阶段增量

```markdown
- 决策 / 当前阶段 / 操作者授权 / 动作进度：
- release_snapshot_id / previous_snapshot_id：
- 新观察窗口、样本、异常和硬触发：
- 复用证据 / 失效并待重验项目：
- 下一动作、责任人和重新判定条件：
```

## 回归与发布结论

```markdown
# [项目/版本] 回归与发布结论

## 决策
- 状态 / 授权 / 操作者 / 动作进度：
- 上游测试与 Agent 状态：
- 关键依据 / 下一动作 / 责任人：

## 版本、风险与回归
- 版本类型、窗口、变更、影响和发布方式：
- smoke/core/full、包含/排除、用例版本和轮次：
- 修复点、影响面、P0-P4 查询范围/时间/证据：

## 发布与 NFR 门禁
- 测试准出、验收、审批、版本包、配置和预发布冒烟：
- 灰度、值守、监控、回滚资产和恢复验证：
| metric/source_ref | approval/scope | 公式/阈值 | 窗口/样本 | 当前/基线 | 证据 | 状态 |
| --- | --- | --- | --- | --- | --- | --- |

## 风险与条件
- 已批准遗留、补偿、责任人和期限：
- 重新判定、停止或回滚条件：
```

## 灰度、回滚与关闭

```markdown
| 阶段 | 流量/样本/窗口 | 版本/配置/操作人 | 技术/业务/Agent/数据/安全信号 | 告警/证据 | 确认 | 动作 |
| --- | --- | --- | --- | --- | --- | --- |
```

回滚记录至少包含：决定、授权、触发、停止时间、影响、稳定版本/配置、操作人、核心/数据/安全/NFR 恢复、实际恢复时间、观察区间、遗留项和重新发布条件。

关闭记录至少包含：核心验证、观察结论、新增 P0/P1 查询证据、发布/灰度/异常记录、相关人员同步和关闭人。

最终化前不得残留占位符、无口径阈值或虚构流量/审批/操作人。`UNKNOWN`、监控缺失或阈值不完整必须 `BLOCKED` 或保持当前阶段，不能记作零异常。
