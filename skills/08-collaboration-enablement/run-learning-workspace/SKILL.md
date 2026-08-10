---
name: run-learning-workspace
description: 建立或继续一个持久化、多会话的学习工作区，以学习使命、可信资源、短 HTML 课程、可复用参考和有证据的学习记录推进长期掌握。仅在用户明确要创建或继续当前目录中的长期课程时使用；一次性解释、问答或改写不使用本技能。
---

# 运行持久化学习工作区

## 边界

把当前目录视为课程的单一事实源。读取已有状态后再行动，不覆盖历史，不把“讲过”当成“学会”。使命由用户拥有；更改前先确认。

只为当前学习目标创建或更新教学文件。需要外部事实时优先核验高质量来源并保留引用；不要凭空补写资源、掌握证据或用户偏好。

## 工作区契约

- MISSION.md：学习动机、成功标准和边界；使用 [mission-format.md](references/mission-format.md)。
- RESOURCES.md：可信知识来源与实践社区；使用 [resources-format.md](references/resources-format.md)。
- NOTES.md：明确表达的教学偏好和短期工作笔记。
- lessons/NNNN-slug.html：一次一个可快速完成、可独立打开的 HTML 课程。
- reference/*.html：跨课程复用的速查、算法、图表或术语资料。
- assets/*：课程共享的样式、组件、图表或练习工具。
- learning-records/NNNN-slug.md：已经表现出掌握的非显然知识；使用 [learning-record-format.md](references/learning-record-format.md)。
- GLOSSARY.md：用户已经理解并在课程中统一使用的术语；使用 [glossary-format.md](references/glossary-format.md)。

目录和文件按首次需要懒创建。编号取同类现有文件的最大值加一，不改写旧编号。

## 六步流程

1. **恢复状态**：读取 MISSION.md、RESOURCES.md、NOTES.md、GLOSSARY.md、最新课程、学习记录和可复用 assets；区分已证实掌握、仅接触和仍未知内容。
2. **校准使命**：MISSION.md 缺失时先帮助用户明确现实目标、可观察成功标准和约束；使命变化时先确认，再更新使命并记录变化。
3. **补齐依据**：检查 RESOURCES.md 是否足以支撑下一课；需要时查找并核验一手或高可信来源，记录用途和证据缺口。
4. **选择下一步**：根据使命、已有掌握和反馈选择一个位于最近发展区的小目标。读取 [pedagogy.md](references/pedagogy.md) 设计检索、间隔、交错或反馈。
5. **制作并验证课程**：创建一个短小、自包含的 HTML 课程，复用 assets，链接相关课程和 reference，并为事实提供来源。检查链接、可读性、练习反馈和打印/浏览布局；把文件路径交给用户。
6. **闭环记录**：根据用户实际表现给反馈；只有出现掌握证据时才新增 learning record 或术语。更新必要的 reference、资源缺口、偏好和下一步，不写会话流水账。

## 不变量

- 每课只追求一个与使命直接相关的可观察成果。
- 知识讲解降低无关难度；技能练习使用适度检索难度和及时反馈。
- 先复用 assets；只有第二课也会使用的内容才提取为共享组件。
- 学习记录要求证据，旧认识被修正时标记 superseded，不删除历史。
- 参考资料保持压缩、可扫描；课程不复制已有参考内容。
- 用户拒绝社区、外部活动或特定教学方式时，记录并尊重该偏好。

## 参考路由

- 课程难度、记忆、反馈、来源和社区原则：[pedagogy.md](references/pedagogy.md)
- 使命格式：[mission-format.md](references/mission-format.md)
- 资源格式：[resources-format.md](references/resources-format.md)
- 学习记录格式：[learning-record-format.md](references/learning-record-format.md)
- 术语表格式：[glossary-format.md](references/glossary-format.md)
