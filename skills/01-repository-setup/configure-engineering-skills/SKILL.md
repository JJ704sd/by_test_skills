---
name: configure-engineering-skills
description: Configure a repository for the engineering skills by recording its issue tracker, optional triage labels, and domain-document layout. Use once before tracker-backed skills, or later when those repository-level choices change.
---

# Configure Engineering Skills

Explore first, present the proposed configuration, obtain confirmation, then write. Update existing configuration in place and preserve unrelated user content.

## 1. Inspect the repository

Check:

- `git remote -v` and `.git/config` for GitHub or GitLab
- root `AGENTS.md` and `CLAUDE.md`, including any existing `## Agent skills` section
- `CONTEXT.md`, `CONTEXT-MAP.md`, `docs/adr/`, and context-scoped ADR directories
- `docs/agents/` and `.scratch/` for an existing configuration
- monorepo signals such as `pnpm-workspace.yaml`, package workspaces, or multiple populated packages
- whether `$triage` is available; label configuration is unnecessary otherwise

## 2. Resolve only unsettled choices

Recommend the detected remote's tracker. Otherwise offer GitHub, GitLab, local Markdown, or a user-described tracker. Record the result in `docs/agents/issue-tracker.md`.

If `$triage` is available, recommend category roles `bug` and `enhancement` plus state roles `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, and `wontfix`. Ask for overrides only when the repository already uses different labels, then write every mapping to `docs/agents/triage-labels.md`.

Default domain docs to a root `CONTEXT.md` plus `docs/adr/`. Offer `CONTEXT-MAP.md` with per-context files only when genuine monorepo boundaries exist. Record the choice in `docs/agents/domain.md`.

## 3. Preview and confirm

Show the exact `## Agent skills` block and generated `docs/agents/*.md` content before writing. Let the user edit the draft.

## 4. Write

Edit `CLAUDE.md` when it exists; otherwise edit `AGENTS.md`. If neither exists, ask which one to create. Never create the other file alongside an existing one, and replace an existing `## Agent skills` block instead of appending a duplicate.

Load only the selected assets:

- [Agent skills block](assets/agent-skills-block.md)
- [GitHub tracker](assets/issue-tracker-github.md)
- [GitLab tracker](assets/issue-tracker-gitlab.md)
- [local Markdown tracker](assets/issue-tracker-local.md)
- [triage labels](assets/triage-labels.md), only when `$triage` is available
- [domain-doc configuration](assets/domain.md)

For another tracker, write the tracker document from the user's description. Finish by listing the files changed and noting that the configuration can be edited directly later.
