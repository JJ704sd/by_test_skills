# by_test_skills · 工程与质量 Skills 集合

[![Validate skills](https://github.com/JJ704sd/by_test_skills/actions/workflows/validate-skills.yml/badge.svg)](https://github.com/JJ704sd/by_test_skills/actions/workflows/validate-skills.yml) · [MIT License](LICENSE)

面向软件工程、质量保障与 Agent 评测的可复用技能集合。仓库包含 **30 个技能**，按实际使用场景打包为 8 个有序子文件夹；每个技能仍可独立阅读、安装和维护。

## 仓库结构

```text
.
├── skills/
│   ├── 01-onboarding-routing/          # 入口、初始化与技能路由
│   │   └── <skill-name>/
│   │       ├── SKILL.md
│   │       ├── agents/openai.yaml
│   │       ├── references/             # 可选：规则与参考资料
│   │       └── scripts/                # 可选：技能自带脚本
│   ├── 02-research-modeling/           # 调研与领域建模
│   ├── 03-clarification-planning/      # 澄清、决策与规划
│   ├── 04-specs-work-management/       # 规格、工单与分流
│   ├── 05-design-prototyping/          # 设计与原型验证
│   ├── 06-implementation-debugging/    # 实现、测试驱动与诊断
│   ├── 07-quality-evaluation-release/  # 测试、评估、审查与发布
│   └── 08-collaboration-enablement/    # 协作、教学与交接
├── docs/skills-distribution.md         # 完整分类、职责边界与选择建议
├── scripts/Test-Skills.ps1             # 仓库结构校验
└── .github/workflows/validate-skills.yml
```

编号表达常见工作流顺序，但不是强制流水线。可以直接进入任一场景，也可以按任务需要跳过或返回前一阶段。

## 场景分布

| 顺序 | 场景包 | 数量 | 代表技能 |
| ---: | --- | ---: | --- |
| 01 | [入口与路由](skills/01-onboarding-routing/) | 2 | `setup-matt-pocock-skills`、`ask-matt` |
| 02 | [调研与建模](skills/02-research-modeling/) | 2 | `research`、`domain-modeling` |
| 03 | [澄清与规划](skills/03-clarification-planning/) | 5 | `grilling`、`wayfinder`、`to-questionnaire` |
| 04 | [规格与工作管理](skills/04-specs-work-management/) | 3 | `to-spec`、`to-tickets`、`triage` |
| 05 | [设计与原型](skills/05-design-prototyping/) | 3 | `codebase-design`、`prototype` |
| 06 | [实现与诊断](skills/06-implementation-debugging/) | 4 | `implement`、`tdd`、`diagnosing-bugs` |
| 07 | [质量、评估与发布](skills/07-quality-evaluation-release/) | 6 | `test-scope-case-designer`、`code-review`、`release-regression-gatekeeper` |
| 08 | [协作与赋能](skills/08-collaboration-enablement/) | 5 | `teach`、`handoff`、`wizard` |

完整清单、技能边界和组合路径见 [技能分布文档](docs/skills-distribution.md)。

## 使用方式

1. 根据当前任务选择场景包。
2. 阅读 `skills/<scenario>/<skill-name>/SKILL.md` 的触发条件、输入和边界。
3. 安装或复制时以 `<skill-name>/` 为单位，不要只复制 `SKILL.md`，以免遗漏元数据、参考资料或脚本。

常见工程路径：

```text
入口路由 → 调研建模 → 澄清规划 → 规格工单
         → 设计原型 → 实现诊断 → 质量发布 → 协作交接
```

完整测试与发布路径：

```text
test-scope-case-designer
  → test-tool-governor
  → test-process-governor
  → agent-nondeterministic-evaluator（含 Agent 时）
  → code-review（含代码变更时）
  → release-regression-gatekeeper
```

## 本地校验

```powershell
# Windows PowerShell
powershell -ExecutionPolicy Bypass -File scripts/Test-Skills.ps1

# PowerShell 7+
pwsh -File scripts/Test-Skills.ps1
```

校验会检查场景编号是否连续、技能是否严格位于场景目录下一层、`SKILL.md` 名称是否与技能目录一致，以及 `agents/openai.yaml` 是否完整。相同检查会在推送和 Pull Request 时由 GitHub Actions 自动运行。

## 维护约定

- 场景目录使用 `NN-kebab-case`，编号表示推荐浏览顺序。
- 技能目录位于 `skills/<scenario>/<skill-name>/`，名称使用 kebab-case。
- 每个技能必须包含 `SKILL.md` 和 `agents/openai.yaml`。
- 技能私有参考资料和自动化分别放在该技能的 `references/` 与 `scripts/`。
- 新增、移动或改变技能职责后，同步更新 [技能分布文档](docs/skills-distribution.md)。
