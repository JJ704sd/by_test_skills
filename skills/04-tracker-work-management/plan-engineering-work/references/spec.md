# Spec mode

1. Gather the settled conversation, relevant codebase state, domain glossary, and ADRs. If material behavior or scope remains undecided, stop and recommend `$elicit-stakeholder-input` live mode for a bounded judgment or map mode for multi-session decision fog.
2. Identify the highest stable seam at which the feature's external behavior can be verified. Prefer an existing seam and minimize new ones.
3. Present the proposed seam in one bounded confirmation. Do not turn this into a new discovery interview; record explicitly accepted uncertainty as an assumption or return to the appropriate discovery mode.
4. Draft the specification from the selected template. Cover every known behavior and edge case without padding it with repetitive user stories.
5. Publish the specification to the configured issue tracker without `ready-for-agent` or another implementation-ready role. Only independently executable child tickets created in slice mode may receive that role.

Use canonical domain terms. Avoid volatile file paths and implementation snippets. A short prototype-derived state machine, schema, reducer, or type shape may be included when it expresses a settled decision more precisely than prose; label its origin and retain only the decision-bearing portion.

Report the published location, confirmed test seam, and assumptions. Stop after publishing the parent specification; do not create implementation tickets in the same invocation.
