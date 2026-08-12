# by_test_skills

> 面向软件工程、质量保障与 Agent 评测的可复用 Codex Skills 集合。

[![Validate skills](https://github.com/JJ704sd/by_test_skills/actions/workflows/validate-skills.yml/badge.svg)](https://github.com/JJ704sd/by_test_skills/actions/workflows/validate-skills.yml)
[![Skills](https://img.shields.io/badge/skills-16-2563eb)](skills)
[![Scenarios](https://img.shields.io/badge/scenarios-7-0f766e)](docs/skills-distribution.md)
[![License](https://img.shields.io/badge/license-MIT-16a34a)](LICENSE)

仓库包含 **16 个按场景安装的 skills**，覆盖人员输入、持久化规划、代码库设计、实现安全、测试治理、Agent 评测和生产发布。每个入口必须提供独立意图、专门流程、可复用资源或独立授权边界；普通路由、公开调研、交接、一次性原型、学习辅导和人工步骤清单继续使用 Codex 默认能力。

## 设计原则

- **按状态选模式**：相邻生命周期合并为一个入口，但一次请求只进入一个明确模式。
- **按需展开**：核心路由与硬约束留在 `SKILL.md`，分支方法放在 `references/`，模板放在 `assets/`。
- **授权隔离**：范围、执行、Agent 质量和生产流量分别由不同 owner 决策。
- **资源自包含**：复制完整 skill 目录即可获得其资源；未安装的可选后继回退到 Codex 普通能力。
- **受控编排**：适用技能使用 task-local graph、evidence loop、checkpoint、有限 subagent fan-out 和 single-writer fan-in。
- **证据优先**：项目阈值必须带来源、口径、适用范围和批准状态；仓库不分发可直接判门禁的通用默认数字。

## 快速开始

```bash
git clone https://github.com/JJ704sd/by_test_skills.git
```

选择需要的完整 `<skill-name>/` 目录复制到 Codex Skills 目录，不要只复制 `SKILL.md`。然后显式调用，例如：

```text
使用 $diagnosing-bugs 复现这个偶发失败并确认根因。
```

不要默认全量安装：

- **Tracker 工作流**：`configure-engineering-skills`、`domain-modeling`、`elicit-stakeholder-input`、`plan-engineering-work`、`triage`。
- **设计与实现**：`codebase-design` 加上任务所需的诊断、TDD、重构、契约迁移、冲突处理或代码审查 skill。
- **质量与发布**：`test-scope-case-designer`、`test-execution-governor`、`release-gatekeeper`；Agent 系统再加 `agent-nondeterministic-evaluator`。

涉及 tracker、triage 标签或领域文档约定时，先运行 `$configure-engineering-skills`。普通实现不需要 `implement` 包装；只有明确要求 test-first 时才使用 `$tdd`。

## 按任务选择

| 当前需要 | 使用 |
| --- | --- |
| 与当前用户实时澄清判断，或为另一知识持有人生成异步问卷 | `$elicit-stakeholder-input` 的 `live` / `async` 模式 |
| 为未知路线建决策图、发布父规格或拆实现切片 | `$plan-engineering-work` 的 `map` / `spec` / `slice` 模式 |
| 分类和验证外部流入的 issue 或 PR | `$triage` |
| 扫描广域架构候选，或设计已选模块的接口与 seam | `$codebase-design` 的 `scan` / `design` 模式 |
| 诊断根因未知、难复现、flaky 或性能回归问题 | `$diagnosing-bugs` |
| 用 red-green-refactor 实现已知行为或已验证修复 | `$tdd` |
| 保持调用者可见行为不变地完成非平凡重构 | `$refactoring-safely` |
| 让新旧 API、schema、数据、依赖或运行时安全共存并迁移 | `$evolving-contracts` |
| 按仓库标准和原始 spec 双轴审查固定 diff | `$review-code-against-spec` |
| 解决正在进行的 merge 或 rebase 冲突 | `$resolving-merge-conflicts` |

## 质量与发布决策权

| 决策 | Owner |
| --- | --- |
| 测什么、测多深、回归层级、判据和用例 | `$test-scope-case-designer` |
| 工具/环境/权限选择，以及确定性测试准入、暂停、准出和关闭 | `$test-execution-governor` |
| Agent 评测集、重复采样、语义质量和漂移信号 | `$agent-nondeterministic-evaluator` |
| 发布、灰度、停止、回滚和生产采样门禁 | `$release-gatekeeper` |

```text
范围、用例与回归层级 → 执行能力与测试准出 → Agent 专项评测（按需）→ 生产发布门禁
```

测试执行 skill 内部仍把工具选择、执行授权、测试门禁、执行进度和生命周期状态分开；测试准出不能推导生产发布。

## 场景目录

| 顺序 | 目录 | 数量 | 关注点 |
| ---: | --- | ---: | --- |
| 01 | `repository-setup` | 1 | 仓库级工作流配置 |
| 02 | `domain-modeling` | 1 | 领域语言与 ADR |
| 03 | `stakeholder-elicitation` | 1 | 人员输入与决策澄清 |
| 04 | `tracker-work-management` | 2 | 持久化规划与外部请求分流 |
| 05 | `codebase-design` | 1 | 架构发现与模块设计 |
| 06 | `implementation-debugging` | 6 | TDD、重构、迁移、诊断、冲突和审查 |
| 07 | `quality-evaluation-release` | 4 | 测试治理、Agent 评测和发布 |

## 本地校验

```powershell
powershell -ExecutionPolicy Bypass -File scripts/Test-Skills.ps1
powershell -ExecutionPolicy Bypass -File scripts/Test-ValidatorMutations.ps1
# 或 PowerShell 7+
pwsh -File scripts/Test-Skills.ps1
pwsh -File scripts/Test-ValidatorMutations.ps1
```

## 文档

- [技能分布与职责边界](docs/skills-distribution.md)
- [开发场景编排提效规范](docs/development-orchestration-efficiency-spec.md)
- [当前持续精简规范 v3](docs/skill-simplification-v3-spec.md)
- [贡献指南](CONTRIBUTING.md)
- [历史精简记录 v2](docs/targeted-skill-simplification-spec.md)
- [历史精简记录 v1](docs/skill-simplification-spec.md)

新增或修改 skill 时，优先扩展现有模式；不要创建只转发到其他入口的 alias，也不要把 Codex 默认能力包装成新 skill。
