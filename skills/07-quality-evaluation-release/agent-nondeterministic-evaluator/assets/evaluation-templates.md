# Agent 评测产物模板

## 输入与计划

```yaml
mode: evaluate | create_baseline | online_monitor
execution_depth: preflight | impacted | required_gate
agent_manifest:
  version: null
  prompt_model_rules_tools_knowledge_schema: []
agent_case_baseline:
  owner: test-scope-case-designer
  version: null
  approval_status: APPROVED | REVIEW_REQUIRED | BLOCKED
tool_bindings:
  owner: test-execution-governor
  runner_and_judges: []
  authorization_ref: null
dataset_manifest:
  version: null
  case_baseline_version: null
  sanitized: false
threshold_profile:
  version: null
  source_ref: null
  approval_status: APPROVED | UNAPPROVED
  scope: null
  metrics: []
nfr_profile:
  version: null
  approval_status: APPROVED | UNAPPROVED | NOT_APPLICABLE
sampling_profile:
  version: null
  min_runs: null
  max_runs: null
  escalation_and_stop_rules: []
deterministic_gate:
  agent_relevant_subgate: PASS | FAIL | BLOCKED
  evidence_ref: null
environment_manifest: {}
```

## 用例

```json
{
  "id": "[stable id]",
  "input": "[sanitized input]",
  "context": [],
  "expected": {},
  "constraints": [],
  "judge_path": [],
  "labels": [],
  "risk": "[risk]",
  "source_class": "[sanitized class]",
  "dataset_version": "[version]",
  "sampling_profile_ref": "[approved profile]"
}
```

## 结果交接

```yaml
handoff_packet:
  producer: agent-nondeterministic-evaluator
  mode: evaluate | create_baseline | online_monitor
  execution_depth: preflight | impacted | required_gate
  snapshot_id: null
  mode_execution_status: COMPLETED | REVIEW_REQUIRED | BLOCKED
  offline_gate: PASS | FAIL | REVIEW_REQUIRED | BLOCKED | null
  baseline_candidate_status: REVIEW_REQUIRED | null
  online_quality_signal: OK | WATCH | STOP_RECOMMENDED | NOT_APPLICABLE | null
  actor_authorization: AUTHORIZED | NOT_AUTHORIZED | UNKNOWN | null
  run_counts: {}
  metric_results: []
  failed_case_refs: []
  manual_review_refs: []
  artifact_refs: []
  blockers: []
  invalidation_triggers: []
```

报告按“结论；清单与可比性；执行与指标；高风险逐次结果；失败簇与人工复核；在线/NFR 信号；原始证据与回流”组织。指标表记录公式、分子/分母、当前、批准 threshold、基线、绝对/相对变化和结论。
