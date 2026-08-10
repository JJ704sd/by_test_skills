# UI Prototype

Create three materially different variants and let the user compare them on one route. Cap the set at five.

## 1. Choose the host

Prefer an existing page so every variant is judged with real navigation, density, and read-only data. If no suitable page exists, create an obviously temporary route using the project's routing convention.

Keep existing authentication and data loading when safe, but stub mutations. Do not connect experimental controls to production writes.

## 2. Define the variants

State the question and variant count in a nearby comment. Each variant must differ in layout, information hierarchy, or primary affordance—not only color or copy.

Use the project's existing component and styling system. Give each variant a clear component name and keep layout code independent enough that a losing direction can be removed cleanly.

## 3. Make comparison shareable

Select the variant with a reload-stable URL parameter such as `?variant=A`. Keep data loading above the variant switch so only the rendered subtree changes.

```tsx
const variant = searchParams.get("variant") ?? "A";
return (
  <>
    {variant === "A" && <VariantA {...data} />}
    {variant === "B" && <VariantB {...data} />}
    {variant === "C" && <VariantC {...data} />}
    <PrototypeSwitcher current={variant} variants={["A", "B", "C"]} />
  </>
);
```

Adapt the sketch to the current framework rather than introducing a new dependency.

## 4. Add the switcher

Use a visually distinct, fixed control that shows the active variant and cycles backward or forward. Update the URL through the framework router and support arrow keys without intercepting input, textarea, select, or editable content.

Gate the switcher out of production builds. Keep it in one shared prototype component.

## 5. Conclude

Provide the route and variant keys, then record which direction won and why. Productionize the chosen direction under normal implementation, test, and review standards; do not merge the prototype switcher or losing variants by default.
