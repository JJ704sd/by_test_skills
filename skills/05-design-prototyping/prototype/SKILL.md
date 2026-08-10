---
name: prototype
description: Build throwaway prototypes that answer one design question. Use for an interactive logic, state, or data-shape experiment, or for comparing materially different UI layouts and interactions; not for production implementation, bug reproduction, or polishing a settled design.
---

# Prototype

A prototype is disposable code that makes one design question concrete.

## Choose the branch

- For business logic, state transitions, or data shape, read [references/logic.md](references/logic.md).
- For visual layout, information hierarchy, or interaction alternatives, read [references/ui.md](references/ui.md).
- If the question is ambiguous, infer from the surrounding code and state the assumption in the artifact. Ask only when choosing the wrong branch would materially change the work.

## Rules for both branches

1. State the single question the prototype must answer.
2. Mark the code clearly as a prototype and keep it close to the module or page it explores.
3. Make it trivial to run using the project's existing conventions.
4. Keep state in memory and mutations local or stubbed unless persistence itself is the question.
5. Skip production polish, speculative abstractions, and broad error handling.
6. Show the relevant state in a logic prototype and the active variant in a UI prototype.
7. Treat any code promoted to production as a new implementation that needs normal tests and review.

Do not create branches, commit, update issues, or retain prototype artifacts unless the user or an established workflow explicitly requests it. Do not delete user-owned artifacts during cleanup.

When the question is answered, report the decision and evidence. If persistence is requested, preserve only the decision-rich artifact and record where it lives.
