---
name: tdd
description: Implement known behavior or a verified bug fix through a public seam using red-green-refactor. Use when the user explicitly requests TDD or test-first work, or when a known regression should be locked down before repair; use $diagnosing-bugs when the root cause is still unknown.
---

# Test-Driven Development

Deliver one observable behavior at a time through a stable public seam.

Read `CONTEXT.md`, the governing spec, and relevant ADRs when present so test language matches the domain.

## Establish the seam

Identify the public interface through which a caller observes the behavior. Derive it from the spec and codebase when clear; ask the user only when choosing a different seam would materially change scope or architecture.

Use $codebase-design before TDD when the interface shape itself is unresolved. Do not create tests against private methods or internal collaborators merely because they are convenient.

## Red-green-refactor

Repeat for one vertical slice:

1. **Red**: write the smallest test that describes one observable behavior. Run it and confirm it fails for the expected reason.
2. **Green**: implement only enough production code to pass that test. Run the focused test again.
3. **Refactor**: improve names, duplication, and structure without changing behavior. Keep the suite green after every change.

Let each completed slice inform the next. Do not write all tests first or build layer by layer.

## Test quality

- Assert outcomes callers care about, not call counts or private state.
- Derive expected values from the spec, a worked example, or another independent source—not the implementation under test.
- Prefer real in-process collaborators and realistic local stand-ins.
- Replace only true external boundaries or nondeterministic sources such as time and randomness.
- Avoid speculative cases and abstractions that the current behavior does not require.

Read [references/tests.md](references/tests.md) when evaluating a proposed test or choosing a boundary substitute.

## Verification

Run the focused test on every cycle. Regularly run the smallest relevant test group and typecheck or equivalent static checks. At completion, run the broader project checks that are safe and relevant to the change.

Report the seam used, behaviors added, checks run, and any residual risk. Use $review-code-against-spec only when the user requests a fixed-point Standards/Spec review.
