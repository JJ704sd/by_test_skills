# Logic Prototype

Build one self-contained HTML file that lets a person drive a state model and observe outcomes.

## 1. State the question

Display the model and the exact question at the top of the page so reviewers know what the artifact can and cannot answer.

## 2. Isolate the logic

Put the behavior in one portable, pure module inside a script block. Choose the shape that fits the question:

- reducer for discrete actions over one state value;
- explicit state machine when legal transitions matter;
- pure functions for stateless transformations;
- a small object only when ongoing internal state is essential.

Keep DOM access and event handlers outside this module. The page calls the logic; the logic never calls the page.

## 3. Build the interaction shell

Use plain inline HTML, CSS, and JavaScript with no framework, bundler, server, or real database. Include:

1. a title and one-sentence question;
2. a readable current-state panel, not a raw JSON dump;
3. free-play actions that re-render after every change;
4. guided scenarios with known initial state and ordered action buttons.

Cover the happy path, one difficult edge case, and one illegal action. Use domain language in labels and explanations.

## 4. Keep the experiment narrow

- Do not generalize beyond the stated question.
- Do not add tests to the disposable shell.
- Do not call production services or persist credentials.
- Do not mix DOM behavior into the portable logic module.

Report what the experiment demonstrated. If the logic is adopted, reimplement or lift the decision-rich module into production under normal testing and review rules.
