---
name: route-engineering-work
description: Route an engineering request to the smallest fitting skill or workflow. Use when the user is unsure how to start, which skill owns the work, or where one phase should hand off to another; do not invoke when the requested skill or action is already clear.
---

# Route Engineering Work

Choose the narrowest entry point that matches the user's current uncertainty. Recommend one primary next step, explain the boundary in one sentence, and avoid replaying the downstream skill's full workflow.

## First-time setup

If `docs/agents/issue-tracker.md` is missing and the workflow needs issues, specs, or triage state, start with `$configure-engineering-skills`.

## Route by situation

| Situation | Route |
| --- | --- |
| A plan, decision, or idea needs live pressure-testing | `$grilling`; use its documented mode when domain terms or ADRs should be maintained |
| A large multi-session effort has an unknown route and unresolved decision fog | `$wayfinder` |
| The discussion is settled and needs a durable parent specification | `$to-spec` |
| A known plan or spec needs implementation-sized vertical slices | `$to-tickets` |
| Raw external issues or PRs need classification, verification, or state changes | `$triage` |
| A hard bug has no reliable reproduction or known root cause | `$diagnosing-bugs` |
| A concrete behavior should be implemented test-first | `$tdd` |
| A diff or branch must be checked against standards and a spec | `$review-code-against-spec` |
| The whole repository needs architecture candidates surfaced and ranked | `$review-codebase-architecture` |
| An already-selected module needs interface, seam, or boundary design | `$codebase-design` |
| A runnable artifact is needed to answer one design question | `$prototype` |
| Verifiable facts require primary-source investigation | `$research` |
| Knowledge held by another person must be collected asynchronously | `$to-questionnaire` |
| Domain vocabulary or a durable architectural decision needs updating | `$domain-modeling` |
| A merge or rebase conflict is already in progress | `$resolving-merge-conflicts` |
| Work must move to another person, repository, directory, or harness | `$handoff` |
| Only a human can complete an external setup step | `$wizard` |
| A persistent multi-session learning workspace should be started or resumed | `$run-learning-workspace` |

Ordinary scoped implementation does not need a wrapper skill. Use `$tdd` only when test-first execution is requested, and `$review-code-against-spec` only when a formal review is needed.

## Important boundaries

- `$wayfinder` discovers a route through decision tickets; `$to-tickets` expresses an already-known route as implementation tickets.
- `$triage` handles raw inbound requests; `$to-tickets` creates approved internal work.
- `$research` finds verifiable source facts; `$to-questionnaire` gathers private human knowledge.
- `$review-codebase-architecture` finds candidates; `$codebase-design` designs one selected candidate.

For context-window and phase handoffs, read [references/phase-boundaries.md](references/phase-boundaries.md).
