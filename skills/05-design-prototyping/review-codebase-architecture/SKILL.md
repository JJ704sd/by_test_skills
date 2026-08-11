---
name: review-codebase-architecture
description: Review a codebase for shallow-module and deepening opportunities, then produce a ranked visual report. Use when the user explicitly asks for a codebase-wide architecture scan or refactoring candidates; use $codebase-design after a candidate is selected.
---

# Review Codebase Architecture

Find architectural friction and rank opportunities to deepen modules. Do not implement the refactors in this skill.

## 1. Choose the scope

- Follow a module, subsystem, or pain point named by the user.
- Otherwise inspect recent history for repeatedly changed paths and begin with those hot spots.
- Read `CONTEXT.md` and relevant ADRs when present. Do not re-litigate an ADR unless current friction is strong enough to justify reopening it.

## 2. Explore

Perform an evidence-led scan, keeping candidate discovery separate from detailed design. Look for:

- concepts spread across many shallow modules;
- interfaces nearly as complex as their implementations;
- behavior extracted only for testability while orchestration bugs remain elsewhere;
- dependencies leaking across seams;
- code that cannot be tested through a stable public interface.

Apply the deletion test to each candidate. Classify its dependencies using $codebase-design before recommending consolidation.

## 3. Rank candidates

For each candidate capture:

- affected files and modules;
- current friction and evidence;
- the proposed deepening in plain language;
- expected locality, leverage, and testing gains;
- dependency category and any ADR conflict;
- recommendation strength: `Strong`, `Worth exploring`, or `Speculative`.

Rank candidates by evidence, expected payoff, and migration risk. Do not design detailed interfaces yet.

## 4. Produce the report

Read [references/html-report.md](references/html-report.md). Write one HTML file to the OS temporary directory so the repository stays unchanged. Give each candidate a before/after visual and end with one top recommendation.

Open the report when the current environment permits; otherwise provide its absolute path. Do not require network access for the report to remain readable.

## 5. Hand off

Ask which candidate the user wants to explore. Use $codebase-design to compare interfaces for the selected module, or $grilling when the user wants to stress-test the decision. Do not modify code, domain documents, issues, or ADRs without a separate request.
