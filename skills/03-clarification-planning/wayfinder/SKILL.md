---
name: wayfinder
description: Map a multi-session effort with an unknown route as dependency-linked decision tickets. Use for decision fog and stop when the path is clear; use $to-tickets when the route is known and only implementation slices remain.
---

# Wayfinder

Wayfinding produces decisions, not the destination itself. The canonical artifact is one map on the configured issue tracker with child decision tickets. Refer to maps and tickets by linked title rather than bare identifiers.

If tracker conventions are missing, run `$configure-engineering-skills`. Read `docs/agents/issue-tracker.md` for provider-specific map, child, blocking, frontier, claim, and resolution operations.

Core rules:

- The map is an index: each detailed answer lives in exactly one ticket; the map stores only a linked one-line gist.
- A ticket is one decision or investigation sized to one agent session.
- The frontier is the open, unblocked, unclaimed child tickets.
- Claim a selected ticket before doing work so concurrent sessions skip it.
- Resolve at most one non-research ticket per session.

Read [references/wayfinding-model.md](references/wayfinding-model.md) when classifying tickets, handling fog, or changing scope. Use [assets/map-template.md](assets/map-template.md) and [assets/ticket-template.md](assets/ticket-template.md) when creating tracker artifacts.

## Chart a map

1. Use `$grilling`, plus its documented `$domain-modeling` mode when appropriate, to define a one- or two-line destination. The destination fixes scope.
2. Explore breadth-first to identify precise questions available now and coarser in-scope fog. If the complete route fits one session and no fog remains, stop and recommend a smaller workflow.
3. Create the map with destination, standing notes, an empty decision index, current fog, and explicit out-of-scope items.
4. Create every precise ticket now visible, then add blocking edges in a second pass after identifiers exist.
5. Delegate independent research tickets through `$research` when concurrency is available; otherwise leave them on the frontier.
6. Stop after charting. Do not resolve a decision ticket in the same session.

## Work through a map

1. Load the map as the low-resolution view; fetch full linked tickets only as needed.
2. Use the user's named ticket, or choose the first frontier ticket, and claim it before any other write.
3. Resolve it with the ticket-type workflow and any skills named in the map notes.
4. Post the answer as the resolution, close the ticket, and append a linked one-line gist to the decision index.
5. Create and wire newly visible tickets, graduate newly precise fog, and close anything now proven beyond the destination as out of scope.

Expect concurrent tracker edits. Re-read affected map state before each write and never replace another session's resolved answer with a stale local view.
