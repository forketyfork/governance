# Admitting a New Land

When starting a new project or bringing an existing one under governance, follow this protocol in order.

## Phase 0: Decide If It Belongs

Not every project needs governance. If it's a throwaway experiment, a one-off script, or something you'll abandon in a week — don't bother. Governance has a cost. The project earns admission when you intend to maintain it beyond the initial build.

## Phase 1: Foundation

1. **Create the repository** (or confirm it exists).
2. **Add `AGENTS.md` and symlink `CLAUDE.md -> AGENTS.md`** at the repository root with:
   - One-paragraph project description
   - Stack and key dependencies
   - Build, lint, type-check, and test commands
   - Worktree bootstrap entry point command (prefer `script/setup`, or clearly documented equivalent)
   - Infrastructure section (source code hosting, issue tracker, CI/CD, issue/PR linkage convention)
   - Reference to docs/ for detailed documentation
3. **Set up guardrails:**
   - Install and configure the linter, formatter, and type checker for the stack (see Standard Guardrails in CONSTITUTION.md).
   - Create pre-commit hooks that run lint + format + type check + test.
   - Set up CI with build + test + lint (see Infrastructure in CONSTITUTION.md).
   - Enable branch protection on the default branch (status checks, up-to-date requirement, force-push blocking, deletion restriction, code scanning gate — see Standard Guardrails in CONSTITUTION.md).
4. **Configure automated dependency updates:**
   - Set up a dependency update tool (Dependabot, Renovate, or equivalent) for the repository.
   - The tool must periodically scan for outdated dependencies and open PRs.
   - How those PRs are handled (automerge, grouping, review cadence) is each Land's decision.
5. **Configure supply-chain security:**
   - Enable secret scanning with push protection so that commits containing secrets are rejected before reaching the remote.
   - Enable automated code scanning (CodeQL, Semgrep, or equivalent) to run on every push and report results before merge.
   - Ensure CI workflows use least-privilege permissions (read-only access to repository contents unless write access is explicitly required).
6. **Set up repository hygiene:**
   - Ensure the default branch is named `main`. If it is named `master`, rename it.
   - Set a repository description and relevant topics for discoverability.
7. **Set up a reproducible, worktree-ready development environment:**
   - Configure a stack-appropriate environment activation path from inside the repository (for example, Nix + direnv, devcontainer, virtual environment).
   - Define a worktree bootstrap entry point at the repository root (prefer `script/setup` following scripts-to-rule-them-all, or a clearly documented equivalent command).
   - Keep host prerequisites minimal and document them explicitly.
   - Verify that from a fresh git worktree, bootstrap + activation can run build, lint, type-check, and test without undeclared global dependencies or setup performed in another worktree.
8. **Create the `docs/` directory.**
9. **Assess observability:**
   - Can the agent run the project and see output? If not, create a run/start script.
   - Can the agent run tests and see results? If not, configure the test runner for CLI output.
   - Can the agent read logs? Document log locations and how to enable debug logging.
   - Can the agent observe the UI? If it's a CLI tool, yes. If it's a GUI app, document the limitation and evaluate whether DOM snapshots, screenshot automation, or visual regression tests can close the gap.
   - Fill in the Observability section of AGENTS.md (via the CLAUDE.md symlink).

## Phase 2: Documentation

Run the documentation commands in this order. Each one builds on the previous.

1. **Run `/prd`** — For existing codebases, the agent reverse-engineers the product from the code and interviews you. For greenfield or minimally implemented projects, the agent uses interview-first mode to draft the PRD from your intent and marks non-implemented features as planned. Review and correct the output. This is the most important document because everything else references it.
2. **Run `/architecture`** — The agent reads the codebase and produces the architecture doc. Review the ADRs — the agent will infer rationale, and you need to correct the "why" where it's wrong.
3. **Write `docs/CONVENTIONS.md`** — This one is best written by you (with agent help). The agent can document existing patterns, but only you know which patterns are intentional vs. accidental.
4. **Run `/traceability`** — The agent maps PRD features to tests. This will expose coverage gaps. Don't fix them yet — just know where they are.

## Phase 3: Backfill (ongoing)

1. Review the traceability matrix. Identify the highest-priority coverage gaps.
2. Use `/tech` to create test-gap issues for each.
3. Use `/implement` to fill them, one at a time.
4. Raise coverage expectations as gaps are filled.

## Phase 4: Register

1. Add the project to the Registry of Lands table in FEDERATION.md. Mark each column honestly.
2. Document any known cross-Land dependencies in the Land's own `docs/ARCHITECTURE.md` — contracts this Land consumes from other Lands.

## Checklist: When Is a Land "Governed"?

A Land reaches `Governed` status when ALL of the following are true:

- [ ] AGENTS.md exists and CLAUDE.md is a symlink to AGENTS.md
- [ ] docs/PRD.md exists and covers all implemented features
- [ ] docs/ARCHITECTURE.md exists and matches the actual code
- [ ] docs/CONVENTIONS.md exists
- [ ] docs/CONVENTIONS.md documents external contract boundary patterns (if the Land exposes or consumes cross-Land contracts)
- [ ] docs/TRACEABILITY.md exists with no "Missing" features that are high-priority
- [ ] Linter configured and enforced via pre-commit
- [ ] Formatter configured and enforced via pre-commit
- [ ] Type checker (if applicable) configured and enforced
- [ ] Test suite exists and is enforced in CI
- [ ] CI pipeline runs build + test + lint on every push
- [ ] Branch protection enabled on default branch with status checks, up-to-date requirement, force-push blocking, deletion restriction, and code scanning gate
- [ ] Automated dependency update tooling configured (Dependabot, Renovate, or equivalent)
- [ ] Secret scanning with push protection enabled
- [ ] Automated code scanning enabled and gating merges
- [ ] CI workflows use least-privilege permissions
- [ ] Default branch named `main`
- [ ] Repository description and topics set
- [ ] Issue/PR linkage convention is documented in AGENTS.md (via CLAUDE.md symlink)
- [ ] Pre-commit hooks installed and working
- [ ] Reproducible development environment is documented in AGENTS.md (via CLAUDE.md symlink) with activation steps, a worktree bootstrap entry point (`script/setup` preferred), and minimal host prerequisites
- [ ] From a fresh git worktree, bootstrap + activation can run build/lint/type-check/test without undeclared global setup or reliance on sibling worktrees
- [ ] AGENTS.md (via CLAUDE.md symlink) includes an Observability section (what the agent can do independently, what requires developer assistance, debug mode)
- [ ] Cross-Land dependencies documented in the Land's own `docs/ARCHITECTURE.md` (if applicable)
