# Behavior Tests and Boundary Substitutes

Use this reference when deciding whether a test observes behavior or when a dependency needs substitution.

## Behavior-first test

```typescript
test("user can check out a valid cart", async () => {
  const cart = createCartWith(product);
  const result = await checkout(cart, paymentMethod);
  expect(result.status).toBe("confirmed");
});
```

The test uses a public interface, names a caller-visible capability, and should survive internal refactoring.

## Implementation-coupled test

```typescript
test("checkout calls paymentService.process", async () => {
  const payment = mockPaymentService();
  await checkout(cart, payment);
  expect(payment.process).toHaveBeenCalledTimes(1);
});
```

This verifies an internal interaction rather than the checkout result. A harmless refactor can break it.

Other warning signs:

- testing private methods;
- asserting internal call order;
- querying storage directly instead of observing through the public interface;
- snapshots with no reviewed behavioral meaning.

## Independent expectations

Do not recompute the expected value with the same algorithm as production code.

```typescript
// Tautological
const expected = items.reduce((sum, item) => sum + item.price, 0);
expect(calculateTotal(items)).toBe(expected);

// Independent worked example
expect(calculateTotal([{ price: 10 }, { price: 5 }])).toBe(15);
```

## Boundary substitutes

Use a substitute for:

- third-party APIs;
- nondeterministic time or randomness;
- remote infrastructure that has no safe local stand-in;
- filesystem or database access only when a realistic local instance is impractical.

Do not mock owned modules or internal collaborators. Prefer a test database, in-memory filesystem, fake clock, or other behaviorally realistic local adapter.

Inject narrow, operation-specific ports rather than a generic conditional fetcher. Keep vendor details behind the production adapter and return domain-shaped results to the module.

## Review questions

- Would this test still pass after a correct internal rewrite?
- Can the assertion fail when the requested behavior is wrong?
- Is the seam one a real caller uses?
- Does each substitute represent a true boundary rather than an implementation detail?
- Is the test deterministic and focused on one logical behavior?
