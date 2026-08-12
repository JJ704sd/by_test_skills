---
name: tdd
description: Implement known behavior or a verified bug fix through a stable public seam using red-green-refactor. Use for requested TDD or test-first work, or to lock down a verified regression before repair; use $diagnosing-bugs while the cause or expected behavior remains unknown.
---

# Test-Driven Development

Deliver one caller-observable behavior at a time through a stable public seam.

Pin the baseline, governing behavior, public seam, repository instructions, relevant ADRs, and test conventions before editing. If the behavior, seam, or baseline changes, invalidate the affected slice and re-establish its red state.

## Establish the seam

Identify the interface through which a real caller observes the behavior. Use `$codebase-design` when the interface is unresolved; do not choose private internals for convenience.

## Plan behavior slices

Map acceptance criteria to behavior slices, public seams, focused red commands, paths, and dependencies. One writer owns each shared seam; integrate a slice only after its intended red and focused green evidence are verified.

## Repeat red-green-refactor

1. **Red**: write the smallest behavior test and run it. Confirm it fails because the requested behavior is absent or wrong—not because of syntax, configuration, environment, or an unrelated baseline failure.
2. **Green**: implement only enough production code to pass the new test. Run the focused test again.
3. **Refactor**: improve names, duplication, and structure without changing behavior. Keep relevant tests green after each change.

Do not write the entire test suite first or implement layer by layer. Do not enter green without the intended red. Stop or route to `$codebase-design` or `$diagnosing-bugs` when another attempt would repeat the same failure without new evidence.

Assert caller-visible outcomes using expectations independent of the implementation. Prefer real in-process collaborators and substitute only true external or nondeterministic boundaries. Use [test guidance](references/tests.md) when choosing a seam, oracle, or substitute.

For explicitly behavior-preserving restructuring, use `$refactoring-safely` for the preservation proof instead of inventing a red state.

## Verify and report

Run the focused test every cycle and proportionate broader checks at completion. Report the seam, behavior, red evidence, checks, and residual risk. Do not claim TDD without the intended red; use `$review-code-against-spec` only when separately requested.
