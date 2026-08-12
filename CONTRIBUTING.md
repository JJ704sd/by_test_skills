# 贡献指南

## 先判断是否需要新技能

只有存在稳定且独立的用户意图、非显而易见的领域规则、可复用资源或独立授权边界时，才新增技能。

不要新增：

- 只转发到另一个技能的 alias。
- 仅复述 Codex 默认能力的薄包装。
- 与现有技能只有措辞差异、没有职责差异的变体。
- 为单次任务创建的过程文档或临时模板。

优先把新分支合并进现有技能，或放入该技能的 `references/` / `assets/`。

## 新增或修改技能

1. 选择 `skills/NN-kebab-case/` 场景目录；只有出现稳定的新场景时才增加场景组。
2. 使用唯一的 kebab-case 技能名，并让目录名与 frontmatter `name` 完全一致。
3. `SKILL.md` frontmatter 只写 `name` 和 `description`。
4. 在 `description` 中同时说明能力、正向触发和关键排除条件；不要在正文另建 “When to use” 章节。
5. 主文只保留每次调用都需要的流程和硬约束，并控制在 100 行以内。
6. 详细规则、方法和示例放入 `references/`；复制或改造成输出的模板放入 `assets/`；确定性帮助程序放入 `scripts/`。
7. 每个 reference、asset 和 script 都从所属 `SKILL.md` 一层直达；reference 超过 100 行时添加 `## Contents` / `## 目录`，或继续精简。
8. 添加或更新 `agents/openai.yaml`：

   ```yaml
   interface:
     display_name: "Human-facing name"
     short_description: "25-64 character result summary"
     default_prompt: "Use $skill-name to produce the requested result."
   ```

9. 仅显式调用的技能在 `agents/openai.yaml` 使用 `policy.allow_implicit_invocation: false`；不要在 `SKILL.md` 使用 `disable-model-invocation` 或 `argument-hint`。
10. 技能之间的调用统一写成 `$skill-name`。

仓库预算由校验器执行：全部 `SKILL.md` 不超过 500 行 / 40,500 字符；全部配套文本资源不超过 1,900 行 / 76,000 字符；07 质量组 `SKILL.md` 不超过 135 行，配套文本资源不超过 950 行。新增内容应先证明它属于每次必读正文还是按需资源；调整 skill 数量或职责时再以实测基线同步预算，不能用放宽预算掩盖冗余。校验器只证明结构、元数据、链接、资源、编码和预算等静态契约；触发、停止、owner 和授权边界必须用正负请求验证，不得用固定 prose 正则冻结可选 skill 或写法。

## 安全边界

- 不要把 commit、push、发布、生产访问或物质性删除设为普通技能的无条件收尾动作。
- 只修改任务授权范围内的文件；不要 stage unrelated changes。
- 诊断技能默认止于原因和建议，除非用户同时授权修复。
- 生产测试、放量、停止和回滚必须保留各自的授权与证据门禁。
- Bundled `scripts/` 只放非交互、确定性且可安全自动执行的程序；需要人工操作时在会话中逐步请求，用户自行运行的辅助文件放在任务产物而不是 skill scripts。

## 调整场景或名称

- 移动技能时移动完整目录，保留 `agents/`、`references/`、`assets/` 和 `scripts/`。
- 重命名时一次性更新所有 `$skill-name`、相对链接、README、分布文档和默认 prompt。
- 不保留 deprecated alias；在设计 spec 或迁移表中记录旧名即可。
- 场景编号必须连续。插入、删除或重排场景时同步更新后续编号和仓库内链接。

## 提交前检查

```powershell
powershell -ExecutionPolicy Bypass -File scripts/Test-Skills.ps1
powershell -ExecutionPolicy Bypass -File scripts/Test-ValidatorMutations.ps1
git diff --check
git status --short
```

同时至少验证一条应触发和一条不应触发的真实请求。涉及门禁、发布或非确定性评测时，再执行独立前向测试。
