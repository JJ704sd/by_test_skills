# Skills 分布与职责边界

更新日期：2026-08-10
统计范围：`skills/<scenario>/<skill-name>/`

## 总览

| 指标 | 数量 |
| --- | ---: |
| 场景组 | 8 |
| 技能目录 / `SKILL.md` | 25 |
| `agents/openai.yaml` | 25 |

场景编号表达推荐浏览顺序，不是强制流水线。可以从任一场景进入、跳过不适用阶段，也可以在证据不足时回到前一阶段。安装或复用时复制完整的技能目录。

```text
01 配置与路由
  → 02 调研与建模
  → 03 澄清与规划
  → 04 规格与工作管理
  → 05 设计与原型
  → 06 实现与诊断
  → 07 质量、评估与发布
  → 08 协作与赋能（可在任意阶段使用）
```

## 01 配置与路由（2）

目录：`skills/01-onboarding-routing/`

| 技能 | 主要职责 |
| --- | --- |
| [`configure-engineering-skills`](../skills/01-onboarding-routing/configure-engineering-skills/SKILL.md) | 一次性配置 issue tracker、triage 标签和领域文档约定 |
| [`route-engineering-work`](../skills/01-onboarding-routing/route-engineering-work/SKILL.md) | 根据当前状态选择最小技能或工作流，不复述各技能内部流程 |

## 02 调研与建模（2）

目录：`skills/02-research-modeling/`

| 技能 | 主要职责 |
| --- | --- |
| [`research`](../skills/02-research-modeling/research/SKILL.md) | 从高可信一手来源调查可查证事实并沉淀引用 |
| [`domain-modeling`](../skills/02-research-modeling/domain-modeling/SKILL.md) | 澄清领域语言、维护 glossary，并按需记录 ADR |

## 03 澄清与规划（3）

目录：`skills/03-clarification-planning/`

| 技能 | 主要职责 |
| --- | --- |
| [`grilling`](../skills/03-clarification-planning/grilling/SKILL.md) | 用轮次和 decision frontier 压力测试计划、决策或设计；按需组合领域文档模式 |
| [`to-questionnaire`](../skills/03-clarification-planning/to-questionnaire/SKILL.md) | 将另一个人持有的私有知识转成异步 discovery questionnaire |
| [`wayfinder`](../skills/03-clarification-planning/wayfinder/SKILL.md) | 将跨会话且路线未知的工作建模为 decision-ticket 地图 |

关键边界：`wayfinder` 发现“要决定什么”；`to-tickets` 在路线已知后拆“要实现什么”。

## 04 规格与工作管理（3）

目录：`skills/04-specs-work-management/`

| 技能 | 主要职责 |
| --- | --- |
| [`to-spec`](../skills/04-specs-work-management/to-spec/SKILL.md) | 把已经解决的讨论综合成父规格，不继续开放式访谈 |
| [`to-tickets`](../skills/04-specs-work-management/to-tickets/SKILL.md) | 将已知计划拆成可独立验证、带阻塞边的实现票 |
| [`triage`](../skills/04-specs-work-management/triage/SKILL.md) | 分类和验证外部流入的原始 issue/PR，并形成 durable brief |

关键边界：`triage` 不处理 `$to-tickets` 已生成的实现票；这些票已经是 agent-ready 工作。

## 05 设计与原型（3）

目录：`skills/05-design-prototyping/`

| 技能 | 主要职责 |
| --- | --- |
| [`codebase-design`](../skills/05-design-prototyping/codebase-design/SKILL.md) | 为已选模块设计或比较 interface、seam、adapter 和 depth |
| [`review-codebase-architecture`](../skills/05-design-prototyping/review-codebase-architecture/SKILL.md) | 扫描代码库、排序架构深化候选并生成可视报告 |
| [`prototype`](../skills/05-design-prototyping/prototype/SKILL.md) | 用一次性逻辑或 UI 原型回答一个设计问题 |

关键边界：architecture review 找候选；codebase design 设计已经选中的候选；prototype 用可运行工件验证尚难在纸面确定的问题。

## 06 实现与诊断（4）

目录：`skills/06-implementation-debugging/`

| 技能 | 主要职责 |
| --- | --- |
| [`tdd`](../skills/06-implementation-debugging/tdd/SKILL.md) | 对已知行为执行 red-green-refactor 的测试先行实现 |
| [`diagnosing-bugs`](../skills/06-implementation-debugging/diagnosing-bugs/SKILL.md) | 为根因未知的复杂缺陷、flake、回归或性能下降建立证据回路并定位根因 |
| [`resolving-merge-conflicts`](../skills/06-implementation-debugging/resolving-merge-conflicts/SKILL.md) | 按双方原始意图处理进行中的 merge/rebase 冲突 |
| [`review-code-against-spec`](../skills/06-implementation-debugging/review-code-against-spec/SKILL.md) | 从仓库 Standards 与原始 Spec 两个独立轴审查 diff |

普通实现使用 Codex 默认能力，不需要独立 `implement` 技能。根因未知先诊断；行为和预期已知且用户要求 test-first 时使用 TDD。

## 07 质量、评估与发布（5）

目录：`skills/07-quality-evaluation-release/`

| 技能 | 决策权 | 典型产物 |
| --- | --- | --- |
| [`test-scope-case-designer`](../skills/07-quality-evaluation-release/test-scope-case-designer/SKILL.md) | 测什么、测多深、用什么判据 | 风险范围、覆盖矩阵、NFR 模型、用例基线 |
| [`test-tool-governor`](../skills/07-quality-evaluation-release/test-tool-governor/SKILL.md) | 选择什么工具、环境和安全治理方式 | 复用结论、选型记录、实施与退出计划 |
| [`test-process-governor`](../skills/07-quality-evaluation-release/test-process-governor/SKILL.md) | build 是否进入/离开测试阶段 | 阶段台账、测试准入/准出、证据交接 |
| [`agent-nondeterministic-evaluator`](../skills/07-quality-evaluation-release/agent-nondeterministic-evaluator/SKILL.md) | Agent 采样、基线、语义质量和漂移信号 | 版本化评测集、离线门禁、在线质量信号 |
| [`release-regression-gatekeeper`](../skills/07-quality-evaluation-release/release-regression-gatekeeper/SKILL.md) | 是否发布、放量、停止、回滚或关闭 | GO/NO_GO/BLOCKED/ROLLBACK 与阶段动作 |

推荐链路：

```text
范围与用例 → 工具与环境 → 测试过程 → Agent 专项评测（按需）→ 回归与发布门禁
```

五个技能不能互相越权：范围技能不批准阈值，流程技能不决定生产流量，Agent evaluator 只能给质量信号，发布技能才拥有放量和回滚动作。

## 08 协作与赋能（3）

目录：`skills/08-collaboration-enablement/`

| 技能 | 主要职责 |
| --- | --- |
| [`run-learning-workspace`](../skills/08-collaboration-enablement/run-learning-workspace/SKILL.md) | 建立或继续持久化、多会话学习工作区 |
| [`handoff`](../skills/08-collaboration-enablement/handoff/SKILL.md) | 将当前状态压缩成可移植且脱敏的 Agent 交接文档 |
| [`wizard`](../skills/08-collaboration-enablement/wizard/SKILL.md) | 为只能由人完成的配置、凭据或迁移步骤生成交互式向导 |

## 关键选择边界

| 如果问题是…… | 使用 | 不使用 |
| --- | --- | --- |
| 当前用户需要实时做决策 | `grilling` | `to-questionnaire` |
| 另一个人掌握无法公开查到的信息 | `to-questionnaire` | `research` |
| 路线未知，需要发现决策 | `wayfinder` | `to-tickets` |
| 路线已知，需要实现切片 | `to-tickets` | `wayfinder` |
| 扫描整个仓库找架构候选 | `review-codebase-architecture` | `codebase-design` |
| 已选模块，需要设计接口 | `codebase-design` | architecture review |
| 根因未知，需要证据 | `diagnosing-bugs` | `tdd` |
| 行为已知，明确 test-first | `tdd` | diagnosing |
| build 是否完成测试 | `test-process-governor` | release gatekeeper |
| 是否改变生产流量 | `release-regression-gatekeeper` | test process governor |

## 2026-08 精简迁移

| 旧名称 | 新入口 |
| --- | --- |
| `ask-matt` | `route-engineering-work` |
| `setup-matt-pocock-skills` | `configure-engineering-skills` |
| `grill-me` | `grilling` 默认模式 |
| `grill-with-docs` | `grilling` documented 模式 + `domain-modeling` |
| `improve-codebase-architecture` | `review-codebase-architecture` |
| `code-review` | `review-code-against-spec`，并移动到 06 场景 |
| `teach` | `run-learning-workspace` |
| `implement` | 默认实现能力；test-first 使用 `tdd` |
| `wait-what` | 普通重新解释请求，不需要技能 |
| `writing-for-agents` | 系统 `skill-creator` 或普通 Agent 指令编辑 |

完整设计理由见 [Skills 精简与整理设计规范](skill-simplification-spec.md)。

## 资源与维护边界

1. `SKILL.md` 只保留每次调用都需要的核心流程和硬约束。
2. `references/` 保存按分支读取的规则、方法和字段契约。
3. `assets/` 保存复制或改造成输出的模板与脚手架。
4. `scripts/` 保存需要实际运行和测试的确定性帮助程序。
5. 技能根目录不放配套文件；所有 reference 从 `SKILL.md` 一层直达。
6. 新增、删除、移动或改变技能职责时，同步更新本页、README 和校验预算。
7. 提交前运行 `pwsh -File scripts/Test-Skills.ps1` 和 `git diff --check`。
