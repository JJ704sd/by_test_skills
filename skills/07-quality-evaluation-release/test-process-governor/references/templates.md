# 测试流程输出模板

同一 `project_version + scope + decision_point` 只维护一份活动快照并保留历史。下游引用 `snapshot_id`；绑定项变化时只重验受影响结论。

## 证据快照与交接

```yaml
handoff_packet:
  producer: test-process-governor
  delivery_mode: gate_only | stage_packet | full_lifecycle
  project_version: null
  snapshot_id: null
  upstream_packet_refs: []
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

`snapshot_id` 绑定 build、范围、门禁、用例、环境、配置、阈值和证据时间。门禁、执行进度和生命周期是独立状态轴：`EXECUTION_COMPLETION` 使用 `machine_status=NOT_APPLICABLE`；测试准出必须是 `EXIT_GATE`。

## 快速门禁

```markdown
- 决策点 / machine_status：
- test_execution_status / test_lifecycle_status：
- 关键证据 / 首个硬阻塞：
- 最小整改 / 责任人 / 重新判定条件：
- snapshot_id / 失效条件：
```

## 阶段台账

```markdown
| 阶段 | 版本/输入 | 必做动作 | 输出与证据 | 责任人 | stage_status | gate_status | 下一门禁 |
| --- | --- | --- | --- | --- | --- | --- | --- |
```

没有门禁的阶段使用 `gate_status=NOT_APPLICABLE`；阶段完成不能推导门禁通过。

## 缺陷记录

```markdown
# [模块] [P0-P4] [可观察问题]
- build / 环境 / 影响 / 责任人：
- 前置条件：
- 复现步骤：
- 实际结果与证据：
- 期望判据：
- 修复版本与影响范围：
- 修复点 / 影响面回归：
```

## 测试报告

```markdown
# [项目/版本] 测试报告

## 结论
- decision_point / machine_status：
- execution / lifecycle：
- 关键依据、阻塞与发布交接：

## 范围与执行
- build、配置、环境、数据、范围和用例版本：
- 计划/执行/通过/失败/阻塞：
- 冒烟、修复点、影响面回归和产品验收：

## NFR（适用时）
| NFR | source_ref / approval | 对象/窗口 | 目标 | 实际 | 负载/故障 | 证据 | 结论 |
| --- | --- | --- | --- | --- | --- | --- | --- |

## 缺陷、风险与证据
- P0-P4 数量、查询范围、时间和证据：
- 遗留、补偿、责任人和期限：
- 日志、Trace、报告、审批和下一动作：
```

最终化前用事实或 `UNKNOWN` 替换占位符。已知硬失败/暂停条件优先于未知缺口；数量为 0 仍需查询范围、时间和证据。
