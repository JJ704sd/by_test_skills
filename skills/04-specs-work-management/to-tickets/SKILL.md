---
name: to-tickets
description: Split an approved plan, specification, or settled conversation into dependency-linked implementation tickets that each deliver a verifiable vertical slice. Use when the implementation route is known; use $wayfinder for unresolved decision fog and $triage for raw external requests.
---

# To Tickets

If tracker conventions are missing, run `$configure-engineering-skills` first.

## 1. Gather the approved source

Work from the current conversation or fetch the complete referenced specification or parent issue, including relevant comments. Read domain docs and ADRs, and inspect the codebase when needed to understand existing seams.

If material product decisions are still open, stop. Ticketing must not disguise decision discovery as implementation work.

## 2. Draft implementation slices

Read [references/slicing-patterns.md](references/slicing-patterns.md). Create the smallest set of end-to-end tracer bullets that covers the approved outcome, then declare only genuine blocking edges. A ticket with no blockers belongs on the initial frontier.

Use wide-refactor sequencing only when a mechanical blast radius cannot land green as a vertical slice.

## 3. Confirm the graph

Present a numbered draft containing each ticket's title, blockers, and independently verifiable delivery. Ask whether the granularity and dependency edges are correct, then revise until approved.

## 4. Publish

Publish blockers before dependents using the configured tracker operations:

- For local Markdown, use [assets/local-ticket-template.md](assets/local-ticket-template.md) and create one file per ticket under `.scratch/<feature>/issues/`.
- For a remote tracker, use [assets/issue-template.md](assets/issue-template.md), one issue per ticket, and native blocking relationships when available.

Apply the configured `ready-for-agent` role unless directed otherwise. Do not close or modify the parent issue. Avoid volatile file paths and code snippets, except a short prototype-derived shape that is itself a settled decision.

Report the created tickets and the initial unblocked frontier.
