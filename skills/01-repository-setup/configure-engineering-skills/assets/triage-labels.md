# Triage Labels

Map every canonical category and state role to the actual label used by this repository's tracker.

## Category roles

| Canonical role | Label in our tracker | Meaning |
| --- | --- | --- |
| `bug` | `bug` | Defect in existing behavior |
| `enhancement` | `enhancement` | New or changed capability |

## State roles

| Canonical role | Label in our tracker | Meaning |
| --- | --- | --- |
| `needs-triage` | `needs-triage` | Maintainer evaluation is pending |
| `needs-info` | `needs-info` | Waiting for reporter information |
| `ready-for-agent` | `ready-for-agent` | Fully specified, ready for an AFK agent |
| `ready-for-human` | `ready-for-human` | Requires human implementation |
| `wontfix` | `wontfix` | Will not be actioned |

When a skill mentions a role, use the corresponding label from these tables. Edit the tracker-label column to match the repository's vocabulary; do not leave a required role unmapped.
