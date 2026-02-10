# Admitting a New Land

When starting a new project or bringing an existing one under governance, follow this protocol in order.

## Phase 0: Decide If It Belongs

Not every project needs governance. If it's a throwaway experiment, a one-off script, or something you'll abandon in a week — don't bother. Governance has a cost. The project earns admission when you intend to maintain it beyond the initial build.

## Phase 1: Foundation

1. **Create the repository** (or confirm it exists).
2. **Add CLAUDE.md** (symlink to AGENTS.md) to the repository root with:
   - One-paragraph project description
   - Stack and key dependencies
   - Build and test commands
   - Reference to docs/ for detailed documentation
3. **Set up guardrails:**
   - Install and configure the linter, formatter, and type checker for the stack (see Standard Guardrails above).
   - Create pre-commit hooks that run lint + format + type check + test.
   - Set up CI (GitHub Actions recommended) with build + test + lint.
   - Enable branch protection on main/master.
4. **Create the `docs/` directory.**

## Phase 2: Documentation

Run the documentation commands in this order. Each one builds on the previous.

1. **Run `/prd`** — The agent reverse-engineers the product from the code and interviews you. Review and correct the output. This is the most important document because everything else references it.
2. **Run `/architecture`** — The agent reads the codebase and produces the architecture doc. Review the ADRs — the agent will infer rationale, and you need to correct the "why" where it's wrong.
3. **Write `docs/CONVENTIONS.md`** — This one is best written by you (with agent help). The agent can document existing patterns, but only you know which patterns are intentional vs. accidental.
4. **Run `/traceability`** — The agent maps PRD features to tests. This will expose coverage gaps. Don't fix them yet — just know where they are.

## Phase 3: Backfill (ongoing)

1. Review the traceability matrix. Identify the highest-priority coverage gaps.
2. Use `/tech` to create test-gap issues for each.
3. Use `/implement` to fill them, one at a time.
4. Raise coverage thresholds as gaps are filled (60% → 70% → 80%).

## Phase 4: Register

Add the project to the Registry of Lands table above. Mark each column honestly.

## Checklist: When Is a Land "Governed"?

A Land reaches `Governed` status when ALL of the following are true:

- [ ] CLAUDE.md exists and is accurate
- [ ] docs/PRD.md exists and covers all implemented features
- [ ] docs/ARCHITECTURE.md exists and matches the actual code
- [ ] docs/CONVENTIONS.md exists
- [ ] docs/TRACEABILITY.md exists with no "Missing" features that are high-priority
- [ ] Linter configured and enforced via pre-commit
- [ ] Formatter configured and enforced via pre-commit
- [ ] Type checker (if applicable) configured and enforced
- [ ] Test suite exists with ≥60% coverage
- [ ] CI pipeline runs build + test + lint on every push
- [ ] Branch protection enabled on main/master
- [ ] Pre-commit hooks installed and working
