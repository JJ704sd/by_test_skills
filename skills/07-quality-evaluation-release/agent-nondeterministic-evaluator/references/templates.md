# Agent 评测契约与模板

## 目录

- [输入契约](#输入契约)
- [用例契约](#用例契约)
- [结果与交接](#结果与交接)
- [报告骨架](#报告骨架)

## 输入契约

```yaml
mode: evaluate | create_baseline | online_monitor
execution_depth: preflight | impacted | required_gate
change_manifest:
  summary: null
  changed_components: []
agent_manifest:
  agent_version: null
  prompt_model_rules_tools_knowledge_schema: []
dataset_manifest:
  version: null
  counts_by_set: {}
  sanitized: false
baseline_report:
  version: null
  comparable: null
threshold_profile:
  version: null
  source_ref: null
  approval_status: APPROVED | UNAPPROVED
  scope: null
  metrics: []
nfr_profile:
  version: null
  source_ref: null
  approval_status: APPROVED | UNAPPROVED | NOT_APPLICABLE
  workload_and_failure_model: null
deterministic_gate:
  machine_status: PASS | PASS_WITH_ACCEPTED_RISK | FAIL | PAUSED | BLOCKED
  agent_relevant_subgate: PASS | FAIL | BLOCKED
  evidence_ref: null
environment_manifest:
  environment: null
  runner_version: null
  retry_policy: null
execution_plan:
  dry_run_case_ids: []
  min_runs: null
  max_runs: null
  escalation_rule: null
  judge_cascade: [exact_schema, deterministic_rule, semantic_rubric, human_review]
```

在线模式还需批准的 release、既有 `offline_gate=PASS`、当前阶段和采样授权。首版基线需说明原因和批准角色。

## 用例契约

```json
{
  "id": "AGENT-001",
  "input": "[sanitized input]",
  "context": [],
  "expected": {},
  "constraints": [],
  "judge": "exact+schema",
  "labels": ["core"],
  "risk": "high",
  "source": "[sanitized source class]",
  "dataset_version": "[version]",
  "sample_policy_ref": "[approved policy]"
}
```

## 结果与交接

```yaml
handoff_packet:
  producer: agent-nondeterministic-evaluator
  mode: evaluate | create_baseline | online_monitor
  execution_depth: preflight | impacted | required_gate
  project_version: null
  snapshot_id: null
  mode_execution_status: COMPLETED | REVIEW_REQUIRED | BLOCKED
  offline_gate: PASS | FAIL | REVIEW_REQUIRED | BLOCKED | null
  baseline_candidate_status: REVIEW_REQUIRED | null
  prior_offline_gate: PASS | null
  online_quality_signal: OK | WATCH | STOP_RECOMMENDED | NOT_APPLICABLE | null
  run_counts:
    planned: null
    valid: null
    technical_failures: null
    semantic_failures: null
  metric_results: []
  failed_case_refs: []
  failure_cluster_refs: []
  manual_review_refs: []
  operational_nfr_results: []
  artifact_refs: []
  blockers: []
  invalidation_triggers: []
```

`snapshot_id` 绑定 Agent 清单、数据集、阈值、环境、runner、Judge、采样和重试。任何绑定项变化时只失效依赖它的缓存和结论。

深度约束：`preflight` 不产生离线门禁；`impacted` 成功不能 `PASS`，但批准计划中的硬失败可 `FAIL`；只有 `required_gate` 可 `PASS`。`online_monitor` 必须引用既有离线 `PASS`，且不生成新离线结论。

## 报告骨架

```markdown
# [Agent/版本] 非确定性评测报告

## 结论
- mode / depth / execution_status：
- offline_gate / baseline_candidate / online_signal：
- 核心依据与发布建议：

## 清单与可比性
- Agent、Prompt、模型、规则、工具、知识库和 Schema：
- 数据集、环境、runner、采样、重试和 Judge：
- 基线可比性、批准、假设和缺口：

## 执行与指标
- 计划/有效运行、技术/语义失败、人工复核：
| 指标 | 分子/分母 | 当前 | 阈值 | 基线 | 点变化 | 相对变化 | 结论 |
| --- | --- | --- | --- | --- | --- | --- | --- |

## 失败与证据
- 高风险逐次结果、失败簇、ND 缺陷和归因假设：
- 在线信号或运行 NFR（适用时）：
- 原始结果、日志、Trace、报告、归档和回流：
```

最终化前不得残留占位符、空阈值档案或虚构批准。未知值使用 `null/UNKNOWN` 并映射到适用的 `REVIEW_REQUIRED` 或 `BLOCKED`；0 结果也需分母、窗口和证据。
