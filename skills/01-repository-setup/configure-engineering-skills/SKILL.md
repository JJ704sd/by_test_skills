---
name: configure-engineering-skills
description: Configure a repository for the engineering skills by recording its issue tracker, optional triage labels, and domain-document layout. Use once before tracker-backed skills, or later when those repository-level choices change.
---

# Configure Engineering Skills

Inspect first, preview the exact result, obtain confirmation, then write. Preserve unrelated content and update existing configuration in place.

1. Inspect the remote, root `AGENTS.md`/`CLAUDE.md`, `docs/agents/`, `.scratch/`, domain documents, ADR layout, monorepo signals, and whether `$triage` is available.
2. Resolve only unsettled choices. Prefer the detected remote's tracker; otherwise offer GitHub, GitLab, local Markdown, or a user-described tracker. Configure triage labels only when `$triage` is available. Default domain docs to root `CONTEXT.md` plus `docs/adr/`; use `CONTEXT-MAP.md` only for genuine context boundaries.
3. Show the proposed `## Agent skills` block and every generated `docs/agents/*.md` file. Let the user revise them and do not write before confirmation.
4. After confirmation, edit an existing `CLAUDE.md`; otherwise edit an existing `AGENTS.md`. If neither exists, ask which to create. Replace an existing skills block instead of appending a duplicate.

When an existing tracker document uses a legacy planning representation, keep consuming it unless the user requests migration. Preview the old-to-new mapping and affected external labels before changing repository configuration; tracker label or issue mutations require separate authorization.

Load only the assets selected by those choices:

- [Agent skills block](assets/agent-skills-block.md)
- [GitHub tracker](assets/issue-tracker-github.md)
- [GitLab tracker](assets/issue-tracker-gitlab.md)
- [local Markdown tracker](assets/issue-tracker-local.md)
- [triage labels](assets/triage-labels.md), only when `$triage` is available
- [domain-doc configuration](assets/domain.md)

For another tracker, draft its document from the user's description. Stop after listing changed files and noting that the configuration can be edited directly later.
