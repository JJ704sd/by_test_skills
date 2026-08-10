# Debugging Feedback Loops

Choose the earliest option that safely reproduces the exact symptom.

## Loop options

1. **Focused failing test** at the public seam that reaches the bug.
2. **HTTP script** against a local or approved test server.
3. **CLI invocation** with fixture input and an explicit output assertion.
4. **Headless browser script** that checks DOM, console, or network behavior.
5. **Captured-trace replay** using a redacted request, event, or payload.
6. **Throwaway harness** around the smallest service or function path.
7. **Property or fuzz loop** for input-dependent failures.
8. **Bisection harness** for a regression between known versions or datasets.
9. **Differential loop** comparing old/new versions or configurations.
10. **Structured human loop** using `../scripts/hitl-loop.template.sh` when automation is impossible.

Do not capture credentials in fixtures or transcripts. Obtain approval before adding production instrumentation.

## Tighten the signal

- Assert the exact wrong result, error, or timing rather than “did not crash.”
- Cache or bypass unrelated setup.
- Freeze time, seed randomness, isolate filesystem state, and control network dependencies.
- Keep the command and required fixtures together so another agent can rerun it.

## Flaky failures

Measure the reproduction rate. Repeat or parallelize the trigger, add controlled stress, and narrow timing windows until hypothesis tests can distinguish changes. Record the sample count and rate; do not call a single passing run a fix.

## If automation fails

Ask for the smallest missing item:

- access to a safe reproducing environment;
- a redacted HAR, log, trace, core dump, or timestamped recording;
- permission for narrowly scoped temporary instrumentation.

Continue with bounded static analysis only as provisional evidence, and label every resulting hypothesis as unverified.
