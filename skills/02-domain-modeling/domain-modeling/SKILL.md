---
name: domain-modeling
description: Build and sharpen a project's domain language and durable architectural decisions. Use when terminology is vague, overloaded, disputed, or must be recorded in CONTEXT.md, or when a hard-to-reverse trade-off merits an ADR; do not invoke merely to read existing domain vocabulary.
---

# Domain Modeling

Read the relevant `CONTEXT.md`, `CONTEXT-MAP.md`, ADRs, and code before changing the model. Missing files are normal; create them only for resolved content.

1. Surface conflicts between existing language, code, and claims. Replace vague or overloaded terms with one canonical term and test relationships against concrete boundaries.
2. Keep implementation details and open questions out of the glossary.
3. Persist a resolved term in its owning context using the [context rules](references/context-format.md) and [context template](assets/context-template.md). Use `CONTEXT-MAP.md` to infer ownership and ask only when it remains ambiguous.
4. Offer an ADR only when the decision meets the [durability criteria](references/adr-format.md); then use the [ADR template](assets/adr-template.md), create the directory lazily, and allocate the next sequential number.

Do not write a term or ADR while the underlying decision remains open.
