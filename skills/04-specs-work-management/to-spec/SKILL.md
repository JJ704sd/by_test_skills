---
name: to-spec
description: Synthesize a settled conversation and codebase context into a parent specification on the configured tracker. Use after discovery; allow at most one bounded test-seam confirmation. Use $grilling when product decisions remain and $to-tickets only after the route is known.
---

# To Spec

If tracker conventions are missing, run `$configure-engineering-skills` first.

1. Gather the settled conversation, relevant codebase state, domain glossary, and ADRs. If material behavior or scope is still undecided, stop and recommend `$grilling` rather than inventing an answer.
2. Identify the highest stable seam at which the feature's external behavior can be verified. Prefer an existing seam and minimize new ones.
3. Present the proposed seam in one bounded confirmation. Do not turn this into a new discovery interview; record unresolved disagreement as an explicit assumption or return to `$grilling`.
4. Draft the specification with [assets/spec-template.md](assets/spec-template.md). Cover every known behavior and edge case without padding the document with repetitive user stories.
5. Publish the specification to the configured issue tracker and apply the configured `ready-for-agent` role unless the user directs otherwise.

Use canonical domain terms. Avoid file paths and implementation snippets that will go stale. A short prototype-derived state machine, schema, reducer, or type shape may be included when it expresses a settled decision more precisely than prose; label its origin and retain only the decision-bearing portion.

Report the published location, the confirmed test seam, and any assumptions that remain visible in the spec.
