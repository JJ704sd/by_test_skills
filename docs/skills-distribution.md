# Skills 分布与职责边界

更新日期：2026-08-10
统计范围：`skills/` 下的一级目录

## 总览

| 指标 | 数量 |
| --- | ---: |
| 技能目录 / `SKILL.md` | 30 |
| `agents/openai.yaml` | 30 |
| `references/` 内文件 | 19 |
| `scripts/` 内文件 | 1 |
| 其他技能配套文件 | 23 |
| 技能集合总文件数 | 103 |

所有技能均采用 `skills/<skill-name>/SKILL.md` 作为入口，并配有 OpenAI Agent 元数据。导航分为两部分：项目特有的 5 个测试技能固定成组，其余 25 个技能按使用路径依次排列。5 个测试技能还配置了 `default_prompt`，通用技能则保持各自原有的显式/隐式调用策略。分类仅用于导航，不改变磁盘上的扁平布局。

## A. 项目特有测试技能组（5）

| 技能 | 主要职责 | 典型产物 |
| --- | --- | --- |
| [`test-scope-case-designer`](../skills/test-scope-case-designer/SKILL.md) | 从需求、变更、事故和风险中设计测试范围、NFR 与用例 | 范围矩阵、边界用例、NFR 工作负载模型 |
| [`test-tool-governor`](../skills/test-tool-governor/SKILL.md) | 选择并治理功能、性能、可靠性、安全和 Agent 评测工具 | 工具决策、环境与证据治理方案 |
| [`test-process-governor`](../skills/test-process-governor/SKILL.md) | 编排功能测试及通用确定性 NFR 的端到端测试过程 | 阶段门禁、执行证据、准入/准出判断 |
| [`agent-nondeterministic-evaluator`](../skills/agent-nondeterministic-evaluator/SKILL.md) | 对 Agent 技术指标和非确定性语义质量进行采样、基线与漂移评测 | 版本化评测集、指标、离线门禁与漂移结论 |
| [`release-regression-gatekeeper`](../skills/release-regression-gatekeeper/SKILL.md) | 汇总回归证据并治理发布、灰度、停止和回滚 | GO/CONDITIONAL_GO/NO_GO/BLOCKED 决策 |

固定使用链路：`范围与用例 → 工具与环境 → 测试过程 → Agent 专项评测 → 回归发布门禁`。

这 5 个技能共同覆盖测试全生命周期，作为本项目区别于通用工程技能的核心能力组。

## B. 其余技能的使用路径（25）

```text
① 入口与初始化
  → ② 调研与领域建模
  → ③ 澄清、决策与规划
  → ④ 规格、工单与分流
  → ⑤ 设计与原型验证
  → ⑥ 实现、诊断与审查
  → ⑦ 协作、教学与交接
```

阶段不是强制流水线：可以从任一阶段进入，也可以根据任务需要跳过阶段或回退。`ask-matt` 用于入口路由，`handoff` 可在任意阶段收尾交接。

### ① 入口与初始化（2）

| 技能 | 主要职责 |
| --- | --- |
| [`setup-matt-pocock-skills`](../skills/setup-matt-pocock-skills/SKILL.md) | 首次使用工程技能前配置 issue 跟踪器、标签体系与领域文档布局 |
| [`ask-matt`](../skills/ask-matt/SKILL.md) | 根据当前情境路由到合适的工程技能或工作流 |

### ② 调研与领域建模（2）

| 技能 | 主要职责 |
| --- | --- |
| [`research`](../skills/research/SKILL.md) | 基于高可信一手来源调查事实并在仓库沉淀结论 |
| [`domain-modeling`](../skills/domain-modeling/SKILL.md) | 建立统一领域语言、上下文和架构决策记录 |

### ③ 澄清、决策与规划（5）

| 技能 | 主要职责 |
| --- | --- |
| [`grilling`](../skills/grilling/SKILL.md) | 通过高强度追问压力测试计划、决策或想法 |
| [`grill-me`](../skills/grill-me/SKILL.md) | `grilling` 的轻量入口，用访谈打磨计划或设计 |
| [`grill-with-docs`](../skills/grill-with-docs/SKILL.md) | 在追问过程中同步沉淀 ADR 和术语表 |
| [`to-questionnaire`](../skills/to-questionnaire/SKILL.md) | 将当前无法回答的决策转换为可交给他人填写的问卷 |
| [`wayfinder`](../skills/wayfinder/SKILL.md) | 将超出单次会话容量的大型工作拆成共享决策地图 |

### ④ 规格、工单与分流（3）

| 技能 | 主要职责 |
| --- | --- |
| [`to-spec`](../skills/to-spec/SKILL.md) | 把已有讨论直接综合成规格并发布到项目跟踪器 |
| [`to-tickets`](../skills/to-tickets/SKILL.md) | 将计划或规格拆成带阻塞边的 tracer-bullet 工单 |
| [`triage`](../skills/triage/SKILL.md) | 对 issue 和外部 PR 分类、验证并生成 Agent 可执行简报 |

### ⑤ 设计与原型验证（3）

| 技能 | 主要职责 |
| --- | --- |
| [`codebase-design`](../skills/codebase-design/SKILL.md) | 设计深模块、接口边界、可测试性与 Agent 可导航性 |
| [`improve-codebase-architecture`](../skills/improve-codebase-architecture/SKILL.md) | 扫描架构深化机会，生成可视报告并引导决策 |
| [`prototype`](../skills/prototype/SKILL.md) | 用一次性原型验证状态模型、逻辑或 UI 方向 |

### ⑥ 实现、诊断与审查（5）

| 技能 | 主要职责 |
| --- | --- |
| [`implement`](../skills/implement/SKILL.md) | 根据规格或工单完成实现 |
| [`tdd`](../skills/tdd/SKILL.md) | 以红—绿—重构循环测试驱动开发功能或修复 |
| [`diagnosing-bugs`](../skills/diagnosing-bugs/SKILL.md) | 诊断复杂缺陷和性能退化，循环收集证据 |
| [`code-review`](../skills/code-review/SKILL.md) | 同时从仓库规范和原始规格两个维度审查变更 |
| [`resolving-merge-conflicts`](../skills/resolving-merge-conflicts/SKILL.md) | 处理进行中的 merge/rebase 冲突 |

### ⑦ 协作、教学与交接（5）

| 技能 | 主要职责 |
| --- | --- |
| [`teach`](../skills/teach/SKILL.md) | 在当前工作区教授技能或概念并维护学习材料 |
| [`handoff`](../skills/handoff/SKILL.md) | 将当前会话压缩成可供另一个 Agent 接手的文档 |
| [`writing-for-agents`](../skills/writing-for-agents/SKILL.md) | 编写供 Agent 消费的技能和指令文档 |
| [`wizard`](../skills/wizard/SKILL.md) | 为只能由人完成的基础设施、凭据或迁移步骤生成交互式向导 |
| [`wait-what`](../skills/wait-what/SKILL.md) | 当上一条说明没有被理解时，暂停并换一种方式重新表达 |

## 配套资源分布

配套资料由对应技能自行拥有，避免根目录形成无法独立安装的共享依赖：

- `references/`：集中在 4 个质量技能中，共 19 个规则、模板和治理参考文件。
- `scripts/`：`diagnosing-bugs` 提供 1 个 HITL 循环脚本模板。
- 独立 Markdown 模板：`domain-modeling`、`teach`、`triage`、`prototype`、`codebase-design` 等技能包含自己的格式或方法说明。
- 其他模板：`wizard/template.sh` 提供交互式 Bash 向导骨架。

## 维护边界

1. 不在 `skills/` 下增加分类层级；运行时通常按一级子目录发现技能。
2. 新技能必须同时添加 `SKILL.md` 与 `agents/openai.yaml`。
3. 技能私有的规则、模板和脚本放在本技能目录内，并使用相对路径引用。
4. 新增、删除或改变技能职责时，更新本页的数量、分类和描述。
5. 提交前运行 `pwsh -File scripts/Test-Skills.ps1`，并确保 GitHub Actions 通过。
