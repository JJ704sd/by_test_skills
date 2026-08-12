---
name: diagnosing-bugs
description: Diagnose unknown failures, flakes, and performance regressions through reproducible evidence, falsifiable hypotheses, profiling, and controlled experiments. Use while the cause or limiting resource is unknown; stop at diagnosis unless repair is explicitly requested.
---

# Diagnosing Bugs and Performance

Finish with a reproduced symptom or workload, verified cause or limiting resource, evidence, uncertainty, and the smallest recommendation. Pin the revision, environment, report, relevant contracts, and baseline before drawing conclusions; invalidate affected hypotheses when those inputs change.

Redact secrets and personal data, keep credentials in configured stores, and request the smallest safe substitute when redaction removes required evidence.

## Build the feedback loop

Reuse an exact loop only after confirming it remains repeatable, safe, authorized, and valid for the pinned inputs. Otherwise choose the smallest loop from [feedback-loop guidance](references/feedback-loops.md); for a known performance workload and objective, use [performance measurement](references/performance.md). When automation is impossible, ask the user for one minimal action and redacted observation at a time in the conversation—do not start a waiting script.

Record the command or workload, redacted signal, and for flakes the sample count and reproduction rate. Build an observation-hypothesis-experiment graph. Keep causal experiments and shared-environment changes serial under one investigator, changing one variable at a time.

## Reproduce and test hypotheses

1. Confirm the observation matches the report and minimize one dimension at a time.
2. Generate three to five ranked hypotheses and name an observation or perturbation that would support or reject each.
3. Test the ranking with debugger, profile, trace, query-plan, or narrowly justified instrumentation evidence.
4. Verify that the leading cause predicts the result, then rerun the original scenario.

Obtain approval before changing production observability. Checkpoint evidence and re-rank after each experiment. If two rounds add no evidence or repeat the same action or error, stop and redesign the loop or request the smallest missing input; a budget stop is not a diagnosis.

## Locate measured bottlenecks

For performance work, compare distributions and profile the limiting resource in a controlled local or test environment. Production profiling, load, observability, or side effects require separate approval, bounded impact, and stop conditions.

## Repair and report

If repair is explicitly authorized, use `$tdd` at the verified public seam; use `$codebase-design` if no honest seam exists. Otherwise stop at diagnosis. Report inputs, reproduction, evidence, checks, uncertainty, residual risk, and recommendation without claiming unrun work.
