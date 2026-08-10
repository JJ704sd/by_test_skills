# by_test_skills

面向软件工程、质量保障与 Agent 评测的可复用技能集合。仓库当前包含 **30 个技能**，每个技能都可以独立阅读、安装和维护。

## 仓库结构

```text
.
├── skills/                         # 可独立使用的技能，固定为 skills/<skill-name>/
│   └── <skill-name>/
│       ├── SKILL.md                # 技能入口与工作流
│       ├── agents/openai.yaml      # Codex/OpenAI 展示元数据
│       ├── references/             # 可选：规则、模板和参考资料
│       └── scripts/                # 可选：技能自带脚本
├── docs/skills-distribution.md     # 完整分类、职责边界与资源分布
├── scripts/Test-Skills.ps1         # 仓库结构校验
└── .github/workflows/validate-skills.yml
```

技能目录保持扁平，分类只体现在文档中。这样既能按领域浏览，也不会因为移动目录而破坏 `skills/<skill-name>` 的安装约定。

## 技能分布

技能分为两条导航线：5 个项目特有的测试技能单独成组；其余 25 个按实际使用路径依次排列。

| 分组 / 使用阶段 | 数量 | 代表技能 |
| --- | ---: | --- |
| 项目特有：测试全生命周期 | 5 | `test-scope-case-designer` → `release-regression-gatekeeper` |
| ① 入口与初始化 | 2 | `setup-matt-pocock-skills`、`ask-matt` |
| ② 调研与领域建模 | 2 | `research`、`domain-modeling` |
| ③ 澄清、决策与规划 | 5 | `grilling`、`wayfinder`、`to-questionnaire` |
| ④ 规格、工单与分流 | 3 | `to-spec`、`to-tickets`、`triage` |
| ⑤ 设计与原型验证 | 3 | `codebase-design`、`prototype` |
| ⑥ 实现、诊断与审查 | 5 | `implement`、`tdd`、`code-review` |
| ⑦ 协作、教学与交接 | 5 | `teach`、`handoff`、`wizard` |

完整清单、选择建议和技能间关系见 [技能分布文档](docs/skills-distribution.md)。

## 使用方式

1. 从分布文档选择目标技能。
2. 阅读 `skills/<skill-name>/SKILL.md` 的触发条件、输入和边界。
3. 普通工程任务按阶段向后选择；测试任务进入单独的测试技能链。

普通工程路径：

```text
入口初始化 → 调研建模 → 澄清决策 → 规格工单
           → 设计验证 → 实现审查 → 协作交接
```

一次包含 Agent 能力的版本测试可以依次使用：

```text
test-scope-case-designer
  → test-tool-governor
  → test-process-governor
  → agent-nondeterministic-evaluator
  → release-regression-gatekeeper
```

## 本地校验

```powershell
# Windows PowerShell
powershell -ExecutionPolicy Bypass -File scripts/Test-Skills.ps1

# PowerShell 7+
pwsh -File scripts/Test-Skills.ps1
```

校验会检查每个一级技能目录是否包含有效的 `SKILL.md`、名称是否与目录一致，以及是否存在完整的 `agents/openai.yaml`。相同检查会在推送和 Pull Request 时由 GitHub Actions 自动运行。

## 维护约定

- 一个技能一个目录，目录名使用 kebab-case。
- 必须包含 `SKILL.md` 和 `agents/openai.yaml`。
- 深入材料放入技能自己的 `references/`，自动化放入 `scripts/`。
- 根目录只维护集合级文档、检查和 GitHub 配置。
- 修改技能后同步更新 [技能分布文档](docs/skills-distribution.md)。
