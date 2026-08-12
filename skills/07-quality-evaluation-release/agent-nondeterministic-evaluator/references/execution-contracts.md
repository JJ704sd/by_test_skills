# 评测快照契约

`snapshot_id` 绑定 Agent 清单、用例基线、派生数据集、threshold/NFR/sampling profile、环境、runner、Judge、重试和证据窗口。绑定项变化只失效依赖它的缓存与结论；数据集转换不得反向修改批准的场景意图和判据。

状态轴保持独立：

- `mode_execution_status` 描述本次模式是否完成、待评审或阻断。
- `offline_gate` 只描述离线证据结论。
- `baseline_candidate_status` 只描述首版基线批准状态。
- `online_quality_signal` 只描述在线观察，不代表生产动作。
- `actor_authorization` 只记录外部授权，不替代发布门禁。

`preflight` 不产生离线门禁；`impacted` 成功不能 `PASS`，但批准子集的硬失败可 `FAIL`；只有 `required_gate` 可 `PASS`。`online_monitor` 必须引用适用的离线 `PASS` 和当前发布许可，且不生成新离线结论。

使用 [评测模板](../assets/evaluation-templates.md) 时记录计划/有效运行、技术/语义失败、失败样本、人工复核、artifact、阻塞和失效条件。最终化前不得残留空 profile 或虚构批准；零结果也要有分母、窗口和证据。
