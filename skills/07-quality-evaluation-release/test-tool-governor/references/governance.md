# 工具选型与治理规则

## 决策维度

| 维度 | 必查问题 |
| --- | --- |
| 统一性 | 是否已有合格标准？新方案是否产生重复资产或数据孤岛？ |
| 稳定性 | 维护、文档、依赖、升级和落地证据是否可靠？ |
| 可维护性 | 是否易于协作、调试、Review、升级和定位？ |
| 自动化 | 是否支持批量、失败留痕、统计、报告、基线和 CI/CD？ |
| 适配 | 是否满足协议、平台、规模、Trace、回放、采样和判定？ |
| 成本/迁移 | 许可、设施、培训、脚本/数据迁移和长期成本？ |

安全否决项不能被总分抵消。评分只辅助排序，不能替代硬能力与证据。

## 快速决策

1. 列出 `must_have`、`nice_to_have` 和安全否决项。
2. 检查团队标准的已验证版本；满足全部 `must_have` 时直接复用。
3. 不满足时记录缺口，再比较少量可采购、可部署且许可可行的候选。
4. 候选命中否决项即淘汰；只比较剩余候选的偏好、成本和迁移。
5. 所有时效事实记录来源和 `facts_verified_at`；版本、许可或维护变化时失效。

没有合格候选时直接 `REVIEW_REQUIRED` 或不采用，不为凑数扩大短名单。

## 引入与生命周期

新工具先明确缺口和验收目标，在隔离、非核心范围试用，由责任人评审后再推广。正式采用前补齐使用规则、模板、迁移、培训、维护和退出方案。

- 使用个人账号和最小权限；禁止共享或转借。
- 显式区分环境，配置缺失时失败关闭，不回退生产。
- Secret 使用批准的凭据系统；只保存脱敏值。
- 正式资产进入版本管理并包含断言、配置隔离、Review、报告和 CI。
- 定期核验版本、漏洞和维护状态；替换前完成迁移、回退、通知和归档。
- 一次性调试脚本不直接成为长期标准。

## 决策记录

```markdown
# 测试工具选型记录

## 结论
- selection_decision：采用 / 限定采用 / 不采用 / REVIEW_REQUIRED
- execution_authorization：ALLOWED / BLOCKED / NOT_REQUESTED
- 首选、版本、备选和适用范围：
- 绝对禁止项、限制和失效条件：

## 能力与证据
- 目标、规模、风险、频率和 CI/CD：
- source_ref / approval_status / scope：
- 指标、Oracle、原始证据和现有缺口：
| 候选 | 必需能力 | 稳定/维护 | 自动化 | 成本/迁移 | 安全否决 | 结论 |
| --- | --- | --- | --- | --- | --- | --- |

## 实施与治理
- 环境、账号、权限、Secret、数据和清理：
- 试用、校准、停止/恢复和审计：
- 版本管理、CI、维护人、培训和退出：
```

## 最小交接包

```yaml
handoff_packet:
  producer: test-tool-governor
  decision_depth: reuse_check | selection_record | implementation_plan
  project_version: null
  snapshot_id: null
  selection_decision: null
  execution_authorization: ALLOWED | BLOCKED | NOT_REQUESTED
  selected_tool_and_version: null
  facts_verified_at: null
  artifact_refs: []
  blockers: []
  invalidation_triggers: []
```

`snapshot_id` 绑定能力、规模、团队标准、许可、环境、权限、安全制度和核验日期。采用结论不能推导出执行授权。

最终化前清除占位符、无来源阈值和虚构审批。未知项写 `UNKNOWN` 并使用 `REVIEW_REQUIRED`；安全否决或环境不可信时执行授权为 `BLOCKED`。
