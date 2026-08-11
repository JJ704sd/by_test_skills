---
name: test-process-governor
description: 编排功能测试和通用确定性 NFR 的生命周期、阶段证据与门禁，判断 build 能否进入、暂停或准出测试，以及测试执行或生命周期能否关闭。用于测试流程规划、当前阶段审计或“完整测试”请求；不拥有测试范围、工具选型、Agent 非确定性质量或生产发布、灰度和回滚决策。
---

# 测试流程治理

维护从需求评审到测试准出的阶段链路、证据和门禁。测试准出由本技能给出；是否改变生产流量不属于本技能。

交付模式：`gate_only` 判断一个当前决策点；`stage_packet` 治理当前阶段；`full_lifecycle` 仅在用户要求完整规划/审计或跨阶段缺口会改变结论时使用。

## 工作流

1. 确认版本/build、当前阶段、范围、环境、阈值、用例和证据快照，只记录变化。
2. 按 [process-policy.md](references/process-policy.md) 建立当前门禁、阶段或全生命周期台账。
3. 检查范围、判据、数据、环境和 NFR 计划的就绪度；NFR 读取 [nfr-evidence.md](references/nfr-evidence.md)。
4. 治理提测准入、核心冒烟、系统测试、缺陷、修复点和影响面回归。
5. 判定测试准出，核对完成度、P0/P1、产品验收、NFR、报告和遗留风险。
6. 按 [templates.md](references/templates.md) 输出门禁、证据快照或台账，并把测试报告和回滚关注点交给 `$release-regression-gatekeeper`。

## 硬门禁

- 缺失证据不能推定通过；环境或构建使结果不可信时暂停。
- P0/P1 未修复并回归通过时，不得通过或有条件通过。
- `PASS_WITH_ACCEPTED_RISK` 必须带批准、范围、补偿、责任人和期限。
- 紧急流程可压缩评审和范围，但不能省略修复点、核心冒烟、回滚预案、线上验证和复盘。
- 执行进度、测试准出和生命周期关闭是独立状态，不能互相推定。
- 没有执行授权时只给门禁结论和操作清单，不声称动作已完成。

范围和用例使用 `$test-scope-case-designer`，工具、环境和权限使用 `$test-tool-governor`，Agent 非确定性质量使用 `$agent-nondeterministic-evaluator`。输出先给当前门禁、关键证据、首个硬阻塞和重新判定条件。
