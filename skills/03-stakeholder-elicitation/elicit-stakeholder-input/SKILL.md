---
name: elicit-stakeholder-input
description: "Elicit human-owned input in one mode: run a dependency-aware live interview with the current user, or draft an async questionnaire for another holder. Use for judgment or private context; investigate discoverable facts directly. Use $domain-modeling only to persist settled outcomes."
---

# Elicit Stakeholder Input

Resolve missing human input without asking people questions that available evidence can answer.

## Select one mode

First inspect the conversation, repository, existing specifications, and available evidence. Separate discoverable facts from inputs that only a person can supply, then choose exactly one mode:

- **Live**: the current user owns the unresolved judgment. Read [live interview](references/live.md).
- **Async**: another person owns private context, facts, or decisions. Read [async questionnaire](references/async.md) and use [the questionnaire template](assets/questionnaire-template.md).

Do not silently switch modes. If a live interview reveals that another person owns the answer, stop and propose an async questionnaire before writing it. If the holder is unclear, ask only who can authoritatively answer.

Do not begin implementation. Keep live work stateless unless the user explicitly requests durable domain knowledge, and write an async artifact only when that mode is requested.
