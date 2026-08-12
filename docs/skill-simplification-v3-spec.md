# Skills 持续精简规范（v3）

状态：Implemented and validated

日期：2026-08-12

基线：`JJ704sd/by_test_skills`，`main@b0de380`

范围：`skills/`、`scripts/Test-Skills.ps1`、`scripts/Test-ValidatorMutations.ps1`、`.github/workflows/validate-skills.yml`、`README.md`、`CONTRIBUTING.md`、`docs/skills-distribution.md`、`docs/development-orchestration-efficiency-spec.md`

## 1. 背景与审计结论

仓库已经完成两轮目录与职责收敛。当前工作树干净，目录、元数据、资源直达和现有 CI 校验均通过：

| 指标 | 基线 |
| --- | ---: |
| 场景组 | 7 |
| Skills / `SKILL.md` / `agents/openai.yaml` | 16 / 16 / 16 |
| `SKILL.md` 行数 / 字符数 | 615 / 45,903 |
| 07 质量组 `SKILL.md` 行数 | 138 |
| 配套文本资源文件 / 行数 / 字符数 | 55 / 2,396 / 91,925 |
| 07 质量组配套文本资源行数 | 1,347 |
| References / assets / skill scripts | 41 / 13 / 1 |

本轮审计发现的主要剩余成本不是 skill 数量，而是：

1. 八个开发执行 skill 重复展开 graph、context capsule、并行门槛、single-writer、checkpoint 和 fan-in 说明；这些约束需要保留，但可缩成任务局部契约。
2. 若干入口重复 description、正文开场、停止条件和最终报告字段，增加每次触发后的常驻上下文。
3. `scripts/Test-Skills.ps1` 用固定英文短语匹配部分行为契约，既阻碍同义精简，也不能证明真实触发和授权边界。
4. 校验只覆盖 skill 内 Markdown 链接，没有把活跃仓库文档、严格 UTF-8、尾随空白和 bundled shell 语法纳入同一入口。
5. 新生成的 tracker 配置仍使用已退休的 `wayfinder:*` 标签，并把单一 CLI 写成唯一能力；这与当前 `plan-engineering-work` 名称和 connector-first 环境漂移。
6. README、分布文档和校验器分别维护 7/16 数量，缺少对精确 skill 集合的交叉验证。
7. `diagnosing-bugs` 的交互式 shell 模板要求 Agent 启动并等待用户，违反“交互脚本由用户审阅和运行”的仓库安全边界；async 问卷也默认写当前目录，没有先确认文件输出授权和目标。
8. 质量 references 保留浏览器版本、覆盖率、采样次数、灰度比例、观察时长、响应分钟数和示例业务阈值等固定数字。即使附带免责声明，这些数字仍会锚定不属于通用 skill 的项目决策。
9. 部分完整输出骨架仍混在 `references/`，模糊“读取规则”和“复制/填充资产”的分工。

## 2. 目标

- 保留 7 个场景和 16 个独立用户意图，不再为压数量合并职责。
- 降低 skill 触发后的固定上下文，同时保留触发、停止、授权、安全和证据语义。
- 将重复编排说明压缩为每个 skill 的最小任务局部规则，不新增元编排 skill 或共享运行时依赖。
- 让静态校验验证结构和可机械证明的不变量，让真实正/负请求与授权场景由独立 forward test 验证。
- 让 tracker 新配置使用中性 schema，并保持已配置仓库可继续使用旧 schema。
- 在完成实现和验证前不进行 branch、stage、commit、push 或 PR 操作。

量化目标：

| 指标 | 目标 |
| --- | ---: |
| 场景 / skills | 7 / 16，精确集合不变 |
| `SKILL.md` 总字符数 | `<= 40,500` 且低于基线 |
| `SKILL.md` 总行数 | `<= 500` |
| 单个 `SKILL.md` | `<= 100` 行 |
| 07 质量组 `SKILL.md` | `<= 135` 行 |
| 全部配套文本资源 | `<= 1,900` 行 / `<= 76,000` 字符 |
| 07 质量组配套文本资源 | `<= 950` 行 |
| 孤立资源、失效相对链接、退休调用、slash 调用 | 0 |
| 官方 `quick_validate.py` | 16/16 通过 |
| 正/负触发、模式和授权 forward tests | 全部通过 |

字符数是主上下文防回弹指标；不得通过合并成超长行规避行数限制。

## 3. 非目标

- 不删除、增加、重命名或移动现有 skill 和场景目录。
- 不改变用户可见产物、已有模式或默认停止点。
- 不合并测试范围、确定性测试执行、Agent 非确定性评测和生产发布四类决策权。
- 不降低 Secret、隐私、生产副作用、审批、回滚、证据可信度或 single-writer 约束。
- 不修改已安装在其他仓库中的 tracker 配置、标签或 issue；只调整本仓库未来生成的模板。
- 不重写 v1/v2 历史规范，不清理远端旧分支，不创建 tag/release。
- 不通过新增外部运行时依赖完成校验。
- 不删除 `codebase-design` 的 scan/design 或 `test-execution-governor` 的双模式；没有使用数据证明删除或拆分是兼容变更，本轮只压缩其共同入口。

## 4. 固定 inventory 与职责不变量

以下集合必须与目录、frontmatter、`agents/openai.yaml`、README 和分布文档完全一致：

| 场景 | Skills |
| --- | --- |
| 01 repository setup | `configure-engineering-skills` |
| 02 domain modeling | `domain-modeling` |
| 03 stakeholder elicitation | `elicit-stakeholder-input` |
| 04 tracker work management | `plan-engineering-work`, `triage` |
| 05 codebase design | `codebase-design` |
| 06 implementation/debugging | `diagnosing-bugs`, `evolving-contracts`, `refactoring-safely`, `resolving-merge-conflicts`, `review-code-against-spec`, `tdd` |
| 07 quality/evaluation/release | `test-scope-case-designer`, `test-execution-governor`, `agent-nondeterministic-evaluator`, `release-gatekeeper` |

必须继续成立：

- `elicit-stakeholder-input` 的 live/async 模式不静默切换，也不自动进入实现。
- `plan-engineering-work` 一次只执行 map/spec/slice 之一，不自动推进下一阶段。
- `codebase-design` 的 scan 只发现候选并停止；design 需要用户选定区域。
- `diagnosing-bugs` 默认止于可复现根因和建议；未授权时不修复。
- `tdd` 必须观察到预期 red 后才能进入 green。
- `refactoring-safely` 保持调用者可见行为；`evolving-contracts` 证明旧/混合/新状态兼容。
- `review-code-against-spec` 固定 diff 并分开报告 Standards/Spec；默认不修改。
- `resolving-merge-conflicts` 只有单一 resolver 写入和暂存，abort 决策属于用户。
- 测试范围决定测什么；测试执行治理决定如何安全测及确定性生命周期门禁；Agent evaluator 决定非确定性质量信号；release gatekeeper 独占生产流量、停止与回滚决策。
- 缺失或失效证据不得推定 PASS；动作授权、门禁结论和执行进度互不推定。

## 5. 设计

### 5.1 精简入口正文

每个 `SKILL.md` 只保留：

1. 触发后的目标和明确停止点；
2. 最短可执行工作流；
3. 每次都适用的授权、安全和证据硬约束；
4. 在使用步骤处直接链接的一层资源；
5. 与相邻 skill 的最小分流条件。

删除或合并：description 的逐句复述、同一停止点的多次声明、重复报告字段、通用 Agent 能力说明，以及不改变决策的背景解释。分支方法、字段表和模板继续留在 `references/`、`assets/`、`scripts/`；不把正文简单搬入新资源来伪造下降。

### 5.2 压缩编排契约

适用 skill 继续保留 task-local dependency/evidence graph、固定输入、有限并行、single-writer、fan-in 和失效重验，但每个概念只表达一次：

- 只有同一当前 frontier、相互独立、可单独验收且收益高于协调成本的工作才可并行。
- worker 使用相同固定输入，并获得目标、依赖、允许读写/副作用、验证命令、预算/停止条件和风险。
- 共享边界、Git、权威数据、生产状态和最终集成由一个 owner 串行处理。
- 输入或 checkpoint 变化使受影响结论失效；预算耗尽不等于完成、诊断或通过。

各 skill 只补充自身不可替代的图、gate 和停止语义，不重复完整通用教程。

### 5.3 静态校验与行为验证分层

`Test-Skills.ps1` 继续作为零依赖静态 gate，并改为验证：

- 从目录动态推导 inventory，并验证目录/frontmatter/agent metadata 与活跃文档投影一致；不把当前数量、可选 skill 名称或固定英文整句硬编码为永久核心；
- 预算、资源一层直达、活跃 Markdown 相对链接；
- 严格 UTF-8、尾随空白、退休/slash 调用；
- README 和分布文档的场景/skill 数量及 skill 集合与目录一致；
- 所有纯输出模板位于 `assets/`，交互式 skill script 不作为 Agent 自动运行入口。

真实触发、模式选择、owner、停止和授权边界由本规范第 7 节的独立 forward tests 验证。删除当前 `$efficiencyContracts` 固定措辞表；静态 regex 通过不得表述为语义证明。

### 5.4 Tracker schema 兼容迁移

未来生成的 GitHub/GitLab 配置采用：

| 旧表示 | 新表示 |
| --- | --- |
| `wayfinder:map` | `planning:map` |
| `wayfinder:research` | `planning:research` |
| `wayfinder:prototype` | `planning:prototype` |
| `wayfinder:grilling` | `planning:stakeholder` |
| `wayfinder:task` | `planning:task` |

迁移规则：

- skill 不把具体标签硬编码为唯一读取条件，而是消费 `docs/agents/issue-tracker.md` 中已配置的表示。
- 新配置只写新表示；不创建双标签 alias。
- 已有仓库继续读取旧配置，不自动改标签或 issue。
- 用户重新运行 `$configure-engineering-skills` 时，先预览映射和受影响标签，确认后才写配置；外部 tracker 数据迁移另行授权。
- GitHub/GitLab 模板描述能力契约：优先可用的 connector/API，认证 CLI 作为支持完整命令面的后备，不把某一工具写成唯一实现。

### 5.5 元数据与资源

- frontmatter 仅保留 `name`、`description`；description 同时表达正向触发和关键排除。
- 保留三个显式调用策略：`configure-engineering-skills`、`plan-engineering-work`、`triage` 的 `allow_implicit_invocation: false`。
- 每个 `agents/openai.yaml` 的名称、短描述和默认 prompt 必须与精简后的职责一致。
- 每个 bundled resource 继续由所属 `SKILL.md` 直接路由；不得新增深层 reference 或仓库级运行时依赖。
- 纯复制/填充的报告、交接包和记录骨架移至 `assets/`；方法、判定规则和字段语义留在 `references/`。混合文件先拆分，避免同一内容在两处重复。

### 5.6 删除通用默认数字与历史考据

质量 skills 只保留阈值契约，不分发项目默认值。一个可判门禁的数值必须带对象、公式/方向、单位、窗口、最小样本、环境、来源、批准状态、缺失数据动作和责任人。缺任一必要字段时输出 `UNAPPROVED`、`REVIEW_REQUIRED` 或 `BLOCKED`，不得从仓库示例推定。

删除或改写：

- “最新两个浏览器版本”、固定自动化覆盖率和未批准的性能退化百分比；
- 固定 Agent 采样次数、语义分数、线上流量、人工抽检量和告警窗口；
- 固定灰度比例、观察时长、响应分钟数、24 小时复盘和组织角色顺序；
- “原规范”来源考据、物流容差等业务示例。

保留定性硬边界：关键计费/权限/安全/数据的任何有效失败不能被平均值抵消；P0/P1 和核心失败不得静默放行；所有比例和时长由当前批准的项目 profile 提供。

### 5.7 人工交互与文件写入

- 删除 `hitl-loop.template.sh`；自动化不可行时，Agent 在当前对话中一次请求一个最小人工动作和脱敏观察，不启动等待用户的交互脚本。
- async 问卷默认在回复中返回草稿。只有用户明确要求文件且目标路径已确定时，才从 questionnaire asset 写入文件。
- 任何脚本必须非交互、确定性且可由 Agent 安全执行；否则它不是 bundled `scripts/` 资产。

## 6. 实施顺序与 checkpoint

1. **Spec checkpoint**：只提交本规范内容到工作树，不改 skill；复核范围、基线和目标。
2. **Core-context checkpoint**：精简 01-06 组入口和重复编排说明；运行静态 gate 与官方 validator。
3. **Quality/resources checkpoint**：精简 07 组入口和 references，删除通用默认数字，将纯模板归位 `assets/`，同时保持四类 owner 与所有硬门禁；重跑验证。
4. **Interaction/tracker checkpoint**：删除交互式脚本、修正 async 写入授权，更新未来生成的 tracker 模板并移除旧标签硬编码；验证旧配置仍是有效输入。
5. **Validator/docs checkpoint**：增强静态 gate、CI 和活跃文档投影；运行完整矩阵。
6. **Independent review checkpoint**：subagents 基于固定 diff 和本规范分别做 Standards、Spec、触发/授权 forward tests；主 agent 汇总并修复发现。
7. **Git checkpoint**：所有验证完成后才创建分支、选择性暂存、提交、推送和开 PR。

每个 checkpoint 后记录工作树、字符/行数、验证结果和残余风险。输入 SHA 或 diff 变化时重验受影响结论。

## 7. 验证矩阵

### 7.1 确定性检查

| 层 | 检查 | 预期 |
| --- | --- | --- |
| 仓库静态 gate | `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/Test-Skills.ps1` | exit 0，inventory 与预算匹配 |
| 官方基础格式 | 对每个 skill 运行 `python -B -X utf8 .../quick_validate.py <skill-dir>` | 16/16 PASS |
| YAML | 解析全部 `*.yaml` / `*.yml` | 0 error |
| 资源与文档 | 一层直达 + 全部活跃 Markdown 相对链接 | 0 orphan / 0 broken |
| 文本 | strict UTF-8 + `git diff --check` | 0 error |
| bundled scripts | 枚举 `scripts/` 并执行适用的静态语法检查 | 本轮删除交互模板后为 0 个；未来新增必须通过 |
| 文档投影 | README / distribution 对目录 inventory | 精确一致 |
| CI | Windows PowerShell 5.1 本地 + Ubuntu `pwsh` Actions | 双平台 PASS |

### 7.2 Trigger/mode forward tests

每个 skill 至少用一条自然用户请求验证应触发和一条相邻请求验证不应触发；多模式入口覆盖每个模式：

| Skill | 应触发 | 应排除或停止 |
| --- | --- | --- |
| `configure-engineering-skills` | 为新仓库配置 tracker/domain 约定 | 普通 issue 操作 |
| `domain-modeling` | 解决歧义术语并记录 glossary/ADR | 只读取既有术语 |
| `elicit-stakeholder-input` | 当前用户判断或他人私有上下文问卷 | 可从代码/公开资料发现的事实 |
| `plan-engineering-work` | 分别验证 map/spec/slice | 原始外部 issue/PR；一次自动串完三模式 |
| `triage` | 分类原始外部 issue/PR | 已批准的实现 ticket |
| `codebase-design` | 分别验证 scan/design | scan 后自动实施；普通小改 |
| `diagnosing-bugs` | 未知根因/flaky/性能瓶颈 | 已验证修复直接实现 |
| `evolving-contracts` | 新旧 API/schema/data/dependency 共存 | 纯内部重构 |
| `refactoring-safely` | 可见行为不变的非平凡重构 | 行为变更或未知缺陷 |
| `resolving-merge-conflicts` | 活跃 merge/rebase 冲突 | 一般 diff 冲突讨论 |
| `review-code-against-spec` | 固定 diff 的 Standards/Spec 双轴审查 | 未授权修复 |
| `tdd` | 明确行为的 test-first 实现 | 未知根因诊断 |
| `test-scope-case-designer` | 决定测什么和回归层级 | 工具选择或发布决定 |
| `test-execution-governor` | 分别验证 tool_selection/lifecycle_gate | Agent 语义质量或生产流量 |
| `agent-nondeterministic-evaluator` | baseline/evaluate/online signal | 确定性 API gate 或回滚 |
| `release-gatekeeper` | pre-release/stage/rollback 决策 | 定义测试范围或自行生成 Agent 评测 |

### 7.3 授权与安全 forward tests

必须证明：

1. “诊断这个失败”不产生未授权修复。
2. 测试 `EXIT_GATE=PASS` 不自动产生生产 `GO`。
3. Agent `online_quality_signal` 不自行改变生产流量。
4. `ROLLBACK` 事实结论与操作者是否有权、动作是否完成分开记录。
5. 未量化/未批准阈值、监控缺失或输入版本漂移不能被写成 PASS。
6. 生产压测、安全扫描、破坏性注入和凭据暴露仍被阻止。
7. async 问卷未获文件输出授权时只在回复中给草稿，不写当前目录。

### 7.4 Validator mutation tests

在临时副本中分别制造错误并要求静态 gate 非零退出：错误 frontmatter/name、缺失 agent 字段、孤立资源、活跃文档断链、退休/slash 调用、预算超限、文档 inventory 漂移、非法 UTF-8、尾随空白和交互式 script。关键 owner/停止语义由 forward tests 而非固定 prose mutation 验证。临时副本不得污染工作树。

## 8. Git 管理与发布

Git 只有主 agent/integrator 可写。subagents 只做只读审计、互斥路径实现或独立验证，不执行 branch、stage、commit、push 或 PR。

完成前保持当前工作树未暂存。全部 gate 通过后：

1. 重新核对 `origin/main` 与固定基线；远端变化时先使审计和验证结论失效并重验。
2. 从当前主线创建 `codex/simplify-skills-v3`，不复用陈旧的 `agent/simplify-skills`，不直推 main、不 force-push、不重写历史。
3. 选择性暂存本规范白名单内文件，不使用会混入无关改动的全树暂存。
4. 按逻辑边界提交：spec；skills/tracker/validator；文档投影与实施结果。即使 Git 操作最后执行，历史仍保持 spec-first。
5. 推送新分支并创建以 `main` 为 base 的 draft PR；等待 CI，不自动合并。
6. 凭据只使用现有认证存储，不写入仓库；认证不可用时停在本地提交之后并明确报告。

旧远端分支删除、tag、release 和 PR 合并均不属于本次授权。

## 9. 回退与失效条件

- 若触发或 owner 边界漂移，恢复对应最小语义，不放宽 validator 或合并职责来追指标。
- 若新 tracker schema 影响已有配置，恢复对配置文档的读取优先级；不自动重写外部标签。
- 若资源不可发现，恢复 `SKILL.md` 直达链接；不依赖 reference 间深层跳转。
- 若任一固定输入、HEAD、diff、环境或阈值来源变化，重新运行受影响检查和 forward tests。
- 删除内容可从 Git 恢复；禁止用 destructive reset/checkout 覆盖用户工作。

## 10. 实施结果

本轮按 spec-first 顺序完成 7 个场景、16 个 skill 的持续精简；skill 名称、目录、模式、显式调用策略、默认停止点和四类质量 owner 均未变化。

| 指标 | 基线 | 最终 | 结果 |
| --- | ---: | ---: | --- |
| 场景 / skills | 7 / 16 | 7 / 16 | 精确集合不变 |
| `SKILL.md` 行数 | 615 | 440 | -28.5% |
| `SKILL.md` 字符数 | 45,903 | 33,738 | -26.5% |
| 配套文本资源行数 | 2,396 | 1,557 | -35.0% |
| 配套文本资源字符数 | 91,925 | 68,641 | -25.3% |
| 07 组 `SKILL.md` 行数 | 138 | 103 | -25.4% |
| 07 组配套资源行数 | 1,347 | 614 | -54.4% |
| References / assets / skill scripts | 41 / 13 / 1 | 38 / 21 / 0 | 模板归位并删除交互脚本 |

实现结果：

- 01–06 组将重复 graph/checkpoint/single-writer 说明压成任务局部契约；07 组删除通用固定门禁数字与历史考据，并将纯输出骨架迁至 `assets/`。
- GitHub/GitLab 新配置使用 `planning:*` 和 connector/API-first、认证 CLI fallback；`$plan-engineering-work` 消费仓库配置而不硬编码标签。既有旧配置仍可读取，重新配置时需预览确认，外部 label/issue 迁移另行授权。
- async 问卷默认只在回复中返回；只有用户明确要求文件并确认路径时才写入。`hitl-loop.template.sh` 已删除，人工步骤改为当前会话中的逐步请求。
- 静态 gate 动态推导 inventory，并覆盖预算、资源直达、活跃文档链接、严格 UTF-8、尾随空白、退休/slash/schema 调用、模板位置和交互脚本；12 个 mutation fixtures 均能触发非零退出。

验证证据（2026-08-12）：

- `scripts/Test-Skills.ps1`：PASS；最终指标如上，孤立资源、失效链接、退休/slash/schema 调用均为 0。
- `scripts/Test-ValidatorMutations.ps1`：12/12 故意破坏样本被拒绝。
- 官方 `quick_validate.py`（Python UTF-8 模式）：16/16 PASS；PyYAML：17 个 skill/CI YAML 文件解析通过。
- PowerShell parser、严格 UTF-8、`git diff --check`：PASS；bundled shell scripts：0。
- 两路盲测覆盖 26 条 01–06 请求和 14 条质量/授权请求：所有 skill/mode/停止/owner 路由符合第 7 节。独立复核发现工具选型模板缺少实施进度轴；补入 `implementation_progress` 并明确与 selection/authorization 互不推定后复核关闭。
- 最终 Standards 复核无 P0/P1/P2；Spec 复核提出的唯一 P2（本节实施结果与状态缺失）已由当前更新关闭。

残余风险：本机没有 `pwsh`，Windows PowerShell 5.1 路径已通过；Ubuntu `pwsh` 等价路径需由 draft PR 的 GitHub Actions 最终证明。当前本机 GitHub CLI 认证失效；Git 凭据恢复前不得把 token 写入仓库或绕过认证。实际 branch、commit 和 PR 信息只在操作成功后记录，不预填。
