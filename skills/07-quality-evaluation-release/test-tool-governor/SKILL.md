---
name: test-tool-governor
description: 按测试目标、风险、团队标准和安全边界选择或审计测试工具，并治理版本、环境、权限、凭据、CI/CD 与资产生命周期。用于引入工具、标准化测试栈、设计 NFR 测试环境或审计脚本证据；不定义测试范围、质量阈值、测试准出或生产发布结论。
---

# 测试工具选型与治理

## 决策权

决定是否需要工具、复用还是引入、如何安全使用和长期维护。只验证工具能否测量已批准目标，不批准产品 NFR 或 Agent 质量阈值。

- 范围和用例交给 $test-scope-case-designer。
- 测试阶段门禁交给 $test-process-governor。
- Agent 指标和准出交给 $agent-nondeterministic-evaluator。
- 发布、灰度和回滚交给 $release-regression-gatekeeper。

没有实施授权时，只输出决策、配置边界和落地计划；不安装依赖、不访问生产、不执行压测或安全扫描。

## 决策深度

- reuse_check：检查团队现有标准工具；满足硬要求时直接复用并列出配置或证据缺口。
- selection_record：现有方案不满足时，比较少量可落地候选并形成正式决策。
- implementation_plan：仅在用户要求落地时补充试用、迁移、CI、培训、维护和退出计划。

## 工作流

1. 明确被测对象、场景、风险、规模、验收指标、证据格式和 CI/CD 需求。
2. 核对团队标准、许可证、维护状态、人员能力和既有资产；事实需记录来源和核验日期。
3. 先应用安全、环境、许可和必需能力否决项；命中时停止推荐执行并给出整改条件。
4. 仅在复用失败时读取 [tool-catalog.md](references/tool-catalog.md) 形成短名单；NFR 场景同时读取 [nfr-tooling.md](references/nfr-tooling.md)。
5. 按统一性、稳定性、可维护性、自动化、适配、成本和迁移比较证据。
6. 需要试用或正式决策时读取 [governance.md](references/governance.md)，在隔离环境设计验收和生命周期治理。
7. 输出采用、限定采用、不采用或 REVIEW_REQUIRED，并单列执行授权、适用范围、禁止项和失效条件。

## 安全否决项

命中任一项时，不得推荐直接执行：

- 工具或治理规则禁止对生产执行压测、容量摸底、扫描、渗透、破坏性故障注入、删除或修改；审批不能解除。
- 主动接口调试、通用自动化、性能或安全脚本指向生产，而非显式隔离的 dev/test/pre 环境。
- 脚本默认指向生产，或配置缺失时回退到生产。
- 使用共享账号、超额权限，或在仓库、脚本、报告、日志中明文保存 Secret 或隐私数据。
- 直接覆盖生产 Prompt，或未固化模型、参数、工具、知识库和评测版本。
- 长期资产没有断言、日志、统计、版本管理或 CI 可复现路径。
- 用 LLM 评审作为计费、权限、安全或核心业务的唯一证据。

发布系统经授权执行部署或回滚不属于测试工具操作。批准的被动遥测、只读低频健康检查和非破坏性线上采样可执行，但不得扩展为主动测试。

## 输出与参考

先给结论、关键证据、阻塞和重新评估条件。正式决策字段、交接包、审计清单和 UNKNOWN/REVIEW_REQUIRED 规则统一读取 [governance.md](references/governance.md)，不要在正文复制模板。

- 工具能力与使用限制：[tool-catalog.md](references/tool-catalog.md)
- NFR 能力、隔离、校准和可复现性：[nfr-tooling.md](references/nfr-tooling.md)
- 选型、治理、记录和交接契约：[governance.md](references/governance.md)
