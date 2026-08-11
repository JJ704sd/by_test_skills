# by_test_skills — 工程与质量 Skills 集合

[![Validate skills](https://github.com/JJ704sd/by_test_skills/actions/workflows/validate-skills.yml/badge.svg)](https://github.com/JJ704sd/by_test_skills/actions/workflows/validate-skills.yml) · [MIT License](LICENSE)

面向软件工程、质量保障与 Agent 评测的可复用 Codex Skills。仓库包含 **25 个技能**，按常见工作场景分为 8 组；每个技能都可独立复制、安装和维护。

## 目录结构

```text
skills/
├── 01-onboarding-routing/          # 配置与工作路由
├── 02-research-modeling/           # 调研与领域建模
├── 03-clarification-planning/      # 澄清、决策与大型规划
├── 04-specs-work-management/       # 规格、票据与分流
├── 05-design-prototyping/          # 架构设计、审查与原型
├── 06-implementation-debugging/    # TDD、诊断、冲突与代码审查
├── 07-quality-evaluation-release/  # 测试、Agent 评测与发布
└── 08-collaboration-enablement/    # 学习、向导与交接
```

每个技能目录使用统一结构：

```text
<skill-name>/
├── SKILL.md
├── agents/openai.yaml
├── references/   # 可选：按需读取的规则和方法
├── assets/       # 可选：复制或改造成输出的模板
└── scripts/      # 可选：可执行帮助程序
```

## 场景分布

| 顺序 | 场景 | 数量 | 代表技能 |
| ---: | --- | ---: | --- |
| 01 | 配置与路由 | 2 | `configure-engineering-skills`、`route-engineering-work` |
| 02 | 调研与建模 | 2 | `research`、`domain-modeling` |
| 03 | 澄清与规划 | 3 | `grilling`、`wayfinder` |
| 04 | 规格与工作管理 | 3 | `to-spec`、`to-tickets`、`triage` |
| 05 | 设计与原型 | 3 | `codebase-design`、`review-codebase-architecture`、`prototype` |
| 06 | 实现与诊断 | 4 | `tdd`、`diagnosing-bugs`、`review-code-against-spec` |
| 07 | 质量、评估与发布 | 5 | `test-scope-case-designer`、`agent-nondeterministic-evaluator`、`release-regression-gatekeeper` |
| 08 | 协作与赋能 | 3 | `run-learning-workspace`、`wizard`、`handoff` |

完整职责边界见 [Skills 分布文档](docs/skills-distribution.md)。本轮精简的决策、迁移和验收标准见 [设计规范](docs/skill-simplification-spec.md)。

## 快速选择

- 不确定入口：`$route-engineering-work`
- 调查可查证事实：`$research`
- 压力测试尚未定案的想法：`$grilling`
- 大型工作连决策路线都不清楚：`$wayfinder`
- 已有规格，拆成实现票：`$to-tickets`
- 外部 issue/PR 需要分类和补全：`$triage`
- 扫描整个仓库的架构深化候选：`$review-codebase-architecture`
- 为已选模块设计接口或 seam：`$codebase-design`
- 根因未知的 flaky、回归或性能问题：`$diagnosing-bugs`
- 行为已知并要求测试先行：`$tdd`
- 按规范和原始 spec 双轴审查 diff：`$review-code-against-spec`
- 判断 build 能否进入或离开测试：`$test-process-governor`
- 判断能否发布、继续灰度或必须回滚：`$release-regression-gatekeeper`

典型工程路径：

```text
调研/建模 → 澄清 → 规格 → 实现票 → 实现/TDD → 双轴代码审查
                                      → 测试范围 → 工具 → 测试流程
                                      → Agent 评测（按需）→ 发布门禁
```

普通实现不需要单独的 `implement` 技能；Codex 默认完成实现，只有 test-first 意图才触发 `$tdd`。

## 使用方式

1. 从当前任务对应的场景选择技能，或调用 `$route-engineering-work`。
2. 安装或复用时复制完整的 `<skill-name>/` 目录，不要只复制 `SKILL.md`。
3. 显式调用使用 `$skill-name`；隐式触发由 `SKILL.md` 的 `description` 决定。
4. 需要仓库 issue tracker、triage 标签和领域文档约定的工作流，先运行 `$configure-engineering-skills`。

## 本地校验

```powershell
# Windows PowerShell
powershell -ExecutionPolicy Bypass -File scripts/Test-Skills.ps1

# PowerShell 7+
pwsh -File scripts/Test-Skills.ps1
```

校验覆盖场景编号、技能数量与命名、上下文预算、frontmatter、`agents/openai.yaml`、资源分层与直达路由、长 reference 导航、相对链接和旧技能引用。相同检查会在 push 和 Pull Request 时由 GitHub Actions 执行。

## 维护约定

- 场景目录使用连续的 `NN-kebab-case`；技能目录使用唯一的 kebab-case 名称。
- `SKILL.md` frontmatter 只包含 `name` 与 `description`，且正文不超过 100 行。
- 触发和排除条件写在 `description`；分支细节放在 `references/`，输出模板放在 `assets/`。
- 每个 `references/`、`assets/` 和 `scripts/` 文件都必须从所属 `SKILL.md` 直接路由。
- `agents/openai.yaml` 必须包含 `display_name`、`short_description` 和引用 `$skill-name` 的 `default_prompt`。
- 当前总预算为 900 行 / 50,000 字符；07 质量组主入口不超过 225 行，文本资源不超过 1,800 行。
- 新增、删除、移动或改变技能职责后，同步更新分布文档和校验预算。

第二轮精简的范围、批次和行为不变量见 [针对性精简设计规范 v2](docs/targeted-skill-simplification-spec.md)。
