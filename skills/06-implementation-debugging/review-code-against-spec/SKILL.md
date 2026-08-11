---
name: review-code-against-spec
description: Review a branch, PR, or working diff against repository standards and an originating spec as two independent axes. Use when the user asks whether changes since a fixed point are compliant and complete; not for architecture discovery, bug diagnosis, or implementing fixes.
---

# Review Code Against Spec

Review the same diff independently for **Standards** and **Spec**. Report findings; do not modify the code unless the user separately requests fixes.

## 1. Pin the comparison

Use the commit, branch, tag, or merge-base supplied by the user. If omitted, infer the repository's default branch when unambiguous and state the assumption; ask only when different choices would materially change the diff.

Resolve the fixed point before review, then capture:

- `git diff <fixed-point>...HEAD` for the merge-base diff;
- `git log <fixed-point>..HEAD --oneline` for commit context;
- the changed-file list.

Stop with a clear explanation if the ref is invalid or the diff is empty.

## 2. Find the spec

Search in this order:

1. issue or PR references in commit messages;
2. a path or tracker item supplied by the user;
3. matching files under `docs/`, `specs/`, or `.scratch/`;
4. nearby acceptance criteria or approved tickets.

Use configured tracker access when available. If no authoritative spec exists, run only the Standards axis and label the Spec axis `No spec available`.

## 3. Find standards

Collect repository instructions such as `AGENTS.md`, `CONTRIBUTING.md`, coding standards, and relevant local guidance. Read [references/code-smells.md](references/code-smells.md) for the fallback smell baseline.

Repository rules override the baseline. Treat baseline smells as judgement calls, not hard violations, and skip checks already enforced by tooling unless the diff bypasses that tooling.

## 4. Run independent reviews

Run two clearly separated passes so one conclusion does not anchor the other. Give each pass the raw diff, commit list, changed files, and only its axis-specific sources.

**Standards pass**

- Cite each documented rule violation with source and changed file/hunk.
- Name any baseline smell and quote the relevant changed code.
- Distinguish hard repository-rule breaches from heuristic concerns.
- Ignore unrelated pre-existing code outside the diff.

**Spec pass**

- Identify missing or partial requirements.
- Identify unrequested behavior or scope creep.
- Identify implemented requirements whose behavior appears incorrect.
- Cite the governing spec or acceptance criterion for every finding.

## 5. Report without cross-axis reranking

Present `## Standards` and `## Spec` separately. For each finding include severity, file and line or hunk, evidence, and the smallest actionable correction. State explicitly when an axis has no findings or no source.

End with the finding count and highest severity within each axis. Do not choose one overall winner or let one axis mask the other.
