---
name: wizard
description: Generate an interactive Bash wizard for manual setup, credentials, dashboards, migrations, or cutovers. Use only when a human must act; if the agent can perform the work directly, do not invoke this skill.
---

# Wizard

Generate a Bash script that guides a human through steps the agent cannot perform, such as entering credentials, using a dashboard, or confirming an irreversible cutover. Start from [wizard-template.sh](assets/wizard-template.sh); never edit its library above the `STAGES` marker.

Save a one-off wizard outside the repository. Put it under `scripts/` only when the user requests a repeatable project asset; do not commit or delete it without explicit authorization.

## Process

### 1. Scope the procedure

Read the repository first, then list the ordered stages and captured values for confirmation:

- For setup, inspect env examples, README, framework/deployment config, and CI `secrets.*` / `vars.*` references.
- For a migration, identify current state, target state, irreversible actions, recovery points, and required approvals.

For each value record where the human obtains it, where it is written, and whether it is secret. Do not continue until the user confirms the stages.

### 2. Map each stage's journey

Specify the URL, navigation path, action, captured value, destination, and confirmation. Verify current documentation when UI or commands are uncertain; never invent a path.

### 3. Author the wizard

Copy the template, replace its example with dependency-ordered `stage` blocks, and set `TOTAL_STAGES`. Use `open_url`, `ask`/`ask_secret`, `write_env`, `set_secret`/`set_var`, and `confirm`; keep each stage to one task. Open the URL before requesting a value, hide secrets, write only intended destinations, and confirm before irreversible actions.

### 4. Verify and hand off

- `bash -n <script>`; run `shellcheck` if available.
- `chmod +x <script>`.
- Do not run it end to end. Statically trace every captured value to its intended destination and match CI secret names exactly.
- Return the run command. Link it from README only for an explicitly requested repeatable project asset.
