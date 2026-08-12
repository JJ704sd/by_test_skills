---
name: plan-engineering-work
description: "Create or advance one durable tracker artifact: map an unknown multi-session route, publish a parent spec from settled behavior, or slice an approved route into dependency-linked tickets. Use one mode; use $elicit-stakeholder-input for bounded decisions and $triage for raw requests."
---

# Plan Engineering Work

If tracker conventions are missing, stop and use `$configure-engineering-skills` before writing tracker artifacts.

Choose the least advanced mode the current evidence supports:

- **Map**: the route is unknown, decision fog remains, and the effort spans sessions. Read [map workflow](references/map.md) and [wayfinding model](references/wayfinding-model.md); use the [map](assets/map-template.md) and [decision-ticket](assets/ticket-template.md) templates.
- **Spec**: behavior and scope are settled and need a durable parent specification. Read [spec workflow](references/spec.md) and use the [specification template](assets/spec-template.md).
- **Slice**: the source is approved and the implementation route is known. Read [slice workflow](references/slice.md) and [slicing patterns](references/slicing-patterns.md); use the [remote](assets/issue-template.md) or [local](assets/local-ticket-template.md) ticket template.

Use map rather than slice when unresolved decisions determine the route. Use `$elicit-stakeholder-input` live mode when only a bounded current-user judgment remains. Route raw external issues and pull requests to `$triage`.

Run exactly one mode per invocation. Charting or advancing a map, publishing a specification, and publishing slices are separate stopping points; never advance automatically.
