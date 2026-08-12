---
name: evolving-contracts
description: Safely evolve APIs, schemas, persisted data, dependencies, runtimes, or toolchains through explicit compatibility transitions. Use when change cannot be atomic, old and new states must coexist, or recovery risks matter; not for internal refactors, atomic upgrades, or undecided contracts.
---

# Evolving Contracts and Dependencies

Move a live contract or external dependency from one valid state to another without assuming every consumer, record, or environment changes atomically.

## Define the change

1. Pin the revision, current and target forms or versions, governing contracts, topology, supported environments, and recovery expectations.
2. Inventory producers, readers, validators, storage, generated clients, manifests, runtimes, and deployed versions as applicable.
3. Build a producer-reader-storage-deployment graph and compatibility matrix that identify phase gates, owners, safe batches, irreversible actions, and recovery paths.
4. Use `$codebase-design` when the target contract is unresolved; use `$refactoring-safely` when no mixed-version or external compatibility boundary exists.

## Select evidence and transition

For API, schema, data, event, or configuration changes, use [transition patterns](references/transition-patterns.md) and default to:

1. **Expand readers:** deploy readers that accept old and new forms without requiring or emitting the new form.
2. **Migrate writers:** only after supported readers are proven compatible, emit the new form and migrate or backfill in bounded, idempotent, resumable batches. Use a versioned contract or adapter when old readers reject it.
3. **Observe:** measure interoperability, migration failures, data reconciliation, and remaining legacy use.
4. **Contract:** remove the old form only after evidence proves no required reader, writer, or record depends on it.

For dependency, framework, runtime, or toolchain changes, use [dependency-upgrade evidence](references/dependency-upgrades.md), exact-version primary guidance, a frozen baseline, and one coupled family at a time.

Do not choose “latest” reflexively, rely on rollout order as compatibility proof, or assume application rollback reverses destructive data changes.

Treat expand, migrate, observe, and contract as explicit gates. Batches must be bounded, disjoint, idempotent, and resumable; authoritative writes, contraction, recovery decisions, shared data, and Git state remain serial under one owner. Obtain approval before irreversible or production actions.

At each checkpoint record the revision, matrix version, phase, durable cursor, validation, unfinished side effects, and next gate. On any change or ambiguous cursor, stop, revalidate, and return to the last verified boundary rather than replaying writes.

## Verify every state

Test initial, mixed, and final states plus retry, partial failure, supported runtimes, integrations, and recovery as applicable. Keep destructive steps separately authorized and backed by a tested recovery mechanism. Use `$tdd` for settled behavior and `$diagnosing-bugs` for unclear failures. Report the matrix, evidence, sequence, changes, recovery, checks, contraction condition, and residual risk.
