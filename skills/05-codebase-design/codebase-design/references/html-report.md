# Architecture Scan HTML

Create one readable HTML document. Inline the essential CSS; optional CDN enhancements must not be required to understand the report offline.

## Structure

```html
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Architecture scan — {{repo}}</title>
  <style>/* compact layout, diagram, badge, and print styles */</style>
</head>
<body>
  <main>
    <header>...</header>
    <section id="candidates">...</section>
    <section id="top-recommendation">...</section>
  </main>
</body>
</html>
```

The header contains the repository name, date, and a small legend. Start with findings rather than an introduction.

## Candidate card

Include:

- a short title naming the deepening;
- recommendation strength and dependency category badges;
- affected files;
- one-sentence problem and solution;
- before/after visualization;
- concise wins expressed as locality, leverage, and test-surface gains;
- a visible ADR warning when applicable.

Use prose sparingly. If a visual needs a paragraph to explain it, redraw it.

## Visual patterns

Choose the smallest pattern that communicates the evidence:

- dependency or call-flow graph;
- sequence diagram for round trips or ordering;
- stacked cross-section for pass-through layers;
- interface/implementation mass diagram for shallowness;
- call-graph collapse showing internals absorbed by one module.

Use inline HTML/CSS/SVG by default. Mermaid is optional only when already available and the report still has an offline fallback.

## Style and tone

- Favor a lean editorial layout, generous whitespace, and one accent color.
- Use red only for leakage and amber for warnings.
- Keep before/after diagrams comparable in size.
- Use the `$codebase-design` vocabulary consistently.
- Avoid generic claims such as “cleaner code”; name the concrete locality, leverage, or testing gain.

The top recommendation is one larger card with the candidate, one-sentence rationale, and a link to its detailed card.
