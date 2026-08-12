# 开发场景编排提效规范

更新日期：2026-08-12

## 1. 目标与范围

本规范将 task-local graph、evidence loop、checkpoint、context capsule 和受控 subagent fan-out/fan-in 融入八个适用的开发技能：

- `$elicit-stakeholder-input`（`live` 模式）
- `$codebase-design`
- `$tdd`
- `$refactoring-safely`
- `$evolving-contracts`
- `$diagnosing-bugs`
- `$review-code-against-spec`
- `$resolving-merge-conflicts`

这些机制是各技能内部的执行策略，不是额外的元路由技能，也不取代 Codex 的普通实现能力、用户授权或仓库规则。

## 2. 共同不变量

1. **先图后并行**：先识别依赖、当前 frontier 和读写集合，再决定是否 fan-out。
2. **固定输入**：并行节点使用相同的 revision、diff、spec、复现条件或兼容矩阵；输入改变后重验旧结论。
3. **有界并行**：只并行当前 frontier 上彼此独立、可独立验收且预计收益大于调度成本的节点。
4. **写入互斥**：共享接口、生成物、数据、环境和 Git 状态由一个 owner 串行写入。
5. **单一 fan-in 主责**：主责 Agent 核验证据、处理冲突、补覆盖缺口，并独占最终集成与 Git 操作。
6. **证据闭环**：每轮记录目标或假设、动作、观察、相对上一轮的增量，以及下一步或停止原因。
7. **确定性 gate 优先**：测试、规范、原始 diff、运行时信号和用户确认优先于 LLM 投票。
8. **上下文最小化**：下游只接收足以复核的 capsule；原始证据仍可由路径、命令或固定输入定位。
9. **安全和授权不外包**：subagent 不能替用户作业务判断、扩大副作用或绕过审批。
10. **预算不是完成证据**：预算耗尽时报告未覆盖范围，不得把停止描述为通过、诊断或确认。

最小 context capsule：

```text
objective; pinned input/revision; dependencies; constraints;
allowed read/write and side effects; paths or commands;
expected/observed evidence; budget and stop condition; unresolved risks
```

## 3. 场景化执行契约

| 技能 | 工作图或回路 | 关键 gate | 并行边界 |
| --- | --- | --- | --- |
| `elicit-stakeholder-input: live` | decision graph + frontier rounds | 当前用户确认 | 只并行只读事实调查；不委派用户判断 |
| `codebase-design` | dependency + trust-boundary graph | 已冻结的调用者约束和安全不变量 | 可独立生成备选；单一 integrator 综合 |
| `tdd` | behavior-slice graph + red-green-refactor | intended red 与 green checkpoint | 只并行独立 red、互斥写集和状态的 slice |
| `refactoring-safely` | impact graph + migration waves | preservation checkpoint | 互斥路径可并行；删除旧路径和全局证明串行 |
| `evolving-contracts` | producer-reader-storage-deployment graph + compatibility matrix | expand/migrate/observe/contract phase gate | 兼容检查或幂等批次可并行；权威写入和收缩串行 |
| `diagnosing-bugs` | observation-hypothesis-experiment graph | 原始场景复验和因果证据 | 只读证据可并行；因果实验和共享环境变更串行 |
| `review-code-against-spec` | requirements-files-checks coverage map | pinned diff | Standards/Spec 可只读并行；单一报告者去重和补缺口 |
| `resolving-merge-conflicts` | conflict dependency graph + resolution waves | Git 状态、暂存 diff 和检查 | 可只读分析独立冲突；单一 resolver 写入和暂存 |

## 4. 停止与恢复语义

- **无进展**：连续两轮没有新增证据、缩小假设、改变约束或推进验收时，停止重复动作，重设回路或请求最小缺失输入。
- **证据冲突**：回到共同固定输入和一手来源复核，不用多数票替代事实。
- **输入或外部状态变化**：作废受影响的分析，重新固定输入并验证。
- **安全或授权不足**：立即停止相关节点，不以其他 Agent 或替代工具绕过。
- **不可恢复副作用**：执行前提供证据、影响、恢复路径、预算和下一动作，经过既有授权门。
- **checkpoint 不一致**：回到最近验证过的安全边界；不得猜测 cursor、重放写入或拼接部分状态。

节点完成后只允许：

```text
advance | retry-with-new-evidence | serial-takeover | handoff-to-existing-skill | stop
```

## 5. 职责边界

- 普通小范围实现继续使用 Codex 默认能力。
- 行为新增或已验证修复且要求 test-first 时使用 `$tdd`。
- 调用者可见行为必须保持不变时使用 `$refactoring-safely`。
- 新旧公开契约、数据或依赖版本需要共存时使用 `$evolving-contracts`。
- 根因、工作负载或期望行为未知时使用 `$diagnosing-bugs`。
- 生产放量、停止和回滚仍由 `$release-gatekeeper` 决策。
- 需要当前用户提供不可发现判断时使用 `$elicit-stakeholder-input` 的 `live` 模式，不得交给 subagent 猜测。

## 6. 验收标准

- 八个技能保持原触发和停止边界，并具备表中的最小 graph、loop、gate 和 single-writer 契约。
- `SKILL.md` 只承载高频流程；安全、性能、测试、兼容和保全证据位于一层直达的 `references/`。
- 新增、删除或移动技能后，README、分布文档、路由表、元数据和数量预算同步。
- `scripts/Test-Skills.ps1` 校验结构、触发元数据、资源路由、链接、上下文预算及核心提效契约。
- `git diff --check` 与仓库技能校验全部通过。
