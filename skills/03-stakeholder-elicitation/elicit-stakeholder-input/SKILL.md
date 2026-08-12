---
name: elicit-stakeholder-input
description: "Elicit human-owned input in one mode: run a dependency-aware live interview with the current user, or draft an async questionnaire for another holder. Use for judgment or private context; investigate discoverable facts directly. Use $domain-modeling only to persist settled outcomes."
---

# Elicit Stakeholder Input

Inspect the conversation, repository, specifications, and available evidence first. Separate discoverable facts from input only a person can supply, then choose exactly one mode:

- **Live**: the current user owns the unresolved judgment. Read [live interview](references/live.md).
- **Async**: another person owns private context, facts, or decisions. Read [async questionnaire](references/async.md) and use [the questionnaire template](assets/questionnaire-template.md).

Do not silently switch modes. If live work reveals that another person owns the answer, stop and propose async mode. If ownership is unclear, ask only who can answer authoritatively.

Do not begin implementation. Keep live work stateless unless durable domain knowledge is explicitly requested. In async mode, return the draft in the response; write a file only when the user explicitly requests file output and supplies or approves its path.
