# Writing Agent Briefs

An agent brief is the durable contract posted to the configured tracker when an issue or PR becomes `ready-for-agent`. Earlier discussion remains context; the brief defines the work to perform now.

## Principles

- **Durable:** describe behavioral contracts, stable types, interfaces, and configuration shapes. Avoid file paths, line numbers, and assumptions about current implementation layout.
- **Behavioral:** state what the system must do, not the procedure an agent should follow.
- **Verifiable:** provide independently testable acceptance criteria, including relevant errors and boundaries.
- **Scoped:** name adjacent work that must not be included.
- **Current:** for a PR, describe the existing diff and the gaps left to close rather than asking for a new implementation from scratch.

## Template

```markdown
## Agent Brief

**Category:** bug / enhancement
**Summary:** <one-line result>

**Current behavior:**
<What happens now; for a PR, describe the current diff and remaining gaps.>

**Desired behavior:**
<Observable behavior after completion, including edge and error cases.>

**Key interfaces:**
- `<stable interface or type>` — <contract that must change>

**Acceptance criteria:**
- [ ] <Specific verifiable criterion>
- [ ] <Boundary, error, or regression criterion>

**Out of scope:**
- <Adjacent work that must not be included>
```

## Quality check

Reject the draft if it merely says “fix the issue,” prescribes volatile files or line numbers, omits current-versus-desired behavior, lacks acceptance criteria, or leaves scope unbounded.

For a PR, preserve behavior that already works in the diff and call out only the verified gaps. For an issue, describe the complete desired behavior without dictating implementation steps.
