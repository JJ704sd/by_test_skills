# Ticket Slicing Patterns

## Tracer-bullet slices

- Cut a narrow but complete path through every required layer rather than one horizontal layer.
- Make each ticket independently demoable or verifiable.
- Fit each ticket in one fresh agent context.
- Put enabling prefactors first only when they make a later behavior slice possible.
- Add a blocking edge only when the dependent ticket genuinely cannot start safely.

## Wide mechanical refactors

A wide refactor is one mechanical change whose blast radius breaks too many callers for a vertical slice to land green. Use expand-contract:

1. **Expand:** add the new form beside the old without breaking callers.
2. **Migrate:** move callers in batches sized by package, directory, or another coherent blast-radius boundary. Each batch is blocked by expand.
3. **Contract:** remove the old form only after every migration batch completes.

If no migration batch can stay green independently, keep the same dependency graph on an integration branch and add a final integrate-and-verify ticket. State explicitly that green is guaranteed only at that final point.

Do not use expand-contract merely because horizontal implementation feels easier; it is an exception for indivisible mechanical blast radius.
