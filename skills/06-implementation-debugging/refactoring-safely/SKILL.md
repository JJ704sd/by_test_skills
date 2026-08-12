---
name: refactoring-safely
description: Restructure code without changing caller-visible behavior, using invariants, a green baseline, reversible steps, and continuous verification. Use for non-trivial or wide refactors where proof matters; not for local cleanup, behavior changes, unknown defects, or cross-version migrations.
---

# Refactoring Safely

Preserve observable behavior while improving internal structure. Treat “no behavior change” as a claim that requires evidence.

## Fix the preservation boundary

1. Pin the revision, worktree state, scope, governing specs and ADRs, callers, and tests; preserve pre-existing changes.
2. Build an impact graph from definitions to callers, tests, configuration, reflection, generated artifacts, and external formats; use it to order migration waves and expose independent paths.
3. State what must remain unchanged: public inputs and outputs, errors, side effects, ordering, persistence, wire formats, timing guarantees, and supported compatibility where applicable.
4. Separate structural changes from behavior changes. Use `$codebase-design` for an unresolved boundary and `$evolving-contracts` when versions must coexist.

## Establish proof

Run the smallest relevant checks before editing. A failing baseline is not green; isolate it or establish an explicit comparison basis. Use [preservation evidence](references/preservation-evidence.md) when tests are sparse, outputs are large, or changes span many callers.

## Change in reversible steps

One writer owns each shared boundary, generated artifact, and final integration. Keep old-path deletion, global proof, and Git operations serial. After every migration wave, checkpoint the pinned baseline, impact graph, diff, and evidence; if any changes unexpectedly, stop and revalidate affected work before resuming.

1. Make one coherent structural transformation at a time.
2. Keep the tree runnable where possible and prefer language-aware moves over blind replacement.
3. Run focused proof and inspect the diff after every step.
4. Correct only the current step on unexpected evidence; never reset pre-existing work or stack edits on an unexplained failure.
5. Remove obsolete paths only after all callers and checks use the replacement.

Never weaken assertions, update expected outputs, or change public behavior merely to obtain green. If a behavior change is required, stop the refactor boundary and obtain an authoritative requirement; use `$tdd` for the separately approved behavior slice.

## Verify the whole claim

Run focused and proportionate broad checks, comparing external artifacts when tests are insufficient. Report invariants, baseline, transformations, evidence, final checks, and any unproved behavior.
