# CONSTITUTION

## Preamble

This document governs the Federation of software projects (Lands) maintained by a single developer using AI coding agents. The developer does not write most of the code. The developer steers architecture, reviews boundaries, and makes judgment calls. The agents write code, but only within constraints defined here.

The core problem this constitution solves: when AI writes code the developer barely reads, using programming languages and frameworks the developer may not be fluent in, across 10+ projects — how do you prevent everything from silently rotting?

The answer: standardized documentation, mandatory guardrails, structured workflows, and human checkpoints at every boundary.

---

## Principles

1. **No code without context.** An agent must read the project's documentation before writing a single line. No exceptions.
2. **No implementation without specification.** Every change starts as a GitHub issue produced by a planning agent. The implementing agent works from the issue, not from vibes.
3. **No merge without review.** Every PR is a draft until the developer reviews it. The developer reviews boundaries (interfaces, architecture, tests), not every line.
4. **Document what IS, not what should be.** If the code violates its own architecture doc, fix the code or fix the doc — never pretend the violation doesn't exist.
5. **Automate what humans forget.** Linters, formatters, type checkers, pre-commit hooks, and CI exist because the developer will skip manual checks when tired. The machines don't get tired.

---

## Separation of Powers

The governance framework operates through three branches:

**Legislative** — The rules. CONSTITUTION.md, command specifications, CONVENTIONS.md, ARCHITECTURE.md, and PRD.md. These define what agents must do and what they must not do. Changes to the legislative branch follow the amendment process.

**Executive** — Mechanical enforcement. Linters, formatters, type checkers, pre-commit hooks, CI pipelines, branch protection, coverage thresholds. The executive enforces rules without discretion. If a rule can be expressed as an automated check, it should be — documentation is the fallback, not the primary enforcement mechanism.

**Judiciary** — Interpretation and judgment. The `/review` command and the human checkpoints. The judiciary decides whether the spirit of the law was followed in a specific case, not just the letter. When `/review` identifies a pattern as problematic, that ruling should flow back into the legislative branch (update the rules) or the executive branch (add a linter rule).

**Precedent flows upward.** When the judiciary (review) identifies a recurring problem, it becomes case law. Case law that applies to one project flows into that project's CONVENTIONS.md via `/learn`. Case law that applies across the federation flows into the governance repo via `/amend`.

---

## Standard Documents

Every Land must maintain these documents in a `docs/` directory at the repository root. They are living documents, updated as part of the development workflow — not after.

| Document               | Purpose                                                                                                                                                        | Created by                        | Updated by                                                       |
| ---------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------- | ---------------------------------------------------------------- |
| `docs/PRD.md`          | What the software does, for whom, and why. Features, user flows, success criteria, non-goals. Source of truth for WHAT.                                        | `/prd` command                    | `/prd` command or manually during `/feature` workflow            |
| `docs/ARCHITECTURE.md` | How the software is built. Layers, modules, dependencies, data flow, patterns, ADRs. Source of truth for HOW.                                                  | `/architecture` command           | `/architecture` command or manually during `/implement` workflow |
| `docs/CONVENTIONS.md`  | Coding patterns for this specific project. Naming, error handling, state management, file structure, stack-specific idioms. Fed to the agent at session start. | Manually or with agent assistance | Manually when patterns evolve                                    |
| `docs/TRACEABILITY.md` | Maps PRD features to test files. Shows what's tested, what's partial, what's missing.                                                                          | `/traceability` command           | `/traceability` command or during `/implement` workflow          |

Additionally, each project has a `CLAUDE.md` (symlinked to `AGENTS.md`) at the repository root containing agent-specific instructions, project context, and references to the docs/ files.

---

## Standard Guardrails

Every Land must have these automated checks in place. They are non-negotiable because they catch problems the developer will miss during review.

### Universal (all projects)

| Guardrail                     | Purpose                                                              |
| ----------------------------- | -------------------------------------------------------------------- |
| Pre-commit hooks              | Block commits that fail lint, format, type check, or test            |
| CI pipeline                   | Build + test + lint on every push. PRs cannot merge without green CI |
| Branch protection             | Main/master requires passing CI                                      |
| Conventional commits          | Structured commit messages. Agents must follow this                  |
| Max file length: 300 lines    | Forces decomposition. Exceeding = refactor before continuing         |
| Max function length: 50 lines | Same principle at function level                                     |
| No TODOs in code              | Incomplete work goes in GitHub issues, not in source comments        |

### Stack-Specific

This is a non-exhaustive list of recommended tools for different platforms provided as a reference. Every land must use these tools or their equivalents.

#### TypeScript/CSS (Obsidian Plugins)

| Tool                      | Purpose                                    |
| ------------------------- | ------------------------------------------ |
| ESLint (strict, no `any`) | Catch type errors and bad patterns         |
| Prettier                  | Consistent formatting                      |
| `tsc --noEmit --strict`   | Type checking                              |
| Vitest or Jest            | Test runner                                |
| c8 or Istanbul            | Coverage (threshold: 60%, raise over time) |
| Stylelint                 | CSS linting                                |

#### Zig

| Tool             | Purpose                 |
| ---------------- | ----------------------- |
| `zig fmt`        | Formatting              |
| `zig build test` | Built-in test runner    |
| `zwanzig`        | Catch memory bugs in CI |

#### Kotlin Multiplatform

| Tool                 | Purpose                                    |
| -------------------- | ------------------------------------------ |
| Detekt               | Static analysis                            |
| ktlint               | Formatting                                 |
| kotlin.test / JUnit5 | Test runner                                |
| Kover                | Coverage (threshold: 60%, raise over time) |

### Rule Promotion

Every documented convention is a candidate for automation. Promotion is the process of turning a CONVENTIONS.md entry into a linter rule, type constraint, or automated test.

**When to promote:**

- When `/review` flags the same violation twice across different PRs
- When a new Land is admitted and the convention applies to its stack
- During Phase 3 backfill, alongside test gap work

**How to promote:**

1. Identify the convention in CONVENTIONS.md.
2. Determine the enforcement mechanism (linter rule, type constraint, pre-commit check, CI test).
3. Implement the automated check.
4. Update CONVENTIONS.md to note that the rule is now enforced automatically, keeping the explanation of _why_.
5. If the rule applies across the federation, propose an amendment to the governance repo.

**Tracking:** In CONVENTIONS.md, mark each rule with its enforcement status:

- `[auto]` — enforced by linter, type system, or CI
- `[review]` — enforced during code review only
- `[planned]` — automation planned but not yet implemented

---

## Agent Environment

Each Land must minimize the developer-as-relay bottleneck. The goal: the agent should never ask for something it could have obtained itself if the project were properly configured.

### Reproducible Development Environment

Each Land must provide a reproducible development environment that can be
activated from within the project directory. The mechanism is stack-specific
and may use any appropriate toolchain (for example, Nix + direnv,
devcontainers, virtual environments), but the outcome is mandatory:

- The activation path is documented in the Land's CLAUDE.md.
- A worktree bootstrap entry point is documented (prefer `script/setup` per
  scripts-to-rule-them-all, or a clearly documented equivalent command).
- Required host prerequisites are minimal and explicitly documented.
- Build, lint, type-check, and test workflows run without hidden global setup.
- A fresh git worktree can run bootstrap + activation and then execute build,
  lint, type-check, and test workflows without relying on setup performed in
  other worktrees.
- Setup instructions are deterministic enough for both the developer and the
  agent to follow without project-external tribal knowledge.

This is an outcome requirement, not a tool mandate. A Land is compliant when a
new machine with the documented prerequisites can enter a fresh worktree, run
the documented bootstrap and activation paths, and execute the Land's standard
workflows.

### Observability

Each Land's CLAUDE.md must include an **Observability** section documenting:

- **What the agent can do independently** — run tests, start the application, read logs, hit endpoints, inspect build output
- **What requires developer assistance** — UI state observation, mobile device interaction, hardware-dependent behavior
- **Debug mode** — how to enable verbose logging or diagnostic output

During admittance, for each "requires developer assistance" item, assess whether a script, tool, or CI artifact could close the gap. Close cheap gaps immediately. Document expensive gaps as known limitations.

### Enforceability

Rules documented in CONVENTIONS.md and ARCHITECTURE.md are the first line of defense. Automation is the permanent fix.

For every rule in CONVENTIONS.md, ask: **can this be a linter rule, a type constraint, or a test instead?** If yes, promote it. The document becomes the explanation of _why_ the rule exists; the linter becomes the enforcement.

Promotion priority:

1. **Type system** — catches errors at compile time, zero runtime cost
2. **Linter rule** — catches errors before commit, fast feedback
3. **Pre-commit hook** — catches errors before push, slightly slower
4. **CI check** — catches errors before merge, last automated gate
5. **Documentation** — catches errors during review, requires human attention

Rules enforced only by documentation will eventually be violated. Rules enforced by automation are violated only by disabling the automation — which is visible and auditable.

---

## Agent Commands

All Lands share a common set of agent commands that structure the development workflow. The command specifications are maintained separately and wired into the agent configuration (CLAUDE.md/AGENTS.md, or tool-specific config).

### Documentation Commands

| Command         | Purpose                               | Input                                 | Output                                             |
| --------------- | ------------------------------------- | ------------------------------------- | -------------------------------------------------- |
| `/architecture` | Create or update docs/ARCHITECTURE.md | Full codebase access                  | Architecture document verified against actual code |
| `/prd`          | Create or update docs/PRD.md          | Full codebase access + user interview | Product requirements document                      |
| `/traceability` | Create or update docs/TRACEABILITY.md | docs/PRD.md + all test files          | Feature-to-test mapping with coverage gaps         |

### Workflow Commands

| Command      | Purpose                               | Input                                   | Output                                                                   |
| ------------ | ------------------------------------- | --------------------------------------- | ------------------------------------------------------------------------ |
| `/bug`       | Triage a bug report                   | User interview                          | GitHub issue with reproduction steps and acceptance criteria             |
| `/feature`   | Plan a new feature                    | User interview + project docs           | GitHub issue with status quo, objectives, user flow, implementation plan |
| `/tech`      | Plan a technical improvement          | User interview + project docs           | GitHub issue with status quo, objectives, tasks, risk assessment         |
| `/implement` | Implement a GitHub issue              | GitHub issue + project docs             | Draft PR with tests, doc updates, and checklist                          |
| `/ship`      | Commit, push, and create a PR         | Uncommitted changes + session context   | Branch, commit, and draft PR ready for review                            |
| `/review`    | Guide the developer through PR review | PR diff + linked issue + project docs   | Step-by-step review walkthrough with verdict                             |
| `/address`   | Address PR review and issue comments  | Unresolved review comments + PR context | Classified comments, fixes, and reply drafts                             |
| `/amend`     | Propose a governance amendment        | Project-level insight + governance docs | PR against governance repo with classification and affected Lands        |

### Session Commands

| Command      | Purpose                                  | Input                               | Output                                           |
| ------------ | ---------------------------------------- | ----------------------------------- | ------------------------------------------------ |
| `/learn`     | Extract learnings to update CLAUDE.md    | Current session context + CLAUDE.md | Proposed CLAUDE.md updates with diff preview     |
| `/knowledge` | Produce learning notes for the developer | Current session context             | Learning notes saved to developer's Zettelkasten |

### The Workflow

The development workflow has four phases:

1. **Plan** — A planning command (`/bug`, `/feature`, or `/tech`) interviews the developer and produces a GitHub issue with clear scope, acceptance criteria, and implementation tasks. The developer reviews the issue before implementation begins. _(Human checkpoint 1.)_
2. **Implement** — `/implement` picks up the approved issue and produces code: a draft PR with tests, documentation updates, and a checklist. `/ship` handles the mechanics of committing, pushing, and creating the PR.
3. **Review** — `/review` walks the developer through the PR diff with a structured checklist. The developer makes the merge decision. If changes are needed, `/address` processes review comments and produces fixes. _(Human checkpoint 2.)_
4. **Reflect** — After the session's work is done, `/learn` extracts reusable insights into the project's CLAUDE.md so future agent sessions start smarter. `/knowledge` produces learning notes the developer can study in their Zettelkasten — staying informed about their own codebase without reading every line of code.

```text
  PLAN                          IMPLEMENT                   REVIEW                   REFLECT
  ─────                         ─────────                   ──────                   ───────

  /bug
  /feature ──► GitHub Issue ──► /implement ──► Draft PR ──► /review  ─┬──► Merge ──► /learn
  /tech                         /ship                       /address ◄┘              /knowledge

                    ▲                                          ▲
                    │                                          │
               Human reviews                              Human reviews
               the issue                                  the PR
```

Two human checkpoints bracket the automated work. Everything between them is delegated to agents. The Reflect phase happens at session end and requires no human gate — its outputs (updated CLAUDE.md, learning notes) are additive.

### Hotfix Exception

When a critical bug blocks the developer's immediate workflow, the normal planning phase may be skipped. The implementation phase starts directly.

**Criteria:** The bug prevents normal use of the software _right now_. Not "this is annoying" — "this is broken and I need it working."

**Fast path:**

1. Skip `/bug`. Go directly to `/implement` with a verbal description of the problem. No GitHub issue is required at this stage.
2. The agent must still read project docs before coding.
3. The agent must still write a regression test.
4. `/ship` produces a PR without a `fixes #` reference (the issue does not exist yet).
5. `/review` still happens — the fast path skips planning, not review.

**Cleanup (mandatory within 24 hours):**

- Create the GitHub issue retroactively using `/bug`.
- Link the PR to the issue.
- Run `/learn` to capture what broke and why.

If hotfixes become frequent for a specific Land, that's a signal the test coverage or architecture has gaps. Create a `/tech` issue to address the root cause.

---

## The Federation

Federation is a collection of Lands sharing the same governance model. The Lands accepted into the Federation are listed in the FEDERATION.md file.

Admittance of a new Land into the Federation must follow the process outlined in the ADMITTANCE.md file.

### Cross-Land Impact

When a PR in one Land modifies an external contract, the change must be assessed for impact on dependent Lands before merging.

**What constitutes an external contract change:**

- API endpoints (REST, GraphQL, gRPC) — routes, request/response shapes, status codes, authentication requirements
- Shared library interfaces — exported functions, types, or modules consumed by other Lands
- Message formats — event schemas, queue payloads, serialization formats
- File formats — configuration files, data files, or protocols consumed by other tools
- Database schemas — tables, columns, or stored procedures accessed by multiple Lands

Each Land's CONVENTIONS.md should document file patterns and markers that indicate external contract boundaries (e.g., `api/`, `proto/`, `schemas/`). This enables `/review` to flag contract changes during the review phase.

**Assessment process:**

1. **Flag.** During `/review`, identify that the PR touches an external contract. The reviewer (human or agent) checks whether changed files match the contract patterns documented in CONVENTIONS.md.
2. **Check dependencies.** Consult the dependency map in FEDERATION.md for Lands that consume the changed contract.
3. **Assess.** For each dependent Land, determine the impact: _breaks_ (the Land will fail without a coordinated change), _needs update_ (the Land should adapt but won't break immediately), or _unaffected_ (the change is backward-compatible). Record this assessment in the PR description.
4. **Notify.** For each Land marked _breaks_ or _needs update_, create a linked GitHub issue in that Land's repository before merging the original PR. The issue must reference the originating PR and describe the required change.

**No PR that changes an external contract merges without steps 1–4 completed.** If a contract change is merged without assessment and a dependent Land breaks, treat it as a hotfix in the affected Land and create a `/tech` issue to add the missing dependency tracking.

Cross-Land dependencies are tracked in the dependency map in FEDERATION.md. Update the map whenever a new dependency is introduced or removed.

---

## Archival

A Land may be archived when it is no longer actively maintained. Archival is not failure — it is honest acknowledgment that governance resources should focus on active projects.

**Triggers for archival review:**

- No commits in 6 months
- The developer has stopped using the software
- The project has been superseded by another Land
- The underlying platform or dependency is abandoned

**Archival process:**

1. Update FEDERATION.md: change status to `Archived`.
2. Add a note in the project's README: "This project is archived and no longer maintained."
3. Disable CI and branch protection (optional — reduces noise).
4. Keep the repository and its docs intact — they may be useful for reference.

**Reactivation:** An archived Land can be reactivated by running the admittance process from Phase 1 step 3 (re-enable guardrails) if any were disabled during archival, otherwise from Phase 2 (documentation refresh).

---

## Amending This Constitution

This document itself follows the same rules. To change it:

1. Run `/feature` or `/tech` describing the governance change.
2. Implement the change in this document.
3. Update any affected command specifications.
4. Update CLAUDE.md files in affected Lands if the change impacts their workflow.

Do not make governance changes ad-hoc. If a rule is wrong or unnecessary, change it deliberately — don't just start ignoring it.
