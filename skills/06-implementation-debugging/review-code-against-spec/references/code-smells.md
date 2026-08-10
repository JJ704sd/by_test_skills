# Code Smell Baseline

Use this baseline only when reviewing a changed hunk. Repository standards override it, and every smell remains a judgement call rather than a hard violation.

- **Mysterious Name**: a function, variable, or type does not reveal its purpose. Rename it; if no honest name exists, clarify the design.
- **Duplicated Code**: the same logic shape appears in multiple changed locations. Extract the shared behavior when doing so improves locality.
- **Feature Envy**: a method reaches into another object's data more than its own. Move behavior toward the data it uses.
- **Data Clumps**: the same fields or parameters repeatedly travel together. Introduce a focused domain type.
- **Primitive Obsession**: a primitive stands in for a domain concept with its own rules. Give the concept a type or value object.
- **Repeated Switches**: the same conditional dispatch recurs for one concept. Centralize the decision or use an appropriate polymorphic design.
- **Shotgun Surgery**: one logical change forces scattered edits across many modules. Gather the changing behavior behind one interface.
- **Divergent Change**: one module changes for several unrelated reasons. Separate responsibilities along stable seams.
- **Speculative Generality**: hooks, parameters, or abstractions serve no current requirement. Remove or inline them until a real need exists.
- **Message Chains**: callers navigate a long object chain. Hide navigation behind a meaningful operation.
- **Middle Man**: a module mostly delegates without adding behavior or policy. Remove the indirection or deepen the module.
- **Refused Bequest**: an implementation inherits behavior it mostly rejects or overrides. Prefer a smaller interface or composition.

Do not report a smell merely because the pattern exists. Explain the concrete maintenance, correctness, or change-locality cost visible in this diff, and suppress it when repository guidance intentionally endorses the design.
