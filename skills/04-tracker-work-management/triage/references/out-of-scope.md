# Out-of-Scope Knowledge Base

The repository's `.out-of-scope/` directory records rejected enhancements so future similar requests can reuse the decision. It is not a list of built features, deferred work, or rejected bugs.

## Structure

Use one kebab-case Markdown file per concept, not per issue:

```markdown
# <Concept>

<What is not supported.>

## Why this is out of scope

<Durable product, architectural, technical, or strategic reason.>

## Prior requests

- <Issue or PR link> — <request title>
```

Group synonymous requests by concept similarity rather than exact keywords. The reason must be durable; “we are too busy now” is a deferral, not a rejection.

## During triage

Read `.out-of-scope/*.md` while gathering context. When a concept appears similar, show the prior reason and ask the maintainer to confirm, reconsider, or distinguish it.

- **Confirm:** append the new request link to the existing concept file, comment, label `wontfix`, and close.
- **Reconsider:** update or remove the stale record, then return the item to normal triage. Do not reopen historical issues automatically.
- **Distinguish:** leave the prior record unchanged and continue normal triage.

Create or update a record only for a rejected enhancement, including an enhancement PR. If the requested behavior already exists, point to the implementation and close without writing an out-of-scope record.
