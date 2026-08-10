---
name: domain-modeling
description: Build and sharpen a project's domain language and durable architectural decisions. Use when terminology is vague, overloaded, disputed, or must be recorded in CONTEXT.md, or when a hard-to-reverse trade-off merits an ADR; do not invoke merely to read existing domain vocabulary.
---

# Domain Modeling

Read the relevant `CONTEXT.md`, `CONTEXT-MAP.md`, and ADRs before changing the model. Treat missing files as normal and create them only when there is resolved content to record.

## During the discussion

- Call out conflicts with the existing glossary immediately.
- Replace vague or overloaded language with one precise canonical term.
- Stress-test relationships with concrete edge cases and boundary scenarios.
- Compare factual claims with the code and surface contradictions for the user to resolve.
- Keep implementation details out of `CONTEXT.md`; it is a domain glossary, not a specification or scratchpad.

## Persist resolved knowledge

When a term is resolved, update the appropriate `CONTEXT.md` immediately using [references/context-format.md](references/context-format.md). In multi-context repositories, use `CONTEXT-MAP.md` to select the owning context; ask only when ownership remains ambiguous.

Offer an ADR only when the decision meets the durability criteria in [references/adr-format.md](references/adr-format.md). Create the ADR directory lazily, use the next sequential number, and record the trade-off without forcing optional sections that add no value.

Do not write a glossary term or ADR while the underlying decision is still open.
