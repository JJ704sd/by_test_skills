---
name: diagnosing-bugs
description: Diagnose bugs with unknown causes, hard-to-reproduce or flaky failures, and performance regressions by building an evidence loop and testing falsifiable hypotheses. Use when the root cause is unknown; use $tdd when the behavior or cause is already known and the task is to implement a fix test-first.
---

# Diagnosing Bugs

Default to diagnosis, not repair. Finish with a reproducible symptom, a verified root cause, supporting evidence, and a recommended fix.

Read `CONTEXT.md` and relevant ADRs when present.

## Protect evidence and secrets

Redact credentials, tokens, cookies, authorization headers, and personal data before showing commands, outputs, or captured artifacts. Keep credentials in environment variables. If redaction removes evidence needed to continue, explain what is missing and ask the user for a safe substitute.

## 1. Build a feedback loop

Read [references/feedback-loops.md](references/feedback-loops.md) and choose the smallest loop that exercises the reported symptom. A human-in-the-loop flow is a last resort; adapt `scripts/hitl-loop.template.sh` when unavoidable.

Record one command that you have run and whose redacted output demonstrates the signal. The loop should be:

- **red-capable**: asserts the user's exact symptom;
- **repeatable**: deterministic, or a measured high reproduction rate for a flaky bug;
- **fast enough** for repeated hypothesis tests;
- **agent-runnable**, except for an explicitly structured human step.

If a safe loop cannot be built, report what was tried and request the minimum missing access or artifact. Do not label an untested theory as a verified cause.

## 2. Reproduce and minimize

Confirm the observed failure matches the user's report. Remove inputs, steps, configuration, and dependencies one at a time, rerunning the loop after each change. Stop when every remaining element is load-bearing.

## 3. Form hypotheses

Generate three to five ranked, falsifiable hypotheses. For each, state the observation or perturbation that would support or reject it. Show the list to the user, but continue with the best evidence-based ranking unless a decision is required.

## 4. Test one variable at a time

Prefer debugger or REPL inspection, then narrowly targeted instrumentation. Tag temporary logs with a unique prefix for cleanup. Never log secrets or “log everything and grep.”

For performance regressions, establish a repeatable timing, profile, or query-plan baseline before changing code.

## 5. Establish the cause

Verify that the leading hypothesis predicts the observed behavior and that a controlled perturbation changes the loop in the predicted direction. Re-run the original, unminimized scenario to ensure the explanation covers the real report.

Report:

- the exact symptom and reproduction command;
- the minimized case;
- the verified root cause and causal evidence;
- remaining uncertainty;
- the smallest recommended fix and regression seam.

Stop here unless the user explicitly requested a fix.

## 6. Fix only when authorized

When repair is explicitly in scope, use $tdd at the verified seam: turn the minimized case into a failing regression test, apply the smallest fix, and re-run both the regression test and original loop. If no correct seam exists, report that architecture finding rather than adding a misleading test.

Remove only instrumentation and temporary artifacts created during this diagnosis and confirmed disposable. Never delete user-owned artifacts or unrelated changes. If the missing seam is the durable cause, recommend $review-codebase-architecture after the immediate work.
