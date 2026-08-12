---
name: codebase-design
description: Discover and rank architecture candidates across a repository or broad subsystem, or design interfaces, seams, adapters, module and trust boundaries for a selected area. Use scan mode for wide discovery and design mode only after an area is selected; do not use for production implementation.
---

# Codebase Design

Use exactly one mode per request:

- **Scan mode**: discover and rank architecture candidates across a repository or broad subsystem, then produce a visual report.
- **Design mode**: design substantial behavior behind a small, explicit interface for one already-selected area.

If a scan identifies a promising candidate, report it and stop. Enter design mode only on a new user request that selects the area; never turn discovery into an implicit refactor or detailed design.

## Vocabulary

- **Interface**: everything callers must know, including inputs, invariants, ordering, errors, configuration, performance, and security constraints.
- **Depth**: useful behavior gained per unit of interface callers must learn.
- **Seam**: a boundary where behavior genuinely needs to vary without editing callers.
- **Adapter**: a concrete implementation of a seam.
- **Locality**: keeping related knowledge, change, bugs, and verification in one module.

## Scan mode

1. Follow the broad subsystem or recurring pain point named by the user. Otherwise inspect recent history for repeatedly changed paths and begin with those hot spots.
2. Read repository instructions, `CONTEXT.md`, relevant ADRs, callers, and tests. Do not re-litigate an ADR without current contrary evidence.
3. Find concepts spread across shallow modules, interfaces nearly as complex as their implementations, behavior extracted only for testability, leaking dependencies, and code without a stable public test surface.
4. Apply the deletion test. Classify dependencies coarsely as in-process, local-substitutable, remote-owned, or external; defer interface and seam design.
5. Rank each candidate by evidence, expected locality, leverage, test-surface gain, migration risk, and ADR conflict. Label it `Strong`, `Worth exploring`, or `Speculative`.
6. Read [references/html-report.md](references/html-report.md), write one offline-readable HTML report to the OS temporary directory, and end with one top recommendation. Open it when permitted; otherwise return its absolute path.

Do not modify code, domain documents, issues, or ADRs in scan mode. Ask which candidate the user wants to explore, but do not begin design mode in the same request.

## Design mode

1. Read repository instructions, `CONTEXT.md`, governing specs, relevant ADRs, callers, tests, and deployed topology when relevant.
2. Build the smallest dependency and trust-boundary graph that exposes callers, state, replaceable dependencies, and verification seams. Keep it task-local unless durable documentation is requested.
3. State caller-visible behavior and constraints before proposing types or abstractions.
4. Define the smallest interface that fully expresses those needs, including error and timing behavior callers must handle.
5. Place seams only where variation is real. Accept remote or replaceable dependencies at the boundary.
6. Read [references/deepening.md](references/deepening.md) when consolidating shallow modules or crossing I/O, process, or network boundaries.
7. For authentication, authorization, secrets, untrusted input, tenant isolation, privileged operations, or new exposure, read [references/security-design.md](references/security-design.md) and derive security invariants before settling the contract.
8. Treat the public interface and approved invariants as the primary test surface; keep implementation details private.
9. When alternatives matter, read [references/design-it-twice.md](references/design-it-twice.md) and compare materially different contracts.
10. Report one final recommendation covering the contract, dependency strategy, migration path, leverage, locality, trade-offs, verification seams, and unresolved risks. Write a durable design only when requested and the destination is identified or approved.

For a consequential design, independent subagents may derive alternatives from the same context capsule: pinned evidence, caller constraints, relevant paths, allowed read/write scope, expected evidence, and stop budget. One integrator compares them against the constraints, resolves conflicts from primary evidence, and owns the recommendation. Do not use majority vote or let workers concurrently edit one design draft.

## Guardrails

- Apply the deletion test: if removing a module only removes indirection, it is shallow; if complexity spreads into callers, it earns its place.
- Do not add a seam or threat control for hypothetical variation. Require concrete caller needs or plausible attack paths.
- Prefer fewer entry points and simpler parameters, but never hide constraints callers must understand.
- Freeze a constraint checkpoint before recommending implementation. Invalidate affected alternatives when the spec, topology, trust boundary, or pinned repository input changes.
- Use `$elicit-stakeholder-input` in `live` mode when the blocker is an undiscoverable judgment held by the current user.
- Use `$evolving-contracts` when old and new public, persisted, or dependency versions must coexist.
- If the design is settled and implementation is requested, use normal implementation or `$tdd` when test-first work is desired.
