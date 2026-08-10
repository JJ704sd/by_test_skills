---
name: resolving-merge-conflicts
description: Resolve an in-progress Git merge or rebase conflict by reconstructing both sides' intent, validating the result, and safely continuing the operation. Use only when Git reports unresolved merge or rebase conflicts.
---

# Resolving Merge Conflicts

1. Inspect `git status`, the current merge or rebase state, recent history, conflicting paths, and any unrelated working-tree changes. Preserve unrelated user work.
2. Trace each side to its primary source: commits, code history, available PR context, issues, specs, and tests. Use external sources only when available and relevant.
3. Resolve each hunk to preserve both intents where compatible. When they conflict, follow the merge goal and report the trade-off. Do not invent unrelated behavior.
4. If evidence indicates the operation should be aborted, explain why and ask the user to decide. Do not run `--abort` autonomously.
5. Stage only the resolved conflict paths, using explicit path arguments. Never stage the whole working tree or sweep in unrelated changes.
6. Run the smallest relevant format, type, build, and test checks, then inspect `git diff --check` and the staged diff.
7. Continue the merge or rebase only when finishing it is within the user's request. For a rebase, handle later conflicts one commit at a time. Do not create an extra commit or push unless requested or required by the already-authorized Git operation.

Report resolved files, intent decisions, checks run, remaining conflicts, and whether the Git operation was continued.
