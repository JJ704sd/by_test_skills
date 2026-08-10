---
name: codebase-design
description: Design or compare interfaces, seams, and adapters for a selected module. Use when its test surface or alternative designs must be shaped; use $review-codebase-architecture for codebase-wide discovery.
---

# Codebase Design

Design a deep module: substantial behavior behind a small interface at a clean seam, testable through that interface.

## Vocabulary

- **Module**: anything with an interface and implementation, at any scale.
- **Interface**: everything callers must know, including invariants, ordering, errors, configuration, and performance.
- **Depth**: behavior gained per unit of interface callers must learn. Deep modules hide much behind little; shallow modules mostly pass through.
- **Seam**: the place where behavior can vary without editing the caller.
- **Adapter**: a concrete implementation that satisfies an interface at a seam.
- **Leverage**: capability reused across callers and tests through one interface.
- **Locality**: change, knowledge, bugs, and verification concentrated in one module.

Use these terms consistently when the module shape is the subject.

## Workflow

1. Identify the callers, behavior, constraints, and domain terms. Read `CONTEXT.md` and relevant ADRs when present.
2. Define the smallest interface that fully expresses caller needs, including invariants and error modes.
3. Place the seam where behavior genuinely varies. Accept dependencies rather than constructing them inside the module.
4. Classify dependencies before choosing adapters. Read [references/deepening.md](references/deepening.md) when consolidating shallow modules or crossing I/O and network seams.
5. Test through the external interface. Keep implementation details and internal seams private.
6. When the user wants alternatives, read [references/design-it-twice.md](references/design-it-twice.md) and compare materially different designs.
7. Recommend one design and state its leverage, locality, dependency strategy, and trade-offs.

## Principles

- Apply the deletion test: if removing a module only removes indirection, it is shallow; if complexity spreads back into callers, it earns its place.
- Treat the interface as the test surface. Wanting to test past it is evidence that the module may have the wrong shape.
- Require justified variation before adding a seam. A production and test adapter can justify one; a single adapter usually cannot.
- Prefer fewer entry points and simpler parameters, but never hide constraints callers must know.
