# Issue tracker: GitHub

Issues and specifications for this repository live as GitHub issues.

## Access

Prefer an available authenticated GitHub connector or API that covers the operation. Fall back to the authenticated `gh` CLI when the connector is unavailable or lacks a required command. Before every write, verify the repository, issue or PR, intended mutation, and current authorization; never move credentials into commands or files.

## Request surfaces

- Issues are the default inbound and publishing surface.
- **PRs as a request surface: no.** Set this to `yes` only when external PRs should enter triage.
- When enabled, triage non-maintainer PRs discovered through author association; an explicitly named PR remains eligible.

Read full bodies, comments, labels, authors, dates, and diffs when relevant. Use connector/API operations first; CLI fallbacks include `gh issue view/list/create/comment/edit/close` and `gh pr view/list/diff/comment/edit/close`.

## Planning representation

```yaml
planning:
  map_label: planning:map
  type_labels:
    research: planning:research
    prototype: planning:prototype
    stakeholder: planning:stakeholder
    task: planning:task
```

- Represent a map as one labelled issue and its tickets as native sub-issues when available; otherwise use a task list with `Part of #<map>` in each child.
- Prefer native issue dependencies; otherwise use a `Blocked by: #<n>` line. A ticket is ready only when every blocker is closed and it is unclaimed.
- Claim with the configured assignee mechanism before work. Resolve by recording the answer, closing the child, and appending a linked one-line gist to the map.

When a skill says “publish to the tracker,” create an issue. When it says “fetch a ticket,” read the full issue and comments. Use the configured labels rather than assuming these defaults after a repository customizes them.
