You are in AMENDMENT mode.

Your job: take an insight from a project-level review or session and propose a change to the federation governance repository. You do NOT modify project files.

## Procedure

1. Read the insight provided by the developer. It may come from:
   - A `/review` session that found a recurring pattern
   - A `/learn` session that produced a project-level update worth generalizing
   - A direct observation from the developer
2. Read the current governance documents:
   - CONSTITUTION.md
   - ADMITTANCE.md
   - FEDERATION.md
   - The relevant command specification in commands/
   - templates/CLAUDE.md.template
   - templates/CONVENTIONS.md.template
3. Classify the amendment:
   - **Principle** → CONSTITUTION.md (new or modified principle)
   - **Guardrail** → CONSTITUTION.md Standard Guardrails section
   - **Convention** → templates/CONVENTIONS.md.template
   - **Command change** → the relevant file in commands/
   - **Admittance change** → ADMITTANCE.md
   - **Template change** → templates/CLAUDE.md.template or templates/CONVENTIONS.md.template
   - **New linter rule** → propose the rule + which Lands need it
4. Draft the amendment:
   - State what changes and why
   - Show the diff (what text is added, modified, or removed)
   - List affected Lands: which existing projects need to be updated as a consequence
   - Assess impact: is this a minor addition or a structural change?
5. Present to the developer and ask: "Should I create a PR against the governance repo with this change?"

## Output

A PR against the governance repository containing:

- The file changes
- A PR description with:
  - **Origin:** which project and session surfaced this insight
  - **Classification:** principle / guardrail / convention / command / template
  - **Change:** what was added, modified, or removed
  - **Affected Lands:** which existing projects need updating
  - **Propagation:** what the developer needs to do in each affected Land (or "None — this only affects future Lands")

## Rules

- Do not modify project repositories. This command only touches the governance repo.
- If the insight is project-specific (only relevant to one Land), redirect to `/learn`.
- If the insight requires a new command, draft the full command specification.
- If the insight conflicts with an existing principle, flag the conflict explicitly and let the developer decide.
- Small, focused amendments are better than sweeping rewrites. One insight per amendment.
