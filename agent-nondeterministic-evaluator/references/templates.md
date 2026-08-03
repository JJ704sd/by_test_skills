# Agent 评测输入输出模板

## 目录

- [输入契约](#输入契约)
- [JSON 用例](#json-用例)
- [输出契约](#输出契约)
- [评测报告](#评测报告)

## 输入契约

```yaml
mode: evaluate | create_baseline | online_monitor
change_manifest:
  summary:
  changed_components: []
agent_manifest:
  agent_version:
  prompt_version:
  model_and_parameters:
  rule_version:
  tool_definition_version:
  knowledge_base_version:
  output_schema_version:
dataset_manifest:
  version:
  counts_by_set:
  sanitized: true | false
baseline_report:
  version: null
  comparable: true | false | null
threshold_profile:
  version: null
  approval_status: APPROVED | UNAPPROVED
  approved_by: null
  metrics: []
nfr_profile:
  version: null
  source_layer: primary_spec | cross_spec | project_approved | governance_enhancement | null
  source_refs: []
  approval_status: APPROVED | UNAPPROVED | NOT_APPLICABLE
  workload_and_failure_model: null
  metrics: []
deterministic_gate_record:
  machine_status: PASS | PASS_WITH_ACCEPTED_RISK | FAIL | PAUSED | BLOCKED
  agent_relevant_subgate: PASS | FAIL | BLOCKED
  evidence: null
  accepted_risks: []
# accepted_risks 项字段：id、approval_ref、impact_on_agent_evaluation（NONE/RELATED/UNKNOWN）、owner、due_at
environment_manifest:
  environment:
  runner_version:
  retry_policy:
mode_inputs:
  evaluate:
    baseline_report_version: null
  create_baseline:
    reason: null
    proposed_approvers: []
  online_monitor:
    approved_release_id: null
    prior_offline_gate: PASS | null
    rollout_stage: null
    sampling_approval: null
```

## JSON 用例

```json
{
  "example_only": true,
  "id": "AGENT-EXTRACT-001",
  "input": "[脱敏输入]",
  "context": [],
  "expected_parse": {"field": "[已批准期望值]"},
  "expected_fields": {"schema": "[版本化 Schema ID]"},
  "constraints": ["[批准的业务或安全约束]"],
  "judge": "exact+schema",
  "labels": ["core", "entity", "regression"],
  "risk": "high",
  "source": "[脱敏来源类别]",
  "dataset_version": "[版本]",
  "sample_policy_ref": "[批准策略或规范默认策略]"
}
```

## 输出契约

```yaml
run_manifest:
sample_policy:
technical_results:
  planned_runs:
  valid_runs:
  technical_failures:
semantic_metrics:
  metric_name:
    numerator:
    denominator:
    value:
    confidence_interval:
    threshold:
    baseline:
    percentage_point_delta:
    relative_delta:
    status:
failed_cases: []
manual_review_evidence: []
nd_defects: []
mode_result:
  mode_execution_status: COMPLETED | REVIEW_REQUIRED | BLOCKED
  offline_gate: PASS | FAIL | REVIEW_REQUIRED | BLOCKED | null
  baseline_candidate_status: REVIEW_REQUIRED | null
  prior_offline_gate: PASS | null
online_quality_signal: OK | WATCH | STOP_RECOMMENDED | NOT_APPLICABLE | null
operational_nfr_results: []
handoff_to_release:
feedback_candidates: []
```

## 评测报告

```markdown
# [Agent/版本] 非确定性评测报告

## 门禁结论
- 模式：evaluate / create_baseline / online_monitor
- Mode execution：COMPLETED / REVIEW_REQUIRED / BLOCKED
- evaluate Offline gate：PASS / FAIL / REVIEW_REQUIRED / BLOCKED / N/A
- create_baseline candidate：REVIEW_REQUIRED / N/A
- online_monitor prior Offline gate 引用：PASS / N/A（非 PASS 时本模式 BLOCKED）
- Online signal：OK / WATCH / STOP_RECOMMENDED / N/A
- 核心依据与发布门禁建议：

## 运行清单
- 候选与基线版本：
- Prompt/模型参数/规则/工具/知识库/Schema：
- 测试集、环境、脚本、采样和重试：
- 可比性、假设和缺失证据：

## 技术与语义执行
- 计划/有效运行、技术失败、语义失败：
- 人工抽检数量、选择方式和覆盖维度：
- 专项测试及频率状态：

## 指标
| 维度 | 分子/分母 | 当前值 | 阈值 | 基线 | 点变化 | 相对变化 | 结论 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 实体抽取 | | | | | | | |
| 单位归一化 | | | | | | | |
| 计算正确性 | | | | | | | |
| 指令/约束 | | | | | | | |
| 推荐合理性 | | | | | | | |
| 输出格式 | | | | | | | |
| 鲁棒性 | | | | | | | |
| 一致性差异 | | | | | | | |
| 幻觉 | | | | | | | |
| 安全拒绝 | | | | | | | |

## 失败、缺陷与归因
- 通用缺陷 / ND-P0-P3：
- 失败样本、Trace、人工复核：
- 归因假设、责任人和验证计划：

## 在线质量（如适用）
- 请求/解析成功率、用户修正率、负面反馈、延迟、工具/Schema 异常：
- 样本量、观察时长和停止信号：

## 运行 NFR（如适用）
- nfr_profile 版本、source_layer/具体来源、批准、负载/故障、环境和基线：
- 端到端/模型/检索/工具延迟、吞吐/并发、技术成功、降级/恢复：
- 负载/故障下语义质量、安全、Schema、Token/成本和证据：

## 归档与回流
- 归档位置：
- 新增核心/增量/鲁棒/对抗/长尾用例：
- 给发布门禁的交接：
```

最终化前不得残留占位符、空阈值档案或虚构批准。未知值使用 `null/UNKNOWN` 并触发 `REVIEW_REQUIRED` 或 `BLOCKED`；每个 0 结果也必须带分母、窗口和证据。
