# 测试流程输出模板

## 目录

- [证据快照与跨技能交接](#证据快照与跨技能交接)
- [快速门禁答复](#快速门禁答复)
- [阶段台账](#阶段台账)
- [缺陷记录](#缺陷记录)
- [测试报告](#测试报告)

## 证据快照与跨技能交接

同一 `project_version + scope + stage/gate` 只维护一份活动快照，并保留不可覆盖的历史快照。下游直接引用 `snapshot_id`；仅在失效条件命中时重取相关事实。

```yaml
handoff_packet:
  packet_version: 1
  producer: test-process-governor
  delivery_mode: gate_only | stage_packet | full_lifecycle
  project_version: null
  snapshot_id: null
  upstream_packet_refs: []
  decision:
    human_status: null
    machine_status: PASS | PASS_WITH_ACCEPTED_RISK | FAIL | PAUSED | BLOCKED | null
  reused_evidence: []
  changed_facts: []
  completed_checks: []
  artifact_refs: []
  blockers: []
  accepted_risks: []
  next_skill: null
  next_action: null
  invalidation_triggers: []
```

`snapshot_id` 至少绑定版本/build、范围、当前阶段/门禁、需求/变更、范围/用例、环境/配置、阈值配置和证据查询时间。任何绑定项变化时只使受影响结论失效，不自动推翻无关事实。

## 快速门禁答复

```markdown
- delivery_mode：gate_only
- 结论 / machine_status：
- 关键通过证据：
- 首个硬阻塞项：
- 最小补充或整改：
- 责任人 / 重新判定条件：
- snapshot_id / 失效条件：
```

## 阶段台账

```markdown
| 阶段 | 输入/版本 | 必做动作 | 输出与证据 | 责任人 | stage_status | gate_machine_status | 下一门禁 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 需求分析 | | | | | NOT_STARTED/IN_PROGRESS/COMPLETED/BLOCKED | PASS/PASS_WITH_ACCEPTED_RISK/FAIL/PAUSED/BLOCKED/N/A | |
| 测试设计 | | | | | | | |
| 开发与提测 | | | | | | | |
| 版本测试 | | | | | | | |
| 上线与复盘 | | | | | | | |
```

`stage_status` 只表示生命周期进度；`gate_machine_status` 只表示门禁结论。进行中阶段通常使用 `gate_machine_status=N/A`，两者不得相互推导。

## 缺陷记录

```markdown
# [模块] [defect_severity=P0/P1/P2/P3/P4] [可观察的问题]

## 基本信息
- 发现版本/build：
- 测试环境：
- 影响用户/模块/接口/数据：
- 当前状态与责任人：

## 前置条件
1. [账号、数据、权限、配置]

## 复现步骤
1. [操作]
2. [操作]

## 实际结果
[结果、状态码、响应、截图、日志或 Trace ID]

## 期望结果
[可验证的业务或技术判据]

## 修复与回归
- 修复版本：
- 修复影响范围：
- 修复点结果：通过 / 失败 / 阻塞
- 影响面回归结果：
- 证据：
```

## 测试报告

```markdown
# [项目/版本] 测试报告

## 结论
- 当前阶段：
- 测试状态：通过 / 有条件通过 / 不通过 / 暂停 / 待补证据
- machine_status：PASS / PASS_WITH_ACCEPTED_RISK / FAIL / PAUSED / BLOCKED
- 发布建议：交由发布门禁评审 / 暂不交付发布
- 关键依据：

## 范围、版本与环境
- 版本/build、配置、环境、数据：
- 包含项、排除项及理由：
- 测试类型与用例版本：

## 执行结果
- 计划/已执行/通过/失败/阻塞/执行率：
- 冒烟结果：
- 修复点与影响面回归：
- 产品验收：

## NFR 证据（适用时）
- nfr_profile / threshold_profile 版本、批准状态与批准人：
- 指标方向/公式/单位/聚合或百分位/基线/窗口：
- 并发或到达率、Ramp-up、持续时长、故障模型、环境与数据：
| NFR-ID | source_layer/来源版本 | 对象 | 目标/门禁 | 实际值 | 原始证据 | 缺陷/风险 | 结论 |
| --- | --- | --- | --- | --- | --- | --- | --- |

## 缺陷与风险
- defect_severity P0/P1/P2/P3/P4 数量、查询范围、查询时间与证据：
- 遗留项、影响、规避/补偿、责任人、期限：
- 未验证项和假设：

## 证据与下一步
- 用例、缺陷、日志/Trace、报告和审批位置：
- 下一动作、负责人、完成条件：
```

最终化前把所有占位符替换为事实或 `UNKNOWN`；`UNKNOWN` 必须映射到相应的待补证据/阻塞状态。数量为 0 时仍需提供查询范围、时间和证据引用。
