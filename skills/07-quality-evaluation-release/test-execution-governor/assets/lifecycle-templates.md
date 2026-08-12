# 测试生命周期产物模板

```yaml
handoff_packet:
  producer: test-execution-governor
  mode: lifecycle_gate
  project_version: null
  snapshot_id: null
  upstream_packet_refs: []
  tool_selection_snapshot_ref: null
  execution_authorization: ALLOWED | BLOCKED | NOT_REQUIRED
  authorization_ref: null
  decision_point: ENTRY_GATE | CONTINUE_OR_PAUSE | EXIT_GATE | EXECUTION_COMPLETION | LIFECYCLE_CLOSURE
  machine_status: PASS | PASS_WITH_ACCEPTED_RISK | FAIL | PAUSED | BLOCKED | NOT_APPLICABLE
  test_execution_status: NOT_STARTED | IN_PROGRESS | COMPLETED | PAUSED | BLOCKED
  test_lifecycle_status: OPEN | READY_TO_CLOSE | CLOSED
  artifact_refs: []
  blockers: []
  accepted_risks: []
  next_action: null
  invalidation_triggers: []
```

```markdown
# [项目/版本] 测试报告

## 结论
- decision_point / machine_status / execution / lifecycle：
- 关键依据、阻塞、下一动作和发布交接：

## 范围与执行
- build、配置、环境、数据、范围和用例版本：
- 计划、执行、失败、阻断、冒烟、回归和验收：

## NFR
| NFR | 来源/批准 | 对象/窗口 | threshold/profile | 实际 | 负载/故障 | 证据 | 结论 |
| --- | --- | --- | --- | --- | --- | --- | --- |

## 缺陷、风险与证据
- P0-P4 查询范围、窗口和证据：
- 遗留、补偿、责任人、期限和失效条件：
```

阶段台账可使用：`阶段 | 版本/输入 | 动作 | 证据 | 责任人 | stage_status | gate_status | 下一门禁`。缺陷记录至少包含 build/环境/影响、前置、步骤、实际证据、期望判据、修复版本和影响面回归。
