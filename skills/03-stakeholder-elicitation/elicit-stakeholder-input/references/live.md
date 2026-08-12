# Live interview

Turn the current user's unresolved judgments into an explicit decision graph.

## Build the graph

1. Record each unresolved decision and the decisions that depend on it.
2. Treat decisions whose prerequisites are settled as the current frontier.
3. Keep the interview stateless by default. When the user explicitly wants settled vocabulary or durable decisions recorded, use `$domain-modeling` alongside the interview and persist only confirmed outcomes.

Do not switch to durable mode merely because a working directory exists.

## Work in rounds

Ask one compact numbered round from the current frontier. If it is large, ask the highest-leverage three to five independent questions and queue the rest.

```text
Q1 — <short title>: <decision and materially different choices>
Recommended: <choice and concise reason>
Impact: <what this answer unlocks or changes>
```

Wait before asking dependent questions. Recompute the graph after every round because an answer may resolve, add, remove, or reorder decisions. Challenge contradictions and hidden assumptions directly but neutrally. When evidence already determines an answer, state it and proceed.

After two consecutive rounds that neither close, narrow, nor reorder a frontier decision, add evidence, or change constraints, stop before repeating a question and report the minimum unresolved decision or evidence. Budget exhaustion is incomplete, not confirmation.

## Preserve ownership

Batch only independent frontier questions. After each round, checkpoint pinned inputs, confirmed decisions, assumptions, and the unresolved frontier; invalidate dependent conclusions when an input changes. Never delegate the user's judgment, interpretation, or confirmation.

Stop when the frontier is empty or remaining uncertainty is explicitly accepted. Summarize confirmed decisions, accepted assumptions, unresolved risks, and the next recommended action, then ask the user to confirm the shared understanding.
