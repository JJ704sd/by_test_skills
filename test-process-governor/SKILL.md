---
name: test-process-governor
description: 编排软件与 Agent 的“完整测试”请求，治理功能及通用服务/API/UI 确定性 NFR 的端到端生命周期、阶段证据和质量门禁，检查提测、冒烟、执行、缺陷、暂停/结束与准出。Use when planning or auditing a test lifecycle or deciding whether a build may enter/leave testing; Agent technical-metric plus non-deterministic semantic evaluation belongs to agent-nondeterministic-evaluator, while rollout belongs to release-regression-gatekeeper.
---

# 测试流程治理

## 职责边界

负责维护从需求评审到上线复盘的阶段链路、证据和测试门禁。对宽泛的“完整测试”请求，负责建立总台账并编排其他技能。

产品/业务/架构及适用角色批准 NFR/SLO；本技能编排确定性 NFR 执行、证据可信度和测试准出，不自行定义产品阈值。

不要在本技能内重复完成下列专项工作：

- 用 `test-scope-case-designer` 界定测试范围并设计用例。
- 用 `test-tool-governor` 选择工具、环境和权限方案。
- 用 `agent-nondeterministic-evaluator` 评估 Agent 的采样质量与统计指标。
- 用 `release-regression-gatekeeper` 决定回归层级、发布方式、灰度和回滚。

测试阶段的准出状态由本技能给出；生产发布的最终 Go/No-Go 由 `release-regression-gatekeeper` 汇总。

## 开始前

收集以下事实；缺失项标为“待补证据”，不要推定为通过：

- 项目、版本/build、当前阶段、计划上线时间和版本类型。
- 需求、验收标准、变更清单、影响范围和历史风险。
- 测试环境、数据、账号、权限、依赖和开发自测报告。
- 测试范围、用例版本、执行记录、缺陷清单和产品验收状态。
- NFR/SLI/SLO 配置版本、批准记录、工作负载/故障模型、执行报告和原始证据。
- Agent 项目的 Prompt、模型、工具、知识库和输出 Schema 变更。

规则冲突时先比较适用范围、指标方向、公式和窗口：采用已批准且可追溯的项目标准；只有同口径规则才能取更严格值。不同口径或适用范围无法裁定时标为 `BLOCKED`，不得自行混合。不得放宽计费、权限、数据安全、安全拒绝等高风险门禁。

## 工作流

1. **确认上下文**：区分常规迭代、紧急修复/热更、大版本/重构；记录事实、假设、未知项和证据位置。
2. **建立阶段台账**：按需求分析、测试设计、开发实现、版本测试、上线与复盘列出输入、动作、输出、责任人、状态和下一门禁。
3. **检查测试设计就绪度**：涉及 NFR 时先读取 [nfr-evidence.md](references/nfr-evidence.md)，确认范围、风险、判据、用例、数据、负载/故障模型和环境计划已评审；需要新增或修改时转交 `test-scope-case-designer`。
4. **执行提测准入**：验证版本、服务、依赖、环境、数据、账号、权限和自测材料。任一阻塞项未满足时退回并写明责任人和重新提测条件。
5. **先冒烟再系统测试**：先验证启动/登录、核心链路、关键 API；Agent 还要验证基础对话和关键工具调用。冒烟未通过时不要用系统测试替代环境或构建排障。
6. **治理执行与缺陷**：记录每条用例的通过、失败、阻塞、缺陷和环境证据；按提交、确认、修复、待验证、关闭/重新打开推进缺陷闭环。
7. **检查测试准出**：核对执行完成度、缺陷严重度 P0/P1、影响面回归、NFR 证据、产品验收、报告评审和遗留风险。Agent 相关确定性子门禁必须 `PASS`；整体仅因已批准且明确不影响 Agent 评测的风险而为 `PASS_WITH_ACCEPTED_RISK` 时，可按治理增强携带条件进入评测。读取 [nfr-evidence.md](references/nfr-evidence.md) 审核 NFR 证据。
8. **交接发布**：把测试报告、准出结论、遗留风险、回滚关注点和线上验证项交给 `release-regression-gatekeeper`；发布后将逃逸问题回流用例、监控和流程改进。

## 门禁判定

在做准入、暂停、准出或结束判定前，必须读取 [process-policy.md](references/process-policy.md)。按以下状态之一输出，不使用“基本通过”：

- `通过`：全部强制条件有证据且无不可接受风险。
- `有条件通过`：仅存在规范允许遗留的非阻塞项，并已记录风险、补偿措施、责任人和期限。
- `不通过`：强制门禁失败，或仍有不得遗留的缺陷/风险。
- `暂停`：命中暂停条件，继续执行无法产生可信结果或会扩大风险。
- `待补证据`：信息不足以判定；列出最小补充材料。

同时输出机器态，不允许静默映射：`通过 -> PASS`、`有条件通过 -> PASS_WITH_ACCEPTED_RISK`、`不通过 -> FAIL`、`暂停 -> PAUSED`、`待补证据 -> BLOCKED`。`PASS_WITH_ACCEPTED_RISK` 必须携带风险批准、适用范围、补偿、责任人和期限；下游不能把它当作普通 `PASS`。

缺陷严重度 P0/P1 未修复并回归通过时不得给出“通过”或“有条件通过”。紧急流程可以压缩评审和回归范围，但不能省略修复点验证、核心冒烟、回滚预案、线上验证和事后复盘。

## 输出契约

先给结论和最关键依据，再给明细。至少包含：

1. 当前阶段与门禁状态。
2. 已验证事实、缺失证据和阻塞项。
3. 阶段台账或准入/准出检查结果。
4. NFR 适用时提供阈值配置、环境/负载、结果、证据可信度和发布交接。
5. 缺陷与遗留风险，包括等级、影响、责任人、期限和补偿措施。
6. 下一步、负责人和重新判定条件。

需要生成缺陷单、阶段台账或测试报告时，读取 [templates.md](references/templates.md) 并保持字段完整；不要编造执行数量、通过率、审批或证据链接。

## 参考文件路由

- 门禁、阶段差异、缺陷分级、暂停/结束或角色职责：读取 [process-policy.md](references/process-policy.md)。
- 缺陷记录、阶段台账或测试报告：读取 [templates.md](references/templates.md)。
- NFR 阶段就绪度、执行证据、问题分域、准出和交接：读取 [nfr-evidence.md](references/nfr-evidence.md)。
