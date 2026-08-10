# 贡献指南

## 新增技能

1. 根据使用场景选择 `skills/NN-kebab-case/`；只有出现稳定且不同的新场景时才新增场景目录。
2. 在场景目录下创建 kebab-case 命名的技能目录。
3. 添加包含 YAML frontmatter 的 `SKILL.md`；其中 `name` 必须与技能目录名一致，`description` 应说明触发场景和职责边界。
4. 添加 `agents/openai.yaml`，至少包含 `display_name` 和 `short_description`；需要固定调用入口时再添加 `default_prompt`。
5. 仅在需要时添加 `references/`、`scripts/` 或其他配套文件，并确保 `SKILL.md` 使用相对路径引用。
6. 更新 `docs/skills-distribution.md` 的场景、描述、路径和统计。

## 调整场景

- 场景目录使用连续的两位编号和 kebab-case 名称，例如 `03-clarification-planning`。
- 移动技能时必须整包移动技能目录，保留其中的 Agent 元数据、参考资料、脚本和模板。
- 若插入、删除或重排场景，同步更新后续编号、README、分布文档及所有仓库内链接。
- 技能名在整个仓库中保持唯一，即使它们位于不同场景包。

## 提交前检查

```powershell
# Windows PowerShell
powershell -ExecutionPolicy Bypass -File scripts/Test-Skills.ps1

# PowerShell 7+
pwsh -File scripts/Test-Skills.ps1
git status --short
git diff --check
```

提交应聚焦单一目的，并避免把 `tmp/`、编辑器设置或生成物纳入版本控制。
