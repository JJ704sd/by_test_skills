# Skills 分布与职责边界

更新日期：2026-08-10

统计范围：`skills/<scenario>/<skill-name>/`

## 总览

| 指标 | 数量 |
| --- | ---: |
| 场景包 | 8 |
| 技能目录 / `SKILL.md` | 30 |
| `agents/openai.yaml` | 30 |
| `references/` 内文件 | 19 |
| `scripts/` 内文件 | 1 |
| 其他技能配套文件 | 23 |
| 技能集合总文件数 | 103 |

所有技能采用 `skills/<scenario>/<skill-name>/SKILL.md` 作为入口，并配有 OpenAI Agent 元数据。场景目录的两位编号表达推荐浏览顺序；它们只负责导航和打包，不改变技能的独立性。安装或复用时，应复制完整的 `<skill-name>/` 目录。

## 使用路径

```text
01 入口与路由
  → 02 调研与建模
  → 03 澄清与规划
  → 04 规格与工作管理
  → 05 设计与原型
  → 06 实现与诊断
  → 07 质量、评估与发布
  → 08 协作与赋能
```

场景编号不是强制流程。可以从任一场景进入、跳过不需要的阶段，也可以在发现信息不足时返回前一阶段。`ask-matt` 负责入口路由，`handoff` 可在任意阶段用于收尾交接。

## 01 入口与路由（2）

目录：`skills/01-onboarding-routing/`

| 技能 | 主要职责 |
| --- | --- |
| [`setup-matt-pocock-skills`](../skills/01-onboarding-routing/setup-matt-pocock-skills/SKILL.md) | 首次使用工程技能前配置 issue 跟踪器、标签体系与领域文档布局 |
| [`ask-matt`](../skills/01-onboarding-routing/ask-matt/SKILL.md) | 根据当前情境路由到合适的工程技能或工作流 |

## 02 调研与建模（2）

目录：`skills/02-research-modeling/`

| 技能 | 主要职责 |
| --- | --- |
| [`research`](../skills/02-research-modeling/research/SKILL.md) | 基于高可信一手来源调查事实并在仓库沉淀结论 |
| [`domain-modeling`](../skills/02-research-modeling/domain-modeling/SKILL.md) | 建立统一领域语言、上下文和架构决策记录 |

## 03 澄清与规划（5）

目录：`skills/03-clarification-planning/`

| 技能 | 主要职责 |
| --- | --- |
| [`grilling`](../skills/03-clarification-planning/grilling/SKILL.md) | 通过高强度追问压力测试计划、决策或想法 |
| [`grill-me`](../skills/03-clarification-planning/grill-me/SKILL.md) | `grilling` 的轻量入口，用访谈打磨计划或设计 |
| [`grill-with-docs`](../skills/03-clarification-planning/grill-with-docs/SKILL.md) | 在追问过程中同步沉淀 ADR 和术语表 |
| [`to-questionnaire`](../skills/03-clarification-planning/to-questionnaire/SKILL.md) | 将当前无法回答的决策转换为可交给他人填写的问卷 |
| [`wayfinder`](../skills/03-clarification-planning/wayfinder/SKILL.md) | 将超出单次会话容量的大型工作拆成共享决策地图 |

## 04 规格与工作管理（3）

目录：`skills/04-specs-work-management/`

| 技能 | 主要职责 |
| --- | --- |
| [`to-spec`](../skills/04-specs-work-management/to-spec/SKILL.md) | 把已有讨论直接综合成规格并发布到项目跟踪器 |
| [`to-tickets`](../skills/04-specs-work-management/to-tickets/SKILL.md) | 将计划或规格拆成带阻塞边的 tracer-bullet 工单 |
| [`triage`](../skills/04-specs-work-management/triage/SKILL.md) | 对 issue 和外部 PR 分类、验证并生成 Agent 可执行简报 |

## 05 设计与原型（3）

目录：`skills/05-design-prototyping/`

| 技能 | 主要职责 |
| --- | --- |
| [`codebase-design`](../skills/05-design-prototyping/codebase-design/SKILL.md) | 设计深模块、接口边界、可测试性与 Agent 可导航性 |
| [`improve-codebase-architecture`](../skills/05-design-prototyping/improve-codebase-architecture/SKILL.md) | 扫描架构深化机会，生成可视报告并引导决策 |
| [`prototype`](../skills/05-design-prototyping/prototype/SKILL.md) | 用一次性原型验证状态模型、逻辑或 UI 方向 |

## 06 实现与诊断（4）

目录：`skills/06-implementation-debugging/`

| 技能 | 主要职责 |
| --- | --- |
| [`implement`](../skills/06-implementation-debugging/implement/SKILL.md) | 根据规格或工单完成实现 |
| [`tdd`](../skills/06-implementation-debugging/tdd/SKILL.md) | 以红—绿—重构循环测试驱动开发功能或修复 |
| [`diagnosing-bugs`](../skills/06-implementation-debugging/diagnosing-bugs/SKILL.md) | 诊断复杂缺陷和性能退化，循环收集证据 |
| [`resolving-merge-conflicts`](../skills/06-implementation-debugging/resolving-merge-conflicts/SKILL.md) | 处理进行中的 merge/rebase 冲突 |

## 07 质量、评估与发布（6）

目录：`skills/07-quality-evaluation-release/`

| 技能 | 主要职责 | 典型产物 |
| --- | --- | --- |
| [`test-scope-case-designer`](../skills/07-quality-evaluation-release/test-scope-case-designer/SKILL.md) | 从需求、变更、事故和风险中设计测试范围、NFR 与用例 | 范围矩阵、边界用例、NFR 工作负载模型 |
| [`test-tool-governor`](../skills/07-quality-evaluation-release/test-tool-governor/SKILL.md) | 选择并治理功能、性能、可靠性、安全和 Agent 评测工具 | 工具决策、环境与证据治理方案 |
| [`test-process-governor`](../skills/07-quality-evaluation-release/test-process-governor/SKILL.md) | 编排功能测试及通用确定性 NFR 的端到端测试过程 | 阶段门禁、执行证据、准入/准出判断 |
| [`agent-nondeterministic-evaluator`](../skills/07-quality-evaluation-release/agent-nondeterministic-evaluator/SKILL.md) | 对 Agent 技术指标和非确定性语义质量进行采样、基线与漂移评测 | 版本化评测集、指标、离线门禁与漂移结论 |
| [`code-review`](../skills/07-quality-evaluation-release/code-review/SKILL.md) | 从仓库规范和原始规格两个维度审查变更 | Standards / Spec 双轴审查结果 |
| [`release-regression-gatekeeper`](../skills/07-quality-evaluation-release/release-regression-gatekeeper/SKILL.md) | 汇总回归证据并治理发布、灰度、停止和回滚 | GO/CONDITIONAL_GO/NO_GO/BLOCKED 决策 |

推荐链路：`范围与用例 → 工具与环境 → 测试过程 → Agent 专项评估（按需） → 代码审查（按需） → 回归发布门禁`。

## 08 协作与赋能（5）

目录：`skills/08-collaboration-enablement/`

| 技能 | 主要职责 |
| --- | --- |
| [`teach`](../skills/08-collaboration-enablement/teach/SKILL.md) | 在当前工作区教授技能或概念并维护学习材料 |
| [`handoff`](../skills/08-collaboration-enablement/handoff/SKILL.md) | 将当前会话压缩成可供另一个 Agent 接手的文档 |
| [`writing-for-agents`](../skills/08-collaboration-enablement/writing-for-agents/SKILL.md) | 编写供 Agent 消费的技能和指令文档 |
| [`wizard`](../skills/08-collaboration-enablement/wizard/SKILL.md) | 为只能由人完成的基础设施、凭据或迁移步骤生成交互式向导 |
| [`wait-what`](../skills/08-collaboration-enablement/wait-what/SKILL.md) | 当上一条说明没有被理解时，暂停并换一种方式重新表达 |

## 配套资源分布

配套资料由对应技能自行拥有，避免形成无法独立安装的共享依赖。

- `references/`：集中在 4 个质量技能中，共 19 个规则、模板和治理参考文件。
- `scripts/`：`diagnosing-bugs` 提供 1 个 HITL 循环脚本模板。
- 独立 Markdown 模板：`domain-modeling`、`teach`、`triage`、`prototype`、`codebase-design` 等技能包含自己的格式或方法说明。
- 其他模板：`wizard/template.sh` 提供交互式 Bash 向导骨架。

## 维护边界

1. 场景目录使用连续的 `NN-kebab-case` 编号，技能严格位于场景目录下一层。
2. 新技能必须同时包含 `SKILL.md` 与 `agents/openai.yaml`，且技能名在整个仓库中唯一。
3. 技能私有的规则、模板和脚本放在本技能目录内，并使用相对路径引用。
4. 新增、删除、移动或改变技能职责时，更新本页的数量、路径、分类和描述。
5. 提交前运行 `pwsh -File scripts/Test-Skills.ps1`，并确保 GitHub Actions 通过。
