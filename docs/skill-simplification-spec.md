# Skills 精简与整理设计规范

状态：Implemented and validated
日期：2026-08-10
范围：`skills/`、`README.md`、`CONTRIBUTING.md`、`docs/skills-distribution.md`、`scripts/Test-Skills.ps1`

## 1. 背景

仓库当前包含 30 个技能，已按 8 个使用场景分组，但仍保留了早期技能格式、别名包装和重复说明。结构校验可以通过，不代表触发边界、上下文成本和副作用边界已经合理。

基线：

| 指标 | 当前值 |
| --- | ---: |
| 场景目录 | 8 |
| 技能 / `SKILL.md` | 30 |
| `SKILL.md` 总行数 | 2,121 |
| `SKILL.md` 总字符数 | 137,975 |
| 技能集合文件数 | 103 |
| 技能根目录散落的配套文件 | 23 |
| 含旧式额外 frontmatter 字段的技能 | 14 |
| 缺少 `interface.default_prompt` 的技能 | 25 |

主要问题：

1. `grill-me`、`grill-with-docs` 和 `implement` 只是对既有能力的薄包装。
2. `wait-what` 属于模型默认可完成的重新解释行为，没有独有流程或资源。
3. `writing-for-agents` 与当前 `skill-creator` 重叠，且其 mechanics 仍教授旧式 `disable-model-invocation`。
4. `ask-matt`、`wayfinder`、`teach`、多个质量技能在主入口重复展开大量细节。
5. 23 个配套文件散落在技能根目录，没有按 `references/`、`assets/`、`scripts/` 分层。
6. 14 个技能在 frontmatter 使用 `disable-model-invocation` 或 `argument-hint`；调用策略已由 `agents/openai.yaml` 表达。
7. 多处使用旧式 `/skill-name` 调用语法，且若干技能默认 commit、stage everything 或删除临时物，授权边界不够安全。

## 2. 目标

本次调整同时优化三种成本：

- **技能数量**：减少常驻元数据和选择噪音。
- **触发后上下文**：主入口只保留每次都需要的流程与硬约束，分支细节按需加载。
- **维护成本**：一个规则只有一个权威位置，名称、元数据、目录和文档保持一致。

量化目标：

| 指标 | 目标 |
| --- | ---: |
| 技能数量 | 25 |
| 单个 `SKILL.md` | 不超过 100 行 |
| `SKILL.md` 总行数 | 不超过 1,600 |
| `SKILL.md` 总字符数 | 不超过 100,000 |
| 技能根目录配套文件 | 0 |
| 非法/旧式 frontmatter 字段 | 0 |
| 缺少 `default_prompt` 的技能 | 0 |
| 失效的相对链接或已删除技能引用 | 0 |

## 3. 非目标

- 不把五个质量治理职责合并成一个“大而全”技能。
- 不重写所有参考资料；只删除重复、修正错误并补充必要导航。
- 不为旧名称保留兼容 alias。alias 本身会恢复本次要删除的元数据和触发噪音；迁移通过映射表和 Git 历史完成。
- 不改变已有质量门禁的决策权、硬阈值所有权或安全否决项。
- 不在本次调整中安装新的外部依赖、访问生产系统或发布仓库变更。

## 4. 决策原则

一个能力只有满足至少一项时才保留为独立技能：

1. 有稳定、独立的用户意图和清晰触发边界。
2. 包含模型默认不知道的领域规则或高风险流程。
3. 拥有可复用脚本、模板或参考资料。
4. 需要独立的授权、证据或决策权边界。

以下情况合并或删除：

- 只转发到另一个技能。
- 只重复 Codex 默认工作习惯。
- 与系统技能重复且规范已经过时。
- 仅为了串联其他技能，没有独有判断或资产。
- 名称宽泛到会吞掉相邻意图，且无法通过 description 可靠分界。

## 5. 目标技能目录

| 场景 | 目标技能 | 决策 |
| --- | --- | --- |
| 01 入口与路由 | `route-engineering-work` | 由 `ask-matt` 重命名并压缩为决策表 |
| 01 入口与路由 | `configure-engineering-skills` | 由 `setup-matt-pocock-skills` 去品牌化重命名 |
| 02 调研与建模 | `research` | 保留，补并发不可用时的降级路径 |
| 02 调研与建模 | `domain-modeling` | 保留，格式与 ADR 规则下沉 references |
| 03 澄清与规划 | `grilling` | 成为唯一访谈引擎，吸收无持久化/领域文档两种模式 |
| 03 澄清与规划 | `to-questionnaire` | 保留，明确“外部知识持有人、异步回收”边界 |
| 03 澄清与规划 | `wayfinder` | 保留，专注未知路线的决策票地图 |
| 04 规格与工作管理 | `to-spec` | 保留，消除“不访谈”和“要求确认”的矛盾 |
| 04 规格与工作管理 | `to-tickets` | 保留，专注已知路线的实现票 |
| 04 规格与工作管理 | `triage` | 保留，专注外部流入的原始 issue/PR |
| 05 设计与原型 | `codebase-design` | 保留，专注已选模块的接口与 seam 设计 |
| 05 设计与原型 | `review-codebase-architecture` | 由 `improve-codebase-architecture` 重命名，专注发现候选和报告 |
| 05 设计与原型 | `prototype` | 保留逻辑/UI dispatcher，分支细节下沉 references |
| 06 实现与诊断 | `tdd` | 保留并恢复标准 red-green-refactor 语义 |
| 06 实现与诊断 | `diagnosing-bugs` | 保留，默认终点收窄为可复现根因和修复建议 |
| 06 实现与诊断 | `resolving-merge-conflicts` | 保留，修正 abort、stage 和 commit 安全边界 |
| 06 实现与诊断 | `review-code-against-spec` | 由 `code-review` 重命名并从 07 迁入，专注 Standards/Spec 双轴审查 |
| 07 质量、评估与发布 | `test-scope-case-designer` | 保留，范围/NFR 判据/用例所有权 |
| 07 质量、评估与发布 | `test-tool-governor` | 保留，工具/环境/权限/生命周期所有权 |
| 07 质量、评估与发布 | `test-process-governor` | 保留，测试阶段和测试准出所有权 |
| 07 质量、评估与发布 | `agent-nondeterministic-evaluator` | 保留，Agent 采样、基线、语义质量和漂移所有权 |
| 07 质量、评估与发布 | `release-regression-gatekeeper` | 保留，生产发布、灰度、停止和回滚所有权 |
| 08 协作与赋能 | `run-learning-workspace` | 由 `teach` 重命名并改为持久化学习工作区的六步流程 |
| 08 协作与赋能 | `handoff` | 保留，补充最小交接契约 |
| 08 协作与赋能 | `wizard` | 保留，模板迁入 assets |

目标数量：25。

## 6. 删除与合并映射

| 旧技能 | 动作 | 替代方式 |
| --- | --- | --- |
| `grill-me` | 删除并合并 | `$grilling` 默认无持久化模式 |
| `grill-with-docs` | 删除并合并 | `$grilling` 的 documented 模式，并组合 `$domain-modeling` |
| `implement` | 删除 | 普通实现使用 Codex 默认能力；显式测试先行使用 `$tdd`；完成后按需使用 `$review-code-against-spec` |
| `wait-what` | 删除 | 直接要求重新解释、补上下文或使用简明语言 |
| `writing-for-agents` | 删除 | 创建/修改技能使用系统 `skill-creator`；AGENTS/CLAUDE 文档使用通用编辑能力 |

删除的内容仍可从 Git 历史恢复，不创建 deprecated wrapper。

## 7. 重命名与移动映射

| 旧路径/名称 | 新路径/名称 | 理由 |
| --- | --- | --- |
| `ask-matt` | `route-engineering-work` | 去个人品牌，名称直接表达路由意图 |
| `setup-matt-pocock-skills` | `configure-engineering-skills` | 去个人品牌，表达仓库级配置职责 |
| `improve-codebase-architecture` | `review-codebase-architecture` | 实际产物是审查、报告和候选选择，不直接实施改造 |
| `07/.../code-review` | `06/.../review-code-against-spec` | 精确表达双轴审查，并归入实现收尾阶段 |
| `teach` | `run-learning-workspace` | 区分持久化多会话学习与一次性解释 |

所有内部调用统一使用 `$skill-name`。

## 8. 内容架构

每个技能采用三层披露：

1. `SKILL.md`：触发后每次都需要的核心流程、硬边界和 references 路由。
2. `references/`：仅特定分支需要的规则、方法、示例、状态映射和字段契约。
3. `assets/`：复制或改造成输出的模板、脚手架和静态资源。

规则：

- frontmatter 只允许 `name` 和 `description`。
- “何时使用”和关键排除条件全部写入 `description`，正文不再设置 `When to use` 章节。
- 输出模板不内嵌在长主流程中；移到 `assets/`。
- reference 超过 100 行时提供目录，或精简至 100 行以内。
- references 只从 `SKILL.md` 一层直达，不建立深层导航链。
- 同一规则只保留一个权威位置；主文只保留不可下沉的硬约束和条件式链接。
- 技能根目录只允许 `SKILL.md`、`agents/`、`references/`、`assets/`、`scripts/`。

资源迁移方向：

- tracker、问卷、spec、ticket、wayfinder、wizard 的输出骨架 → `assets/`。
- domain、triage、TDD、原型、架构设计、debug loop、code smell、教学法和质量治理细节 → `references/`。
- 可执行且需要确定性的帮助程序 → `scripts/`。

## 9. 元数据规范

每个保留技能的 `agents/openai.yaml` 必须包含：

```yaml
interface:
  display_name: "..."
  short_description: "..."
  default_prompt: "Use $skill-name to ..."
```

要求：

- 所有字符串加引号。
- `short_description` 保持 25–64 个字符，说明用户可获得的结果。
- `default_prompt` 是一句短示例，并显式包含 `$skill-name`。
- 仅显式调用的技能使用：

```yaml
policy:
  allow_implicit_invocation: false
```

- `disable-model-invocation` 和 `argument-hint` 不再出现在 `SKILL.md`。
- `agents/openai.yaml` 的显示名、短描述和调用策略必须与 `SKILL.md` 当前职责一致。

## 10. 关键职责边界

| 相邻能力 | 分界 |
| --- | --- |
| `grilling` vs `to-questionnaire` | 当前用户的实时决策 vs 另一个人持有的异步知识 |
| `research` vs `to-questionnaire` | 可查证的一手来源事实 vs 私有的人类知识 |
| `wayfinder` vs `to-tickets` | 路线未知的决策票 vs 路线已知的实现票 |
| `triage` vs `to-tickets` | 外部流入的原始请求 vs 内部已批准计划的实现切片 |
| `review-codebase-architecture` vs `codebase-design` | 扫描并排序候选 vs 设计已选模块接口 |
| `diagnosing-bugs` vs `tdd` | 根因未知、先建证据回路 vs 行为/根因已知、测试先行实现 |
| `test-process-governor` vs `release-regression-gatekeeper` | build 是否进入/离开测试阶段 vs 是否改变生产流量 |
| `agent-nondeterministic-evaluator` vs release | 产出质量信号 vs 拥有放量、停止和回滚动作 |

## 11. 安全与授权修正

- `prototype` 不再默认创建分支、commit 或更新 issue；只有用户或既有工作流明确要求时执行。
- `diagnosing-bugs` 默认只诊断；修复需要用户请求或明确 handoff。仅清理本轮创建且已确认可丢弃的临时物。
- `resolving-merge-conflicts` 只 stage 已解决的冲突路径，保留无关修改；不自行决定 `--abort`，发现应中止时请求用户决定。
- 删除 `implement` 中的无条件 commit。
- `wizard` 继续只生成供人运行的脚本；不由技能自动执行交互式向导。
- 质量和发布技能在没有真实授权时只给决策与操作清单，不声称已执行生产动作。

## 12. 实施阶段

### 阶段 A：结构收敛

1. 删除 5 个技能目录。
2. 完成 5 个技能的重命名/移动。
3. 更新全仓路径和技能调用名。
4. 保证不存在旧名称引用。

完成标准：目标目录中恰好 25 个技能，所有 `name` 与目录一致。

### 阶段 B：资源分层

1. 将根目录配套文件迁入 `references/` 或 `assets/`。
2. 提取内嵌模板和大型分支说明。
3. 修复全部相对链接和 reference 导航。

完成标准：技能根目录配套文件为 0，所有相对链接可解析。

### 阶段 C：触发与正文精简

1. 重写 description，补正向触发和关键排除条件。
2. 精简 router、setup、wayfinder、spec/tickets/triage、设计/诊断、教学和质量技能。
3. 消除重复状态、字段列表、示例和过时实现细节。
4. 修正 TDD 语义与副作用授权边界。

完成标准：每个 `SKILL.md` 不超过 100 行，总量达到量化目标。

### 阶段 D：元数据与仓库规范

1. frontmatter 只保留 `name`、`description`。
2. 更新全部 `agents/openai.yaml` 并补 `default_prompt`。
3. 更新 README、技能分布、贡献指南和统计。
4. 增强 `Test-Skills.ps1`，覆盖本 spec 的结构与元数据规则。

完成标准：仓库校验能发现非法 frontmatter、缺失默认 prompt、根目录散落文件和失效技能引用。

### 阶段 E：验证

1. 运行仓库校验与 `git diff --check`。
2. 校验所有技能名称、链接、资源引用、metadata 和长度预算。
3. 运行代表性脚本语法检查。
4. 用隔离子代理执行路由与前向测试。

完成标准：全部静态检查通过，路由案例没有高风险误选，技能输出不依赖已删除名称。

## 13. 验收案例

至少验证以下选择：

| 请求 | 预期选择 |
| --- | --- |
| “压力测试这个尚未定案的设计” | `grilling` |
| “把访谈中确定的术语和 ADR 一起落盘” | `grilling` + `domain-modeling` |
| “这个跨季度项目连路线都不清楚” | `wayfinder` |
| “规格已确定，请拆成可实施票据” | `to-tickets` |
| “整理外部用户新报的 issue” | `triage` |
| “扫描整个仓库找架构深化候选” | `review-codebase-architecture` |
| “为这个已选模块比较接口方案” | `codebase-design` |
| “这个 flaky 回归根因未知” | `diagnosing-bugs` |
| “行为已知，请 red-green-refactor 实现” | `tdd` |
| “按 spec 检查这次 diff 是否合规且完整” | `review-code-against-spec` |
| “判断 build 能否结束测试” | `test-process-governor` |
| “判断能否继续灰度或必须回滚” | `release-regression-gatekeeper` |
| “继续上次的长期学习课程” | `run-learning-workspace` |
| “请换一种简单方式解释” | 不需要技能 |
| “按这个 ticket 实现” | 默认实现能力；只有明确 test-first 时触发 `tdd` |

## 14. 风险与缓解

- **重命名造成断链**：全仓精确搜索旧名称，校验脚本增加技能引用检查。
- **正文下沉过度**：关键不变量留在主文；reference 链接写明精确加载条件。
- **质量门禁语义丢失**：对测试准出、Agent 子集早失败、发布前、灰度中和回滚分别做前向测试。
- **删除快捷命令影响习惯**：在本 spec 和分布文档保留一次迁移映射，不保留可触发 alias。
- **模板迁移影响输出**：移动后逐一检查引用，并对 shell 模板运行语法检查。
- **校验器依赖不可用**：仓库 PowerShell 校验实现等价规则；若具备 PyYAML，再补跑官方 `quick_validate.py`。

## 15. 交付物

- 本设计规范。
- 25 个职责清晰、结构一致的技能。
- 更新后的 README、分布文档和贡献指南。
- 覆盖新规范的仓库校验脚本。
- 最终基线指标、验证结果和迁移摘要。

## 16. 实施结果

| 指标 | 基线 | 实际结果 | 结论 |
| --- | ---: | ---: | --- |
| 场景目录 | 8 | 8 | 通过 |
| 技能数量 | 30 | 25 | 减少 16.7% |
| `SKILL.md` 总行数 | 2,121 | 1,007 | 减少 52.5% |
| `SKILL.md` 总字符数 | 137,975 | 54,716 | 减少 60.3% |
| 最长 `SKILL.md` | 140 行 | 61 行 | 通过 100 行预算 |
| 技能根目录配套文件 | 23 | 0 | 通过 |
| 非法/旧式 frontmatter 字段 | 14 | 0 | 通过 |
| 缺少 `default_prompt` | 25 | 0 | 通过 |
| 失效相对链接、旧调用或 slash-style 调用 | 未统一校验 | 0 | 通过 |

完成情况：

- 5 个薄包装或重复技能已删除/合并，5 个职责不准确的技能已重命名或移动；未保留 deprecated alias。
- 25 个技能均采用 `SKILL.md` + `agents/` + 按需 `references/`、`assets/`、`scripts/` 的分层结构。
- 五个质量治理技能保持独立，并补齐测试决策点、发布门禁决定、操作者授权和动作进度的独立状态轴。
- README、贡献指南、技能分布文档与本 spec 已同步到最终目录和名称。

验证记录：

- `scripts/Test-Skills.ps1`：通过；覆盖 8 个场景、25 个技能、长度预算、frontmatter、metadata、全部 Markdown 相对链接、资源分层、旧技能与 slash-style 调用。
- `git diff --check`、全仓尾随空白扫描、严格 UTF-8 解码：通过。
- `wizard-template.sh` 与 `hitl-loop.template.sh` 的 `bash -n`：通过。
- 三组隔离前向测试：正确得到“先诊断后 TDD”、`EXIT_GATE=FAIL` 和“`ROLLBACK` 决策不因当前操作者无权而改变”。
- 独立最终 spec 审计：通过，无阻止验收的问题。
- 系统 `quick_validate.py` 因本机未安装 PyYAML 未执行；遵循本 spec 的非目标，没有安装新依赖，仓库 PowerShell 校验已覆盖其结构和元数据规则。
