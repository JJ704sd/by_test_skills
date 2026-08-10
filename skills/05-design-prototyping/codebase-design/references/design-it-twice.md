# Design It Twice

Use this process to compare materially different interfaces for an already selected module.

## Frame the problem

Record:

- caller needs and constraints;
- invariants, ordering, errors, and performance expectations;
- dependency categories from [deepening.md](deepening.md);
- what should remain hidden behind the seam.

Use a small illustrative sketch only to ground the constraints, not as the preferred answer.

## Generate alternatives

Produce at least three independent designs. Use parallel sub-agents when available; otherwise draft them sequentially and deliberately reset assumptions between drafts.

Give each design a different objective:

1. Minimize the interface and maximize leverage per entry point.
2. Maximize extension flexibility without speculative hooks.
3. Optimize the common caller so its default path is trivial.
4. When relevant, optimize explicitly for a remote or external seam.

For each design provide:

- the full interface contract;
- a caller example;
- hidden implementation responsibilities;
- dependency and adapter strategy;
- trade-offs and failure modes.

## Compare

Compare depth, locality, seam placement, caller effort, and change cost. Recommend one option or a justified hybrid; do not present an unranked menu.
