---
name: diagnosing-bugs
description: Diagnose unknown failures, flakes, and performance regressions through reproducible evidence, falsifiable hypotheses, profiling, and controlled experiments. Use while the cause or limiting resource is unknown; stop at diagnosis unless repair is explicitly requested.
---

# Diagnosing Bugs and Performance

Finish with a reproduced symptom or workload, verified cause or limiting resource, evidence, uncertainty, and smallest recommendation.

Read repository instructions, `CONTEXT.md`, relevant specs, ADRs, history, and nearby tests before forming conclusions.

## Protect evidence

Redact credentials, tokens, cookies, authorization headers, personal data, and sensitive payloads. Keep credentials in configured stores. Request the smallest safe substitute when redaction removes required evidence.

## Build the feedback loop

Reuse an established exact loop only after confirming it still matches the pinned revision and environment and remains repeatable, safe, and authorized. Otherwise, or for a flake, human step, or substitute reproduction, read [references/feedback-loops.md](references/feedback-loops.md) and choose the smallest safe loop. Adapt [scripts/hitl-loop.template.sh](scripts/hitl-loop.template.sh) only when a human step is unavoidable. For a performance regression or unknown bottleneck with a known workload and objective, read [references/performance.md](references/performance.md) instead.

Record the loop's command or workload and redacted signal. Require it to be red-capable, repeatable, fast enough for experiments, and agent-runnable except for an explicit human step. For flakes, record sample count and reproduction rate. Treat static analysis as provisional when no safe loop exists.

Build an observation-hypothesis-experiment evidence graph. Give each experiment a context capsule containing the symptom, pinned revision and environment, reproduction, redacted signal, one variable, side-effect class, budget, and stop condition. Independent read-only evidence may be collected in parallel, but shared-environment mutations, production observability, timing-sensitive work, and causal experiments remain serial. One investigator owns hypothesis ranking and causal conclusions.

## Reproduce and test hypotheses

1. Confirm the observation matches the report; minimize inputs, steps, configuration, and dependencies one at a time.
2. Generate three to five ranked hypotheses and name an observation or perturbation that would support or reject each.
3. Test one variable at a time. Prefer debugger, REPL, profile, trace, or query-plan evidence before narrow instrumentation.
4. Reject contradicted hypotheses and update the ranking.
5. Verify that the leading cause predicts the result, then rerun the original unminimized scenario.

Never log indiscriminately or expose secrets. Obtain approval before changing production observability. After each experiment, checkpoint new evidence and re-rank the graph. If two consecutive rounds add no new evidence or repeat the same action or error pattern, stop and redesign the loop or request the smallest missing input; a budget stop is not a diagnosis.

## Locate measured bottlenecks

When the workload and objective are known, establish a comparable distribution and profile the limiting resource. Use controlled perturbations only to prove causality, not to turn diagnosis into open-ended optimization.

Run repeated or worst-case workloads in a controlled local or test environment. Require separate approval, bounded load, and stop conditions before production profiling, load, or side effects. Treat changes within noise and correctness, security, durability, or resource trade-offs as limits on the conclusion.

## Repair and report

If repair is explicitly in scope, use `$tdd` at the verified public seam. If no honest seam exists, use `$codebase-design`. Treat caches, batching, concurrency, retries, and approximations as semantic changes unless their behavior is specified.

Report the reproduction or workload, environment, baseline, causal or profile evidence, experiments, checks, result distribution when applicable, remaining uncertainty, and residual risk. A known optimization can proceed through normal implementation or `$tdd` when its behavior should be locked down. Remove only confirmed-disposable temporary artifacts created during this work.
