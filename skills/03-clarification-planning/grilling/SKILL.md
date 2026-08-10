---
name: grilling
description: Interview the current user in rounds to stress-test a plan, decision, or idea. Use stateless mode for live clarification, or documented mode with $domain-modeling to persist resolved terms and ADRs; use $to-questionnaire for knowledge held by someone else.
---

# Grilling

Use a design tree: each decision unlocks the decisions that depend on it. The frontier is every question whose prerequisites are already settled.

## Choose the mode

- **Stateless mode is the default.** Conduct the interview without creating domain documents.
- **Documented mode** applies when the user explicitly wants resolved vocabulary or durable decisions recorded in a repository. Run `$domain-modeling` alongside the interview and persist only settled outcomes.

Do not switch into documented mode merely because a working directory exists.

## Work in rounds

1. Build the current decision tree from the conversation and inspected evidence.
2. Ask the whole frontier in one numbered round. Give a recommended answer for every genuine decision.
3. Wait for the user's answers before asking questions that depend on them.
4. Recompute the tree after every round; answers may add, remove, or reorder branches.

Format each item clearly:

```text
Q1 — <short title>: <question and concise choices>
Recommended: <answer and reason>
```

Finding facts is the agent's job. Inspect the environment or delegate bounded research instead of asking the user for discoverable facts. If an investigation is still running, ask the rest of the independent frontier now and defer only dependent questions.

The interview ends when the frontier is empty and the user confirms the shared understanding. Do not begin implementation as an implicit continuation of the interview.
