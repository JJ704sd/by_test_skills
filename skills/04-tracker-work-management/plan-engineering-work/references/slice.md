# Slice mode

## Gather the approved source

Work from the current conversation or fetch the complete referenced specification or parent issue, including relevant comments. Read domain docs and ADRs, and inspect the codebase when needed to understand existing seams.

If material product decisions remain open, stop. Use `$elicit-stakeholder-input` live mode for a bounded judgment or map mode for multi-session decision fog. Slicing must not disguise decision discovery as implementation work.

## Draft implementation slices

Create the smallest set of end-to-end tracer bullets that covers the approved outcome, then declare only genuine blocking edges. A ticket with no blockers belongs on the initial frontier. Use wide-refactor sequencing only when a mechanical blast radius cannot land green as a vertical slice.

## Confirm the graph

Present a numbered draft containing each ticket's title, blockers, and independently verifiable delivery. Ask whether the granularity and dependency edges are correct, then revise until approved.

## Publish

Publish blockers before dependents using the configured tracker operations. Create one issue per slice and use native blocking relationships when available.

Apply the configured `ready-for-agent` role to independently executable child tickets unless directed otherwise. Never apply that role to the parent specification, and do not close or otherwise modify the parent. Avoid volatile file paths and code snippets, except a short prototype-derived shape that is itself a settled decision.

Report the created tickets and initial unblocked frontier. Stop after publishing the slices.
