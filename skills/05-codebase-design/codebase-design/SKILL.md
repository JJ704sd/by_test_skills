---
name: codebase-design
description: Discover and rank architecture candidates across a repository or broad subsystem, or design interfaces, seams, adapters, module and trust boundaries for a selected area. Use scan mode for wide discovery and design mode only after an area is selected; do not use for production implementation.
---

# Codebase Design

Choose exactly one mode:

- **Scan mode**: discover and rank architecture candidates across a repository or broad subsystem, then produce a visual report.
- **Design mode**: design substantial behavior behind a small, explicit interface for one already-selected area.

Pin the repository revision, governing specs and ADRs, caller constraints, and relevant topology. If any pinned input or trust boundary changes, invalidate affected conclusions before continuing. A scan stops after reporting candidates; design starts only from a new request selecting one area.

## Scan mode

1. Inspect the requested subsystem or evidence-backed hot spots, plus repository instructions, domain docs, ADRs, callers, and tests. Do not re-litigate an ADR without contrary evidence.
2. Find scattered concepts, shallow modules, leaky dependencies, interfaces as complex as implementations, and missing stable test surfaces. Apply the deletion test and classify dependencies without designing seams yet.
3. Rank candidates by evidence, locality, leverage, test-surface gain, migration risk, and ADR conflict.
4. Follow the [HTML report format](references/html-report.md), write one offline-readable report to the OS temporary directory, and end with one top recommendation.

Do not modify code or durable documents in scan mode. Return the report path and stop.

## Design mode

1. State caller-visible behavior and constraints, then build the smallest dependency and trust-boundary graph exposing callers, state, dependencies, and verification seams.
2. Define the smallest complete interface, including errors, ordering, timing, configuration, performance, and security behavior callers must handle.
3. Place seams only at real variation. Read [deepening guidance](references/deepening.md) for shallow modules or I/O boundaries and [security guidance](references/security-design.md) for a trust boundary or sensitive behavior.
4. Treat the public interface and approved invariants as the primary test surface. When alternatives matter, use [design-it-twice](references/design-it-twice.md) and compare materially different contracts.
5. One owner resolves alternatives against primary evidence and writes the final recommendation or requested durable design. Stop before implementation.

## Guardrails

- A module earns its place only when deleting it spreads meaningful complexity into callers.
- Require a real caller need or plausible attack path before adding a seam or control.
- Use `$elicit-stakeholder-input` in `live` mode when the blocker is an undiscoverable judgment held by the current user.
- Use `$evolving-contracts` when old and new public, persisted, or dependency versions must coexist.
- After the design is settled, use normal implementation or `$tdd` only on a separate implementation request.
