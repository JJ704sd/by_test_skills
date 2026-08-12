# 发布门禁产物模板

## 阈值记录

```yaml
threshold_profile:
  version: null
  metric_id: null
  metric_definition_and_formula: null
  scope: null
  source_ref: null
  approval_status: APPROVED | UNAPPROVED
  direction_and_operator: null
  value_and_unit: null
  aggregation_or_percentile: null
  baseline_and_delta_type: absolute | percentage_point | relative | not_applicable
  evaluation_window: null
  minimum_sample: null
  missing_data_policy: BLOCK_STAGE | ROLLBACK | ESCALATE
  action: HOLD | NO_GO | ROLLBACK | ESCALATE
  evidence_ref: null
  approved_by: null
```

## 快照与交接

```yaml
handoff_packet:
  producer: release-gatekeeper
  decision_mode: pre_release | stage_update | close_or_rollback
  project_version: null
  release_snapshot_id: null
  previous_snapshot_id: null
  decision: GO | CONDITIONAL_GO | NO_GO | BLOCKED | ROLLBACK
  actor_authorization: AUTHORIZED | NOT_AUTHORIZED | UNKNOWN
  action_progress: NOT_STARTED | REQUESTED | ACKNOWLEDGED | IN_PROGRESS | PARTIAL | COMPLETED | FAILED | UNSAFE | RECOVERY_VERIFIED
  authorization_ref: null
  current_stage: null
  new_evidence_window: null
  artifact_refs: []
  blockers_or_triggers: []
  next_action: null
  invalidation_triggers: []
```

## 阶段更新

```markdown
| 阶段 | 流量/人群/窗口/样本 | 版本/配置/operator | 技术/业务/Agent/数据/安全 | 阈值/告警/证据 | 确认 | 决策/动作 |
| --- | --- | --- | --- | --- | --- | --- |
```

发布结论按“决策、授权与动作；版本/风险/上游证据；threshold/NFR 门禁；阶段与异常；恢复验证；遗留和关闭”组织。回滚记录包含触发、停止、影响、恢复对象、operator、核心/数据/安全/NFR 验证、实际恢复点和重新发布条件。

最终化前不得残留占位符、无口径 threshold、虚构流量/审批/operator 或未完成动作。`UNKNOWN`、监控缺失或 profile 不完整必须 `BLOCKED` 或保持当前阶段。
