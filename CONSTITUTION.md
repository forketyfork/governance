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

### Session Commands

| Command      | Purpose                                     | Input                               | Output                                       |
| ------------ | ------------------------------------------- | ----------------------------------- | -------------------------------------------- |
| `/learn`     | Extract learnings to update CLAUDE.md       | Current session context + CLAUDE.md | Proposed CLAUDE.md updates with diff preview |
| `/knowledge` | Extract reusable knowledge from the session | Current session context             | Knowledge notes saved to Zettelkasten        |

### The Workflow

```text
  PLAN                                IMPLEMENT                       REVIEW
  ─────                               ─────────                       ──────

  /bug
  /feature    ──►  GitHub Issue  ──►  /implement  ──►  Draft PR  ──►  /review   ─┬──►  Merge
  /tech                               /ship                           /address ◄─┘
                       ▲                                                ▲
                       │                                                │
                  Human reviews                                    Human reviews
                  the issue                                        the PR
```

Two human checkpoints. Everything between them is delegated to agents.

---

## The Federation

Federation is a collection of Lands sharing the same governance model. The Lands accepted into the Federation are listed in the FEDERATION.md file.

Admittance of a new Land into the Federation must follow the process outlined in the ADMITTANCE.md file.

---

## Amending This Constitution

This document itself follows the same rules. To change it:

1. Run `/feature` or `/tech` describing the governance change.
2. Implement the change in this document.
3. Update any affected command specifications.
4. Update CLAUDE.md files in affected Lands if the change impacts their workflow.

Do not make governance changes ad-hoc. If a rule is wrong or unnecessary, change it deliberately — don't just start ignoring it.
