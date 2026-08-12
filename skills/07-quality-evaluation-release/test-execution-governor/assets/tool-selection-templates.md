# 工具选型产物模板

```markdown
# 测试工具选型记录

## 结论
- selection_decision / execution_authorization / implementation_progress / authorization_ref：
- 选择、版本、范围、限制和失效条件：

## 能力与证据
- 目标、规模、风险、频率和 CI/CD：
- source_ref / approval_status / scope / facts_verified_at：
| 候选 | 必需能力 | 维护 | 自动化 | 成本/迁移 | 安全否决 | 结论 |
| --- | --- | --- | --- | --- | --- | --- |

## 落地与治理
- 环境、身份、权限、Secret、数据和清理：
- 试用、校准、停止/恢复、版本管理、维护和退出：
```

```yaml
handoff_packet:
  producer: test-execution-governor
  mode: tool_selection
  decision_depth: reuse_check | selection_record | implementation_plan
  project_version: null
  snapshot_id: null
  selection_decision: null
  execution_authorization: ALLOWED | BLOCKED | NOT_REQUESTED
  implementation_progress: NOT_STARTED | PLANNED | IN_PROGRESS | COMPLETED | BLOCKED | NOT_REQUESTED | UNKNOWN
  authorization_ref: null
  selected_tool_and_version: null
  facts_verified_at: null
  artifact_refs: []
  blockers: []
  invalidation_triggers: []
```
