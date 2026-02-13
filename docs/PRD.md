# Product Requirements Document

## Problem Statement

A single developer maintains 10+ software projects where AI coding agents write
most of the code, using languages and frameworks the developer may not be fluent
in. Without shared structure, documentation drifts, conventions diverge across
projects, automated checks are inconsistent, and code quality silently degrades.
This governance framework provides the standardized documentation, mandatory
guardrails, structured workflows, and human checkpoints that prevent that rot.

## Core Features

1. **F1: Constitution** — A single authoritative document defining the
   principles, separation of powers, standard documents, guardrails, agent
   environment requirements, and development workflow that every governed project
   must follow.

2. **F2: Agent Command Specifications** — A set of 13 reusable command
   specifications that structure the full development lifecycle: planning
   (`/bug`, `/feature`, `/tech`), documentation (`/prd`, `/architecture`,
   `/traceability`), implementation (`/implement`, `/ship`), review (`/review`,
   `/address`), reflection (`/learn`, `/knowledge`), and governance (`/amend`).

3. **F3: Command Installation** — A script that symlinks all command
   specifications into the developer's agent tool configuration directories
   (Claude Code and Codex), so that changes to command specs take effect
   immediately across all tools.

4. **F4: Land Admittance** — A phased process for bringing a new or existing
   project under governance: foundation setup, documentation generation, test
   backfill, and federation registration.

5. **F5: Federation Registry** — A table tracking every governed project and its
   compliance status across standard documents, automated guardrails, and
   overall governance state.

6. **F6: Project Templates** — Starter templates for `CLAUDE.md` and
   `CONVENTIONS.md` that new projects fill in with their own details, ensuring
   consistent structure across the federation.

7. **F7: Automated Quality Checks** — A Nix-based development environment that
   provides pre-commit hooks (markdown lint, markdown formatting, shell lint,
   shell formatting) and a CI pipeline that runs the same checks on every push
   and pull request.

8. **F8: Land Archival** — A defined process for archiving projects that are no
   longer actively maintained, including triggers, steps, and a reactivation
   path.

9. **F9: Governance Amendment** — A structured process for changing the
   constitution itself, requiring the same planning and review workflow used for
   code changes.

10. **F10: Hotfix Exception** — A fast-path workflow that allows skipping the
    planning phase for critical bugs, with mandatory cleanup within 24 hours.

## Non-Goals

- **Code generation.** The governance framework defines workflows and
  constraints for AI agents but does not generate application code itself.
- **Runtime enforcement.** Guardrails are enforced through static checks
  (linters, formatters, CI). There is no runtime component or daemon.
- **Multi-developer collaboration.** The framework assumes a single developer
  with AI agents. It does not address team coordination, role-based access, or
  multi-author governance.
- **Language-specific tooling.** Stack-specific guardrails (ESLint, Detekt, zig
  fmt) are recommended in the constitution but implemented within each project,
  not in this repository.

## User Flows

### F1: Constitution

1. Developer reads `CONSTITUTION.md` to understand the governance model.
2. Developer references specific sections (principles, guardrails, workflows)
   when setting up a new project or resolving a governance question.
3. The constitution serves as the authoritative source during disputes about
   process or standards.

**Result:** The developer has a single, unambiguous reference for how all
governed projects operate.

### F2: Agent Command Specifications

1. Developer invokes a command (e.g., `/feature`) in their AI coding agent.
2. The agent reads the corresponding command specification from the symlinked
   file.
3. The agent follows the specification's procedure: interviewing the developer,
   reading project docs, and producing the expected output (a GitHub issue, a PR,
   a review walkthrough, etc.).

**Result:** The agent performs a structured task with consistent quality across
all projects.

### F3: Command Installation

1. Developer runs `./scripts/install-commands.sh`.
2. The script creates symlinks from `commands/*.md` to `~/.claude/commands/` and
   `~/.codex/prompts/`.
3. If a symlink already points to the correct target, it is skipped. If it
   points elsewhere, it is updated. Non-symlink files at the target path are not
   overwritten.

**Result:** All agent commands are available in the developer's Claude Code and
Codex environments, and future edits to command specs propagate instantly.

### F4: Land Admittance

1. Developer decides a project is worth governing (Phase 0).
2. Developer sets up the repository foundation: `CLAUDE.md`, guardrails,
   pre-commit hooks, CI, branch protection, observability (Phase 1).
3. Developer runs documentation commands (`/prd`, `/architecture`, writes
   `CONVENTIONS.md`, runs `/traceability`) to generate standard docs (Phase 2).
4. Developer backfills test coverage gaps identified by the traceability matrix
   (Phase 3, ongoing).
5. Developer registers the project in `FEDERATION.md` (Phase 4).

**Result:** The project is fully governed with all standard documents, automated
checks, and federation registration in place.

### F5: Federation Registry

1. Developer opens `FEDERATION.md`.
2. The table shows each governed project with its compliance status across all
   required documents and guardrails.
3. Developer uses the table to identify which projects need attention.

**Result:** A single view of governance compliance across all projects.

### F6: Project Templates

1. Developer creates a new project and decides to govern it.
2. Developer copies `templates/CLAUDE.md.template` to the new project's root as
   `CLAUDE.md` and fills in the bracketed placeholders.
3. Developer copies `templates/CONVENTIONS.md.template` to `docs/CONVENTIONS.md`
   and fills in project-specific patterns.

**Result:** The new project starts with the correct document structure and
required sections.

### F7: Automated Quality Checks

1. Developer enters the Nix dev shell (`nix develop` or `direnv allow`).
2. Pre-commit hooks are installed automatically.
3. On every commit, hooks check markdown lint, markdown formatting, shell lint,
   and shell formatting.
4. On every push or pull request to `main`, the CI pipeline runs the same
   checks.

**Result:** No malformed markdown or shell scripts reach the main branch.

### F8: Land Archival

1. An archival trigger is identified (no commits in 6 months, developer stopped
   using the software, project superseded, or platform abandoned).
2. Developer updates `FEDERATION.md` to mark the project as `Archived`.
3. Developer adds an archival note to the project's README.
4. Optionally, CI and branch protection are disabled.

**Result:** The project is honestly marked as inactive while its documentation
remains intact for reference.

### F9: Governance Amendment

1. Developer identifies a governance change needed (from a review, a session
   learning, or direct observation).
2. Developer runs `/feature` or `/tech` to plan the governance change as a
   GitHub issue.
3. The change is implemented, reviewed, and merged following the standard
   workflow.
4. Affected command specifications and Land-level `CLAUDE.md` files are updated.

**Result:** Governance evolves deliberately through the same structured process
used for code changes.

### F10: Hotfix Exception

1. A critical bug blocks the developer's immediate workflow.
2. Developer skips `/bug` and goes directly to `/implement` with a verbal
   description.
3. The agent reads project docs, writes a regression test, implements the fix,
   and ships a PR.
4. `/review` still happens — planning is skipped, not review.
5. Within 24 hours, the developer retroactively creates the issue, links the PR,
   and runs `/learn`.

**Result:** Critical bugs are fixed immediately without sacrificing review
quality, with full documentation created retroactively.

## Success Criteria

- **F1:** The constitution covers principles, separation of powers, standard
  documents, guardrails, agent environment, agent commands, the development
  workflow, federation management, archival, and the amendment process.
- **F2:** All 13 command specifications exist, each defining the command's
  purpose, input, procedure, output format, and behavioral rules.
- **F3:** Running `install-commands.sh` creates working symlinks to
  `~/.claude/commands/` and `~/.codex/prompts/` for every command spec; the
  script is idempotent and handles existing symlinks, updated targets, and
  non-symlink conflicts.
- **F4:** `ADMITTANCE.md` describes all four phases with concrete steps and
  includes a checklist for when a Land reaches "Governed" status.
- **F5:** `FEDERATION.md` contains a table with columns for every standard
  document and guardrail, with clear status indicators and a column legend.
- **F6:** Templates exist for `CLAUDE.md` and `CONVENTIONS.md` with bracketed
  placeholders and instructional comments covering all required sections.
- **F7:** Pre-commit hooks and CI run markdownlint, Prettier, ShellCheck, and
  shfmt; CI blocks merges on failure.
- **F8:** The constitution documents archival triggers, the archival process,
  and the reactivation path.
- **F9:** The constitution defines the amendment process requiring the same
  planning-review workflow used for code changes.
- **F10:** The constitution documents the hotfix criteria, fast path, and
  mandatory cleanup steps.
