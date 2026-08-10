---
name: test-process-governor
description: 编排功能测试和通用确定性 NFR 的生命周期、阶段证据与门禁，判断 build 能否进入、暂停或准出测试，以及测试执行或生命周期能否关闭。用于测试流程规划、当前阶段审计或“完整测试”请求；不拥有测试范围、工具选型、Agent 非确定性质量或生产发布、灰度和回滚决策。
---

# 测试流程治理

## 决策权

维护从需求评审到测试准出的阶段链路、证据和测试门禁；对宽泛请求建立总台账并调用专项技能。产品、业务、架构等适用角色批准 NFR/SLO，本技能只治理确定性执行与证据。

- 范围和用例使用 $test-scope-case-designer。
- 工具、环境和权限使用 $test-tool-governor。
- Agent 采样质量和语义指标使用 $agent-nondeterministic-evaluator。
- 生产回归层级、发布、灰度和回滚使用 $release-regression-gatekeeper。

测试准出由本技能给出；是否改变生产流量不属于本技能。

## 交付模式

- gate_only：只判断一个当前决策点：准入、暂停、准出、执行完成或生命周期关闭。
- stage_packet：治理当前阶段并形成下游交接包。
- full_lifecycle：仅在用户要求完整规划/审计，或跨阶段缺口会改变结论时建立全流程台账。

## 工作流

1. 确认版本/build、当前阶段、变更、范围、环境、阈值、用例和证据快照；只记录相对上一快照的变化。
2. 按交付模式建立当前门禁、阶段或全生命周期台账。
3. 检查范围、风险、判据、用例、数据、环境及 NFR 计划的就绪度；NFR 场景读取 [nfr-evidence.md](references/nfr-evidence.md)。
4. 执行提测准入，验证版本、服务、依赖、环境、账号、权限、数据和自测材料。
5. 先做核心冒烟，再治理系统测试、执行证据、缺陷确认、修复和影响面回归。
6. 判定测试准出，核对完成度、P0/P1、产品验收、NFR 证据、报告和遗留风险。
7. 将测试报告、机器状态、风险、回滚关注点和线上验证项交给 $release-regression-gatekeeper。

## 硬门禁

- 判定前必须读取 [process-policy.md](references/process-policy.md)；缺失证据不能推定通过。
- 先检查 P0/P1、核心冒烟、环境可信度、阈值和审批；环境或构建使结果不可信时暂停。
- P0/P1 未修复并回归通过时，不得给出通过或有条件通过。
- 紧急流程可压缩范围或评审，但不能省略修复点验证、核心冒烟、回滚预案、线上验证和复盘。
- 规则仅在口径、方向和适用范围一致时比较严格度；无法裁定时 BLOCKED。
- PASS_WITH_ACCEPTED_RISK 必须带批准、范围、补偿、责任人和期限，下游不得当作普通 PASS。
- 没有真实执行授权时只给门禁结论和操作清单，不声称测试动作已完成。

## 输出与参考

先给当前门禁、关键证据、首个硬阻塞、最小整改和重新判定条件。人类状态、机器状态、快照字段、台账和报告模板统一读取 references。

- 阶段、准入/暂停/准出、缺陷和状态规则：[process-policy.md](references/process-policy.md)
- 快速答复、证据快照、台账、缺陷单和报告：[templates.md](references/templates.md)
- NFR 就绪度、执行证据和发布交接：[nfr-evidence.md](references/nfr-evidence.md)
