---
name: review-code-against-spec
description: Review a branch, PR, commit range, or working diff against repository standards and an originating spec as independent axes. Use to assess a fixed change set; report findings without edits unless fixes are separately requested.
---

# Review Code Against Spec

Review one pinned change set independently for **Standards** and **Spec**. Findings must be introduced by the reviewed changes and supported by actionable evidence.

## Pin the change set

Honor a user-supplied base, range, PR, or commit; otherwise infer only when unambiguous and state the assumption. For a branch or PR, compare merge base to head; for a commit or range, review exactly it; for the working tree, include staged, unstaged, and relevant untracked files.

Pin endpoints, commit context, changed files, and raw patch. Stop on an invalid or empty change set, and ask only when competing bases materially alter it. Build a requirements-files-checks coverage map and inspect high-impact requirements, trust boundaries, shared state, and cross-file behavior first. A changed diff invalidates all conclusions; a budget stop leaves explicit residual verification gaps.

## Find governing sources

Find the spec in this order: user-supplied source; reviewed commit or branch references; conventional spec files; nearby approved tickets or behavior tests.

If no authoritative spec exists, run only the Standards axis and label the Spec axis `No spec available`.

Collect root and nested instructions, contribution guides, standards, and tool configuration. Repository rules override the fallback [code-smell baseline](references/code-smells.md), whose items remain judgment calls.

## Review independently

Perform two passes over the same patch:

- **Standards**: find introduced correctness, security, data-loss, concurrency, compatibility, maintainability, or documented-rule problems. Cite rules or explain concrete cost; ignore pre-existing issues and tool-enforced nits.
- **Spec**: find missing, partial, incorrect, or unrequested behavior. Cite the exact authoritative requirement and report ambiguity separately rather than declaring a defect.

One report writer resolves conflicts from primary evidence, deduplicates findings, and closes material coverage gaps. Review remains read-only unless fixes are separately requested.

## Report findings first

Keep `## Standards` and `## Spec` separate. Each finding needs severity, a tight location, evidence, impact, and smallest correction. State when an axis has no findings or source, then end with counts, highest severity, and residual gaps; never merge the axes into one score.
