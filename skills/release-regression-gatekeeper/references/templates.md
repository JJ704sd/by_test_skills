# 回归与发布记录模板

## 目录

- [发布快照与跨技能交接](#发布快照与跨技能交接)
- [灰度增量更新](#灰度增量更新)
- [回归与发布结论](#回归与发布结论)
- [灰度阶段记录](#灰度阶段记录)
- [回滚记录](#回滚记录)
- [发布关闭记录](#发布关闭记录)

## 发布快照与跨技能交接

```yaml
handoff_packet:
  packet_version: 1
  producer: release-regression-gatekeeper
  decision_mode: regression_only | pre_release | stage_update | close_or_rollback
  project_version: null
  release_snapshot_id: null
  previous_snapshot_id: null
  upstream_packet_refs: []
  decision: GO | CONDITIONAL_GO | NO_GO | BLOCKED | ROLLBACK | null
  current_stage: null
  reused_evidence: []
  new_evidence_window: null
  invalidated_checks: []
  artifact_refs: []
  blockers_or_triggers: []
  next_action: null
  invalidation_triggers: []
```

`release_snapshot_id` 至少绑定版本包、代码/配置/数据/Agent 清单、回归与上游门禁包、阈值档案、审批、流量规则、监控查询和回滚资产。下一阶段只追加观察窗口和新证据；绑定项变化时显式列入 `invalidated_checks`。

## 灰度增量更新

```markdown
- 决策 / 当前阶段：
- release_snapshot_id / previous_snapshot_id：
- 本次观察窗口与新增样本：
- 新异常或硬触发：
- 复用且未失效的证据：
- 失效并已重验/待重验的门禁：
- 累计关键状态：
- 推进 / 保持 / 停止 / 回滚与负责人：
```

## 回归与发布结论

```markdown
# [项目/版本] 回归与发布结论

## 决策
- 状态：GO / CONDITIONAL_GO / NO_GO / BLOCKED / ROLLBACK
- 上游测试 machine_status：PASS / PASS_WITH_ACCEPTED_RISK / FAIL / PAUSED / BLOCKED
- Agent mode_execution_status / offline_gate / online_quality_signal：
- 关键依据：
- 下一动作、负责人和截止时间：

## 版本与风险
- 版本类型/窗口：日常 / Hotfix / 大版本重构
- 变更与影响：
- 风险与发布方式：全量 / 灰度 / Hotfix

## 回归范围与结果
- 层级：smoke / core / full
- 包含项、排除依据和补偿：
- 用例版本、轮次、计划/执行/通过/失败/阻塞：
- 修复点与影响面：
- defect_severity P0/P1/P2/P3/P4 统计、查询范围/时间与证据：

## 发布门禁
- 测试准出 / 产品验收 / 审批链：
- 版本包、配置、预发布冒烟：
- 灰度、值守、监控和发布群：
- 回滚包/配置、步骤、负责人：

## NFR/SLO 门禁
- nfr_profile / threshold_profile、批准人和版本：
| metric_id/profile_version | source_layer/source_ref | policy_class | 方向/操作符/值/单位 | 聚合/百分位 | 基线/delta 类型 | 窗口/最小样本 | missing_data_policy/action | 当前值/证据 | 状态 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |

## 风险与条件
- 非阻塞遗留项、影响、补偿、责任人、期限：
- 重新判定或回滚条件：
```

## 灰度阶段记录

```markdown
| 阶段 | 流量/样本 | 开始-结束 | 版本/配置/操作人 | 错误/可用性 | 延迟/容量 | Agent/工具/Schema | 数据/安全 | 错误预算 | 反馈/告警/证据 | 测试/运维确认 | 动作 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
```

## 回滚记录

```markdown
# [项目/版本] 回滚记录
- 触发时间、条件和证据：
- 影响范围与异常等级：
- 停止放量时间：
- 稳定版本/配置与操作人：
- 冒烟恢复结果：
- 数据/Schema/权限/安全拒绝及关键 NFR 恢复结果：
- 实际恢复时间、数据恢复点与批准的 RTO/RPO（适用时）：
- 监控观察区间和指标：
- 遗留问题、责任人和重新发布条件：
- 24 小时复盘与用例/监控回流：
```

## 发布关闭记录

```markdown
- 线上核心验证：通过 / 不通过
- 持续观察区间与结论：
- 新增 defect_severity P0/P1：UNKNOWN / [经查询为 0，附范围、时间和证据] / [明细]
- 发布、灰度、异常和验证记录位置：
- 相关人员同步：完成 / 未完成
- 关闭状态与关闭人：
```

最终化前不得残留占位符、无口径阈值或虚构流量/审批/操作人。`UNKNOWN`、监控缺失或阈值记录不完整必须映射为 `BLOCKED` 或保持当前灰度阶段，不能记作零异常。
