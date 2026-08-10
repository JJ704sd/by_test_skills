# 贡献指南

## 新增技能

1. 在 `skills/` 下创建 kebab-case 命名的一级目录。
2. 添加包含 YAML frontmatter 的 `SKILL.md`；其中 `name` 必须与目录名一致，`description` 应说明触发场景和职责边界。
3. 添加 `agents/openai.yaml`，至少包含 `display_name` 和 `short_description`；需要固定调用入口时再添加 `default_prompt`。
4. 仅在需要时添加 `references/`、`scripts/` 或其他配套文件，并确保 `SKILL.md` 使用相对路径引用。
5. 更新 `docs/skills-distribution.md` 的分类、描述和统计。

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
