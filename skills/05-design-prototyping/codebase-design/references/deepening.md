# Deepening a Module

Use this reference when consolidating shallow modules or choosing a dependency seam.

## Dependency categories

1. **In-process**: pure computation or in-memory state. Consolidate directly and test through the new interface.
2. **Local-substitutable**: dependencies with realistic local stand-ins, such as an in-memory filesystem or local database. Exercise the deep module with that stand-in.
3. **Remote but owned**: internal services across a network. Define a port at the seam; use a transport adapter in production and an in-memory adapter in tests.
4. **External**: third-party services. Inject a narrow port owned by the module and supply a controlled test adapter.

## Seam discipline

- Do not expose an internal seam merely because tests use it.
- Introduce a port only when variation is real and valuable.
- Keep transport and vendor details behind adapters.
- State timeouts, retries, ordering, and failure modes as part of the interface when callers must handle them.

## Migration and tests

1. Describe the new external interface before moving implementation.
2. Add behavior tests through that interface at the correct seam.
3. Move logic behind the interface in small, reversible steps.
4. Remove shallow wrappers and obsolete internal tests only after equivalent behavior is covered.
5. Re-run callers and integration checks that cross the changed seam.

Use $tdd when the behavior is known and the migration should proceed test-first.
