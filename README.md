# by_test_skills

> 面向软件工程、质量保障与 Agent 评测的可复用 Codex Skills 集合。

[![Validate skills](https://github.com/JJ704sd/by_test_skills/actions/workflows/validate-skills.yml/badge.svg)](https://github.com/JJ704sd/by_test_skills/actions/workflows/validate-skills.yml)
[![Skills](https://img.shields.io/badge/skills-25-2563eb)](skills)
[![Scenarios](https://img.shields.io/badge/scenarios-8-0f766e)](docs/skills-distribution.md)
[![License](https://img.shields.io/badge/license-MIT-16a34a)](LICENSE)

仓库包含 **25 个可独立安装的技能**，覆盖从调研、澄清和规格设计，到实现、诊断、测试治理、Agent 评测和发布门禁的完整工程路径。每个技能都有清晰的触发边界，只加载当前任务需要的流程与参考资料。

## 设计特点

- **最小入口**：`SKILL.md` 只保留每次调用都需要的流程、决策权和硬约束。
- **按需展开**：详细方法放在 `references/`，输出模板放在 `assets/`，确定性帮助程序放在 `scripts/`。
- **职责分离**：范围、工具、测试准出、Agent 质量和生产发布由不同技能负责，避免越权。
- **可独立安装**：复制完整技能目录即可使用，不依赖场景目录中的共享运行时文件。
- **持续校验**：仓库自动检查元数据、资源路由、链接、上下文预算和已退休技能引用。

## 快速开始

1. 克隆仓库：

   ```bash
   git clone https://github.com/JJ704sd/by_test_skills.git
   ```

2. 选择一个技能，将完整的 `<skill-name>/` 目录复制到运行时配置的 Skills 目录。不要只复制 `SKILL.md`。
3. 使用 `$skill-name` 显式调用，例如：

   ```text
   使用 $diagnosing-bugs 复现这个偶发失败并确认根因。
   ```

涉及 issue tracker、triage 标签或领域文档约定的工作流，先运行 `$configure-engineering-skills`。普通实现不需要额外的 `implement` 包装技能；只有明确要求 test-first 时才使用 `$tdd`。

## 按任务选择技能

| 当前需要 | 使用 |
| --- | --- |
| 不确定从哪里开始或该交给哪个工作流 | `$route-engineering-work` |
| 调查可由文档、规范、源码或一方 API 证明的事实 | `$research` |
| 与当前用户逐轮压力测试尚未定案的计划或决策 | `$grilling` |
| 向另一位知识持有人异步收集私有背景 | `$to-questionnaire` |
| 为路线未知的跨会话工作建立决策地图 | `$wayfinder` |
| 将已解决的讨论固化为规格，再拆成实现切片 | `$to-spec` → `$to-tickets` |
| 分类和验证外部流入的 issue 或 PR | `$triage` |
| 扫描全仓架构候选，或设计已选模块的接口与 seam | `$review-codebase-architecture` → `$codebase-design` |
| 用一次性逻辑或 UI 工件回答一个设计问题 | `$prototype` |
| 诊断根因未知、难复现、flaky 或性能回归问题 | `$diagnosing-bugs` |
| 用 red-green-refactor 实现已知行为或已验证修复 | `$tdd` |
| 按仓库规范和原始 spec 双轴审查 diff | `$review-code-against-spec` |
| 解决正在进行的 merge 或 rebase 冲突 | `$resolving-merge-conflicts` |
| 为人工配置生成向导，或把工作交接给新上下文 | `$wizard` / `$handoff` |

完整的技能职责和相邻边界见 [Skills 分布文档](docs/skills-distribution.md)。

## 质量、评测与发布链路

五个质量技能保留独立决策权：

| 问题 | 负责技能 |
| --- | --- |
| 测什么、测多深、使用什么判据和用例 | `$test-scope-case-designer` |
| 使用什么工具、环境、权限和资产治理方式 | `$test-tool-governor` |
| build 能否进入、暂停、准出测试或关闭生命周期 | `$test-process-governor` |
| Agent 的重复采样、基线、语义质量和漂移信号 | `$agent-nondeterministic-evaluator` |
| 是否发布、继续灰度、停止、回滚或关闭发布 | `$release-regression-gatekeeper` |

```text
范围与用例 → 工具与环境 → 测试流程 → Agent 专项评测（按需）→ 发布门禁
```

只有发布门禁技能拥有生产放量、停止和回滚决策；上游技能提供范围、工具、测试准出和质量证据。

## 场景目录

| 顺序 | 目录 | 数量 | 关注点 |
| ---: | --- | ---: | --- |
| 01 | `onboarding-routing` | 2 | 仓库配置与工作路由 |
| 02 | `research-modeling` | 2 | 一手调研、领域语言与 ADR |
| 03 | `clarification-planning` | 3 | 访谈、异步问卷与决策地图 |
| 04 | `specs-work-management` | 3 | 规格、实现票与外部请求分流 |
| 05 | `design-prototyping` | 3 | 架构发现、模块设计与原型 |
| 06 | `implementation-debugging` | 4 | TDD、诊断、冲突与代码审查 |
| 07 | `quality-evaluation-release` | 5 | 测试治理、Agent 评测与发布 |
| 08 | `collaboration-enablement` | 3 | 学习工作区、人工向导与交接 |

每个技能使用统一结构：

```text
<skill-name>/
├── SKILL.md
├── agents/openai.yaml
├── references/   # 可选：按需读取的规则和方法
├── assets/       # 可选：复制或改造成输出的模板
└── scripts/      # 可选：确定性帮助程序
```

## 本地校验

```powershell
# Windows PowerShell
powershell -ExecutionPolicy Bypass -File scripts/Test-Skills.ps1

# PowerShell 7+
pwsh -File scripts/Test-Skills.ps1
```

相同检查会在 push 和 Pull Request 时由 GitHub Actions 执行。

## 文档与维护

- [技能分布与职责边界](docs/skills-distribution.md)
- [针对性精简设计规范 v2](docs/targeted-skill-simplification-spec.md)
- [第一轮精简与迁移记录](docs/skill-simplification-spec.md)
- [贡献指南](CONTRIBUTING.md)
- [MIT License](LICENSE)

新增或修改技能时，优先完善现有职责，不创建只转发到其他技能的 alias，也不要把 Codex 的默认能力包装成新技能。
