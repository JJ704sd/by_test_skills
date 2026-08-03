# by_test_skills

一组用于软件与 Agent 质量工程的技能包（skill set），按"职责单一、互相交接、机器态可读"的原则拆分。每个技能是一个独立目录，包含主规范 `SKILL.md`、OpenAI Agent 形态的元数据 `agents/openai.yaml`，以及按需查阅的 `references/*.md`。

## 包含的技能

| 技能 | 目录 | 一句话职责 |
|------|------|-----------|
| 测试流程治理 | `test-process-governor` | 编排完整测试，治理功能与通用服务 / API / UI 确定性 NFR 的阶段证据与准出门禁 |
| 测试范围与用例设计 | `test-scope-case-designer` | 界定功能与 NFR 风险范围、量化 SLO、设计可追溯用例 |
| 测试工具选型与治理 | `test-tool-governor` | 按测试目标和 NFR 选择并治理工具、脚本、环境、权限与资产 |
| Agent 非确定性评测 | `agent-nondeterministic-evaluator` | 把 Agent 场景物化为版本化评测集，联合评估技术指标、非确定性语义质量与运行 NFR |
| 版本回归与发布门禁 | `release-regression-gatekeeper` | 选择回归层级，治理全量、灰度、Hotfix 的审批、值守、阶段放量、停止与硬回滚 |

## 技能之间的协作

```
┌──────────────────────┐    范围 + 用例     ┌──────────────────────┐
│ test-scope-case-     │ ─────────────────▶ │ test-process-        │
│ designer             │                    │ governor             │
└──────────────────────┘                    └──────────────────────┘
        │                                          │
        │ 工具 / 环境                              │ 准出证据
        ▼                                          ▼
┌──────────────────────┐                    ┌──────────────────────┐
│ test-tool-governor   │                    │ release-regression-  │
│                      │                    │ gatekeeper           │
└──────────────────────┘                    └──────────────────────┘
                                                       ▲
                                                       │ 离线门禁 / 在线信号
┌──────────────────────┐                                │
│ agent-nondeterministic│ ─────────────────────────────┘
│ -evaluator            │
└──────────────────────┘
```

每个技能只对自己的"准出/决策"负责：

- `test-process-governor` 给出测试阶段准出（中文状态 + 机器态）。
- `test-scope-case-designer` 给出"测什么、测到多深、为什么、怎么判"，不假装执行过。
- `test-tool-governor` 决定"用不用、选哪个、如何安全使用与维护"，不替产品批准 NFR 阈值。
- `agent-nondeterministic-evaluator` 输出 `offline_gate` / `baseline_candidate_status` / `online_quality_signal`，可建议 `STOP_RECOMMENDED` 但不擅自停流量或回滚。
- `release-regression-gatekeeper` 汇总证据，独家负责发布、放量与回滚决策。

## 目录结构

```
.
├── agent-nondeterministic-evaluator/
│   ├── SKILL.md
│   ├── agents/openai.yaml
│   └── references/
│       ├── metrics-and-gates.md
│       ├── online-and-severity.md
│       ├── operational-nfr.md
│       ├── templates.md
│       └── testset-and-methods.md
├── release-regression-gatekeeper/
│   ├── SKILL.md
│   ├── agents/openai.yaml
│   └── references/
│       ├── nfr-release.md
│       ├── regression-model.md
│       ├── release-gates.md
│       ├── rollout-rollback.md
│       └── templates.md
├── test-process-governor/
│   ├── SKILL.md
│   ├── agents/openai.yaml
│   └── references/
│       ├── nfr-evidence.md
│       ├── process-policy.md
│       └── templates.md
├── test-scope-case-designer/
│   ├── SKILL.md
│   ├── agents/openai.yaml
│   └── references/
│       ├── case-design.md
│       ├── nfr-design.md
│       └── scope-policy.md
└── test-tool-governor/
    ├── SKILL.md
    ├── agents/openai.yaml
    └── references/
        ├── governance.md
        ├── nfr-tooling.md
        └── tool-catalog.md
```

## 使用方式

每个技能目录都是自包含的：

1. 入口是 `SKILL.md`（包含 `name` / `description` frontmatter 与正文规范）。
2. `agents/openai.yaml` 提供 OpenAI Agent 形态的 `display_name` / `short_description` / `default_prompt`，可直接挂到支持该规范的 Agent 平台。
3. `references/` 下的子文档由 `SKILL.md` 的"参考文件路由"小节按需引用，避免在主规范里塞过多模板与判据细节。

## 公共约定

- 中文状态与机器态并列给出，且一一映射：`通过 → PASS`、`有条件通过 → PASS_WITH_ACCEPTED_RISK`、`不通过 → FAIL`、`暂停 → PAUSED`、`待补证据 → BLOCKED`。
- 规则冲突时只比较同口径、同适用范围的项目标准；不同口径先阻塞并裁定。
- 任何技能都不得放宽计费、权限、数据安全、安全拒绝等高风险门禁。
- 任何技能都不得伪造未发生的执行结果、批准或证据链接。

## 仓库统计

- 技能数：5
- 文件数：29（5 个 `SKILL.md` + 5 个 `agents/openai.yaml` + 19 个 `references/*.md`）
- 总大小：约 145 KB

## 许可

本仓库内容以 MIT 协议发布，详见 [LICENSE](./LICENSE)。
