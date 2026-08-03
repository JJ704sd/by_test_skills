---
name: release-regression-gatekeeper
description: 基于已批准的范围按版本类型、变更影响和风险选择回归层级，并消费功能、NFR/SLO、Agent 与监控证据，治理全量、灰度、Hotfix 的审批、值守、阶段放量、停止、硬回滚和发布关闭。Use when selecting a regression tier from an approved scope, reviewing release evidence, issuing GO/CONDITIONAL_GO/NO_GO/BLOCKED, operating a gray rollout, or responding to a rollback trigger; detailed scenarios and cases belong to the scope skill.
---

# 版本回归与发布门禁

## 职责边界

负责把测试准出证据转化为回归层级、发布方式、灰度阶段、停止/回滚动作和最终发布关闭结论。

产品/业务/架构及适用角色批准 NFR/SLO 与风险接受标准；本技能消费证据并独占发布、放量和回滚决策，不自行发明阈值。

- `test-scope-case-designer` 提供变更影响、风险、范围和用例。
- `test-process-governor` 提供确定性测试准出、缺陷和产品验收证据。
- `test-tool-governor` 提供工具、环境、权限、监控和安全就绪证据。
- `agent-nondeterministic-evaluator` 提供 Agent 离线门禁与在线质量信号。

没有真实部署授权时，只输出决策和操作清单，不声称已经发布、放量、停止或回滚。

## 开始前

收集以下输入；已确认硬门禁失败时给 `NO_GO`（部署前）或 `ROLLBACK`（已部署），证据无法核实时给 `BLOCKED`：

- 版本类型、发布窗口、变更清单、影响范围、风险和用户路径。
- 需求/代码/配置/接口/数据库差异；Agent 还包括 Prompt、模型参数、工具、知识库和 Schema。
- 回归范围、用例版本、执行轮次、缺陷统计、测试准出和产品验收。
- 版本包、发布清单、环境/数据/账号、配置、灰度规则或白名单。
- 回滚包/稳定配置、操作步骤、负责人、预计恢复时间和验证清单。
- 审批链、值守人员、监控/告警、基线、发布群和沟通渠道。
- 生效的 NFR/SLI/SLO/错误预算和阶段阈值清单，含公式、方向、窗口、样本、缺失数据策略、批准人与证据。

规则冲突时仅比较同口径、同适用范围的项目 SLO/门禁与规范默认值，再采用更严格者；不同口径先阻塞并裁定。不得降低核心流程、缺陷严重度 P0/P1、数据、安全、计费或权限门槛。

## 工作流

1. **版本分类**：区分日常迭代、Hotfix、大版本/重构，并确认风险和发布窗口。
2. **确定回归**：按变更、影响、核心链路、接口依赖、历史缺陷和高频用户路径选择 smoke/core/full；读取 [regression-model.md](references/regression-model.md)。
3. **检查回归门禁**：核对准入、执行、缺陷、产品确认、NFR/Agent 证据和输出物。核心流程或缺陷严重度 P0/P1 不满足时立即 `NO_GO`。
4. **选择发布方式**：低风险日常版可全量；高风险、影响面大、大版本或 Agent 核心变更必须灰度；生产缺陷严重度 P0/P1 且常规恢复无效时才走 Hotfix。
5. **完成发布审批与准备**：按测试报告/申请 -> 产品 -> 测试负责人 -> 项目负责人 -> 运维的顺序审批，确认配置、值守、监控、灰度、数据库/Schema 恢复和回滚。读取 [release-gates.md](references/release-gates.md)；涉及 NFR、数据迁移或 SLO 时必须在部署前读取 [nfr-release.md](references/nfr-release.md)。
6. **执行并验证**：按批准方式部署；灰度每阶段记录指标并由测试/运维确认后再推进。发布后按 [release-gates.md](references/release-gates.md) 的窗口完成核心验证和持续观察。
7. **响应异常**：命中阶段阈值或回滚条件时立即停止发布/放量并执行回滚，不等待“自愈窗口”。读取 [rollout-rollback.md](references/rollout-rollback.md)。
8. **关闭与回流**：仅在线上验证通过、监控稳定、无新增缺陷严重度 P0/P1、记录归档、相关人员同步后关闭发布；将逃逸问题回流用例、监控和复盘。

## 不可绕过的门禁

- 新增、修改、修复点及其影响面必须回归；主流程和 `case_priority=CP0/CP1` 场景必须回归。
- 核心用例/流程必须 100% 通过，缺陷严重度 P0/P1 零遗留；没有证据不能推定通过。
- 无审批、发布文档、回归证据、回滚方案、值守或监控时不得发布。
- 高风险或影响面大必须灰度；阶段未确认或指标越界不得继续放量。
- 命中任一硬回滚条件即停止并回滚。若回滚本身技术上不可安全执行，保持停止状态并立即升级事故指挥，不得继续放量。
- Hotfix 先判断配置切换或回滚能否恢复；只有无法恢复且需修复时才进入紧急发布。
- Hotfix 可允许项目负责人正式审批记录事后补录，但部署前必须有可追溯的线上授权、回滚方案和测试/产品确认；不得永久缺失审批。
- `CONDITIONAL_GO` 只能用于非阻塞遗留风险，且必须有补偿措施、责任人和期限；不能绕过上述任何硬门禁。

## 决策状态

- `GO`：全部硬门禁有证据，发布方式和观察/回滚条件已确认。
- `CONDITIONAL_GO`：硬门禁全部满足，仅有已批准的非阻塞风险和补偿计划。
- `NO_GO`：尚未做生产变更时，任一硬门禁失败或风险不可接受；不得开始部署。
- `BLOCKED`：任一阶段证据不足或环境/审批/阈值状态无法核实；不得开始或继续放量。
- `ROLLBACK`：生产变更或灰度已开始后命中任一硬回滚条件；立即停止并按稳定版本/配置恢复。

上游状态不得静默放行：测试 `PAUSED/BLOCKED -> BLOCKED`，`PASS_WITH_ACCEPTED_RISK` 仅在发布责任人重新确认适用风险后才可能 `CONDITIONAL_GO`；Agent `REVIEW_REQUIRED/BLOCKED -> BLOCKED`。测试或 Agent `FAIL` 在部署前映射为 `NO_GO`，已开始生产变更且命中适用硬条件时映射为 `ROLLBACK`。`STOP_RECOMMENDED` 先停止阶段推进，再按阶段和已批准硬条件判 `NO_GO`、保持 `BLOCKED` 或 `ROLLBACK`，不能自动当成已回滚。

在线信号映射：`OK` 只表示没有新增 Agent 在线阻塞，不自动等于 `GO`；`WATCH` 保持当前阶段并继续观察，不得静默推进；`NOT_APPLICABLE` 必须引用范围技能批准的不适用依据，否则为 `BLOCKED`；`STOP_RECOMMENDED` 按上段处理。`mode_execution_status=BLOCKED` 时发布同样为 `BLOCKED`。

## 输出契约

先给状态与最关键依据。至少包含：

1. 版本类型、风险、回归层级和发布方式。
2. 回归范围/排除依据、执行轮次、结果和缺陷统计。
3. 审批、版本包、配置、值守、监控、灰度和回滚就绪度。
4. 当前/计划灰度阶段、生效阈值记录、NFR/SLO/错误预算、观察时长、推进和回滚条件。
5. 决策状态、责任人、下一动作和重新判定条件。
6. 发布后验证、持续观察、关闭或回滚记录要求。

需要正式文档时读取 [templates.md](references/templates.md)；不要编造流量比例、指标、审批、发布时间、操作人或恢复结果。

## 参考文件路由

- 回归原则、Agent/Web 分层、版本矩阵、准入准出：读取 [regression-model.md](references/regression-model.md)。
- 发布窗口、审批、前置条件、上线验证、观察、关闭和角色：读取 [release-gates.md](references/release-gates.md)。
- Agent/Web 灰度、Hotfix、硬回滚触发与执行：读取 [rollout-rollback.md](references/rollout-rollback.md)。
- 回归/发布结论、阶段记录、回滚和关闭文档：读取 [templates.md](references/templates.md)。
- NFR 发布证据、SLO/错误预算、阶段判定和长期观察：读取 [nfr-release.md](references/nfr-release.md)。
