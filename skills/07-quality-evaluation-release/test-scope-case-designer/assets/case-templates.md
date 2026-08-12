# 用例与范围产物模板

## 用例

```markdown
| 字段 | 内容 |
| --- | --- |
| 用例 ID / 来源 / 版本 | |
| 名称 / 风险 / 优先级 / 类型 | |
| 前置条件 / 环境 / 权限 / 数据 | |
| 步骤与分步预期 | |
| Oracle / 清理 / 证据 | |
| threshold/profile 引用 | |
| 标签 / 依赖 / 失效条件 | |
```

Agent 用例另填上下文、输入意图、关键输出、强制约束、Judge 路径、脱敏来源和 sampling profile 引用。

## 覆盖追踪

```markdown
| 来源 | 对象 | 风险 | 判据 | 类型 | 场景/用例 | 排除/补偿 | 证据 |
| --- | --- | --- | --- | --- | --- | --- | --- |
```

## 交接

```yaml
handoff_packet:
  producer: test-scope-case-designer
  delivery_mode: scope_only | representative_cases | baseline_ready
  project_version: null
  snapshot_id: null
  scope_status: DRAFT | REVIEW_REQUIRED | APPROVED | BLOCKED
  regression_level: null
  agent_case_baseline_ref: null
  artifact_refs: []
  blocking_gaps: []
  approved_exclusions: []
  invalidation_triggers: []
```
