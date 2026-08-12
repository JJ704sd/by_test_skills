# Skills 分布与职责边界

更新日期：2026-08-12
统计范围：`skills/<scenario>/<skill-name>/`

## 总览

| 指标 | 数量 |
| --- | ---: |
| 场景组 | 7 |
| Skill 目录 / `SKILL.md` | 16 |
| `agents/openai.yaml` | 16 |

场景编号只是浏览顺序，不是强制流水线。场景包是推荐组合而非严格依赖闭包；未安装的可选后继回退到 Codex 普通能力，只有 skill 正文明确声明的前置配置才是硬依赖。

```text
01 仓库配置 → 02 领域建模 → 03 人员输入 → 04 持久化规划
             → 05 代码库设计 → 06 实现与诊断 → 07 质量与发布
```

## 01 仓库配置（1）

目录：`skills/01-repository-setup/`

| Skill | 职责 |
| --- | --- |
| [`configure-engineering-skills`](../skills/01-repository-setup/configure-engineering-skills/SKILL.md) | 探测并一次性配置 tracker、triage 标签和领域文档布局；preview-confirm-write |

## 02 领域建模（1）

目录：`skills/02-domain-modeling/`

| Skill | 职责 |
| --- | --- |
| [`domain-modeling`](../skills/02-domain-modeling/domain-modeling/SKILL.md) | 维护 canonical vocabulary，并只为已解决、难逆的决策写 ADR |

公开一手来源调查与 cited note 使用 Codex 默认能力。

## 03 人员输入（1）

目录：`skills/03-stakeholder-elicitation/`

| Skill | 模式 | 职责 |
| --- | --- | --- |
| [`elicit-stakeholder-input`](../skills/03-stakeholder-elicitation/elicit-stakeholder-input/SKILL.md) | `live` | 与当前用户按 decision frontier 逐轮澄清不可发现的判断 |
| 同上 | `async` | 为另一知识持有人生成可异步回收的问卷 |

可从仓库或公开来源发现的事实直接调查；不能把事实检索包装成人工访谈。两个模式不能静默切换。

## 04 持久化规划与分流（2）

目录：`skills/04-tracker-work-management/`

| Skill | 模式 / 职责 |
| --- | --- |
| [`plan-engineering-work`](../skills/04-tracker-work-management/plan-engineering-work/SKILL.md) | `map` 为未知路线建决策图；`spec` 发布已定案父规格；`slice` 拆分已批准的纵向实现票 |
| [`triage`](../skills/04-tracker-work-management/triage/SKILL.md) | 验证外部流入的原始 issue/PR，维护分类和状态，并在维护者确认后形成 durable brief |

规划 skill 一次只执行一个模式，不自动推进整个生命周期。Triage 独立保留，因为外部流入、AI 声明、维护者确认和标签状态机不同于内部已批准规划。

## 05 代码库设计（1）

目录：`skills/05-codebase-design/`

| Skill | 模式 | 职责 |
| --- | --- | --- |
| [`codebase-design`](../skills/05-codebase-design/codebase-design/SKILL.md) | `scan` | 扫描仓库或广域子系统，排序架构深化候选并输出可视报告 |
| 同上 | `design` | 为一个已选区域比较接口、seam、adapter、dependency 和 trust boundary |

`scan` 只发现候选并停止；必须由新的用户请求选中区域后才能进入 `design`。一次性逻辑或 UI 原型使用 Codex 默认实现能力。

## 06 实现与诊断（6）

目录：`skills/06-implementation-debugging/`

| Skill | 职责 |
| --- | --- |
| [`tdd`](../skills/06-implementation-debugging/tdd/SKILL.md) | 对已知行为或已验证修复执行 red-green-refactor |
| [`refactoring-safely`](../skills/06-implementation-debugging/refactoring-safely/SKILL.md) | 用绿色基线、不变量和可逆迁移波证明行为保全 |
| [`evolving-contracts`](../skills/06-implementation-debugging/evolving-contracts/SKILL.md) | 用兼容矩阵和阶段门禁管理非原子的新旧版本共存 |
| [`diagnosing-bugs`](../skills/06-implementation-debugging/diagnosing-bugs/SKILL.md) | 用可证伪假设定位未知失败、flaky 或性能瓶颈，默认停在诊断 |
| [`review-code-against-spec`](../skills/06-implementation-debugging/review-code-against-spec/SKILL.md) | 对固定 diff 分别审查仓库标准与原始 spec，只报告发现 |
| [`resolving-merge-conflicts`](../skills/06-implementation-debugging/resolving-merge-conflicts/SKILL.md) | 在活跃 merge/rebase 中重建双方意图并由单一 resolver 写入 |

这些入口不能按“都修改代码”合并：诊断与 TDD 的修改授权不同；重构证明行为不变，契约演进则必须验证旧态、混合态、新态和恢复。

## 07 质量、评测与发布（4）

目录：`skills/07-quality-evaluation-release/`

| Skill | 决策权 | 典型产物 |
| --- | --- | --- |
| [`test-scope-case-designer`](../skills/07-quality-evaluation-release/test-scope-case-designer/SKILL.md) | 风险范围、回归层级、判据和用例意图 | scope packet、case baseline |
| [`test-execution-governor`](../skills/07-quality-evaluation-release/test-execution-governor/SKILL.md) | `tool_selection` 选择执行能力；`lifecycle_gate` 判断确定性测试阶段 | tool packet、EXIT_GATE snapshot |
| [`agent-nondeterministic-evaluator`](../skills/07-quality-evaluation-release/agent-nondeterministic-evaluator/SKILL.md) | 物化 Agent 数据集、重复采样、语义质量和漂移信号 | dataset manifest、offline gate、online signal |
| [`release-gatekeeper`](../skills/07-quality-evaluation-release/release-gatekeeper/SKILL.md) | 生产发布、放量、停止和回滚 | GO/NO_GO/BLOCKED/ROLLBACK |

```text
范围、用例与回归层级 → 执行能力与测试准出 → Agent 专项评测（按需）→ 生产发布门禁
```

工具选择、执行授权、测试门禁、执行进度和生命周期状态互不推定。Scope 不批准自己的业务阈值；Agent evaluator 不决定生产流量；release 只消费上游证据，不重定义范围或生成语义评测。

## 关键选择边界

| 问题 | 使用 | 不使用 |
| --- | --- | --- |
| 当前用户持有不可发现的判断 | `elicit-stakeholder-input: live` | async questionnaire |
| 另一人持有私有上下文 | `elicit-stakeholder-input: async` | live interview |
| 路线未知，需要决策图 | `plan-engineering-work: map` | slice |
| 讨论已定，需要父规格 | `plan-engineering-work: spec` | map |
| 路线已批准，需要实现切片 | `plan-engineering-work: slice` | triage |
| 原始外部 issue/PR | `triage` | planning modes |
| 广域发现架构候选 | `codebase-design: scan` | design |
| 已选模块需要接口设计 | `codebase-design: design` | scan |
| 根因未知 | `diagnosing-bugs` | tdd |
| 行为已知且要求 test-first | `tdd` | diagnosing |
| 外部行为不变 | `refactoring-safely` | evolving contracts |
| 新旧状态必须共存 | `evolving-contracts` | refactoring |
| 选择 smoke/core/full | `test-scope-case-designer` | release gatekeeper |
| 工具选型或 build 测试准出 | `test-execution-governor` | release gatekeeper |
| 改变生产流量 | `release-gatekeeper` | evaluator |

## 2026-08 收敛记录

当前审计把 27 个入口收敛为 16 个：

- 删除默认能力薄包装：`route-engineering-work`、`research`、`handoff`、`prototype`。
- 移出主题外扩展：`run-learning-workspace`、`wizard`。
- `grilling` + `to-questionnaire` → `elicit-stakeholder-input`。
- `wayfinder` + `to-spec` + `to-tickets` → `plan-engineering-work`。
- `review-codebase-architecture` → `codebase-design: scan`。
- `test-tool-governor` + `test-process-governor` → `test-execution-governor`。
- `release-regression-gatekeeper` 收窄并更名为 `release-gatekeeper`；回归层级归测试范围。

历史理由见 [第一轮精简记录](skill-simplification-spec.md) 与 [第二轮针对性精简记录](targeted-skill-simplification-spec.md)。开发 skill 的 graph、evidence loop、checkpoint 与安全并行约束见 [开发场景编排提效规范](development-orchestration-efficiency-spec.md)。

## 维护边界

1. `SKILL.md` 只保留模式选择、共同流程和硬约束；分支细节一层直达。
2. 新模式必须复用现有意图和授权面；否则创建独立 skill。
3. 新增、删除、移动或改名时同步更新本页、README、校验数量、退休调用和预算。
4. 提交前运行 `pwsh -File scripts/Test-Skills.ps1` 与 `git diff --check`。
