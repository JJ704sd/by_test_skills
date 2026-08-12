# Issue tracker: GitLab

Issues and specifications for this repository live as GitLab issues.

## Access

Prefer an available authenticated GitLab connector or API that covers the operation. Fall back to the authenticated `glab` CLI when the connector is unavailable or lacks a required command. Before every write, verify the project, issue or merge request, intended mutation, and current authorization; never move credentials into commands or files.

## Request surfaces

- Issues are the default inbound and publishing surface.
- **MRs as a request surface: no.** Set this to `yes` only when external merge requests should enter triage.
- When enabled, triage non-maintainer MRs; an explicitly named MR remains eligible.

Read full descriptions, notes, labels, authors, dates, and diffs when relevant. Use connector/API operations first; CLI fallbacks include `glab issue view/list/create/note/update/close` and the corresponding `glab mr` commands.

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

- Represent a map as one labelled issue and each ticket as a child relationship when available; otherwise put `Part of #<map>` in each child.
- Prefer native blocking links; otherwise use a `Blocked by: #<n>` line. A ticket is ready only when every blocker is closed and it is unclaimed.
- Claim with the configured assignee mechanism before work. Resolve by recording the answer, closing the child, and appending a linked one-line gist to the map.

When a skill says “publish to the tracker,” create an issue. When it says “fetch a ticket,” read the full issue and notes. Use the configured labels rather than assuming these defaults after a repository customizes them.
