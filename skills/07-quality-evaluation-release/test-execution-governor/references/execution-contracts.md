# 状态与快照契约

同一 `project_version + scope + decision_point` 只维护一份活动快照并保留历史。`snapshot_id` 绑定 build、范围、工具选型、授权、用例、环境、配置、threshold/profile 和证据窗口；绑定项变化只重验依赖它的结论。

六个状态轴保持独立：

- `selection_decision`：工具是否适用。
- `execution_authorization`：是否获权执行具体动作。
- `implementation_progress`：选定能力是否尚未落地、计划中、实施中、已完成或受阻。
- `machine_status`：当前决策点的证据结论。
- `test_execution_status`：动作是否未开始、进行、完成、暂停或阻断。
- `test_lifecycle_status`：生命周期是否开放、可关闭或已关闭。

采用工具不授权执行，实施进度也不证明选择或授权；阶段或执行完成不表示门禁通过；准出只能来自 `EXIT_GATE`；生产发布不能由测试准出推导。依赖新工具时，选型快照、授权状态和授权引用缺一即 `BLOCKED`。

使用 [生命周期模板](../assets/lifecycle-templates.md) 时保留上游引用、artifact、阻塞、接受风险、下一动作和失效条件。已知硬失败或暂停条件优先于未知缺口；数量为零仍需查询范围、窗口和证据。最终化前以事实或 `UNKNOWN` 替换占位符，不声称未执行的动作。
