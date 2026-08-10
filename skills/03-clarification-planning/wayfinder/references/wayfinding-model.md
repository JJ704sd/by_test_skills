# Wayfinding Model

## Ticket types

- **Research — AFK:** Find a verifiable fact in documentation, APIs, source code, or other primary material. Resolve through `$research`.
- **Prototype — HITL:** Create a cheap concrete artifact for the user to react to when appearance or behavior cannot be settled on paper. Use `$prototype` when code or UI is required.
- **Grilling — HITL:** Resolve a decision in live conversation through `$grilling`; use documented mode when domain terms or ADRs should persist.
- **Task — AFK or HITL:** Complete prerequisite work that reveals facts needed by a later decision. It belongs on the map only when it unblocks a decision rather than delivering the destination.

A HITL ticket cannot be resolved by the agent answering on the human's behalf.

## Fog of war

Fog is in-scope uncertainty that cannot yet be phrased as a precise question. Put it in **Not yet specified**, not in a premature ticket.

- Create a ticket when the question is precise now, even if blocked.
- Keep fog when dependencies prevent stating the real question.
- After a resolution, graduate only the newly precise parts into tickets and remove those parts from the fog.

The fog excludes closed decisions, live tickets, and out-of-scope work.

## Out of scope

Out-of-scope work sits beyond the destination; it never graduates through the frontier. If an existing ticket proves out of scope, close it and add a linked one-line reason under **Out of scope**. Do not add it to **Decisions so far**.

Revisit an out-of-scope item only by redrawing the destination or starting a new effort.
