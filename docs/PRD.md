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
   principles, separation of powers, standard documents, guardrails (including
   automated dependency updates), agent environment requirements, and development
   workflow that every governed project must follow.

2. **F2: Agent Command Specifications** — A reusable set of command
   specifications that structure the full development lifecycle: planning
   (`/bug`, `/feature`, `/tech`), documentation (`/prd`, `/architecture`,
   `/traceability`), implementation (`/implement`, `/ship`), review (`/review`,
   `/address`), reflection (`/learn`, `/knowledge`), and governance (`/amend`).
   `/prd` supports both reverse-engineering and interview-first greenfield mode.
   Workflow commands follow the Land's issue/PR linkage convention declared in
   `CLAUDE.md`.

3. **F3: Command Installation** — A script that symlinks all command
   specifications into the developer's agent tool configuration directories
   (Claude Code and Codex), so that changes to command specs take effect
   immediately across all tools.

4. **F4: Land Admittance** — A phased process for bringing a new or existing
   project under governance: foundation setup (including `CLAUDE.md` with
   `AGENTS.md` symlinked to it), documentation generation, test backfill, and
   federation registration.

5. **F5: Federation Registry** — A table tracking every governed project and its
   compliance status across standard documents, tracked guardrails, key
   admittance requirements, and overall governance state.

6. **F6: Project Templates** — Starter templates for `CLAUDE.md`/`AGENTS.md`
   and `CONVENTIONS.md` that new projects fill in with their own details,
   ensuring consistent structure across the federation.

7. **F7: Automated Quality Checks** — A Nix-based development environment that
   provides pre-commit hooks (markdown lint, markdown formatting, shell lint,
   shell formatting) and a CI pipeline that runs the same checks on pull
   requests and on pushes to `main`.

8. **F8: Land Archival** — A defined process for archiving projects that are no
   longer actively maintained, including triggers, steps, and a reactivation
   path.

9. **F9: Governance Amendment** — A structured process for changing the
   constitution itself, requiring the same planning and review workflow used for
   code changes.

10. **F10: Hotfix Exception** — A fast-path workflow that allows skipping the
    planning phase for critical bugs, with mandatory cleanup within 24 hours.

11. **F11: Cross-Land Impact Assessment** — A process for evaluating how changes
    to external contracts (APIs, shared libraries, message formats, file formats,
    database schemas) in one Land affect dependent Lands, with cross-Land
    dependencies tracked in each Land's own `docs/ARCHITECTURE.md` and a
    mandatory review step that blocks merging until the assessment is complete.

12. **F12: Reproducible Development Environment Requirement** — A governance
    requirement that each Land defines a stack-appropriate, repo-local
    environment activation path and a worktree bootstrap entry point (prefer
    `script/setup` or an equivalent command), with minimal host prerequisites,
    so development workflows run without hidden machine-specific setup.

13. **F13: Infrastructure-Agnostic Governance** — The constitution and command
    specifications do not prescribe specific source code hosting, issue
    tracking, or CI/CD platforms. Each Land declares its infrastructure tooling
    in its CLAUDE.md. Each Land also declares its issue/PR linkage convention
    there. Command specs reference declared tooling and linkage conventions
    rather than hardcoding vendor-specific CLI commands. Vendor-specific
    knowledge is preserved in dedicated skills (`managing-github` skill for
    GitHub, `managing-youtrack` skill for YouTrack, etc.), such as the skills
    published in [`forketyfork/agentic-skills`](https://github.com/forketyfork/agentic-skills).

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
   reading project docs, and producing the expected output (an issue, a PR,
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
2. Developer sets up the repository foundation: `CLAUDE.md` with
   `AGENTS.md -> CLAUDE.md` symlink, guardrails, pre-commit hooks, CI, branch
   protection, observability, and issue/PR linkage convention (Phase 1).
3. Developer runs documentation commands (`/prd`, `/architecture`, writes
   `CONVENTIONS.md`, runs `/traceability`) to generate standard docs (Phase 2).
   For greenfield projects, `/prd` starts in interview-first mode.
4. Developer backfills test coverage gaps identified by the traceability matrix
   (Phase 3, ongoing).
5. Developer registers the project in `FEDERATION.md` and documents any known
   cross-Land dependencies in the Land's own `docs/ARCHITECTURE.md` (Phase 4).

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
   `CLAUDE.md`, fills in the bracketed placeholders, and creates
   `AGENTS.md -> CLAUDE.md` symlink.
3. Developer copies `templates/CONVENTIONS.md.template` to `docs/CONVENTIONS.md`
   and fills in project-specific patterns.

**Result:** The new project starts with the correct document structure and
required sections.

### F7: Automated Quality Checks

1. Developer enters the Nix dev shell (`nix develop` or `direnv allow`).
2. Pre-commit hooks are installed automatically.
3. On every commit, hooks check markdown lint, markdown formatting, shell lint,
   and shell formatting.
4. On pull requests and on pushes to `main`, the CI pipeline runs the same
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
   an issue.
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
5. Within 24 hours, the developer retroactively creates the issue, updates the
   PR title/body/metadata to reference that issue using the Land's documented
   issue/PR linkage convention (including auto-close behavior where supported),
   links the PR, and runs `/learn`.

**Result:** Critical bugs are fixed immediately without sacrificing review
quality, with full documentation created retroactively.

### F11: Cross-Land Impact Assessment

1. A PR in one Land modifies an external contract (API route, shared type,
   message schema, file format, or database schema).
2. During `/review`, the reviewer identifies the contract change by checking
   against patterns documented in that Land's CONVENTIONS.md.
3. The reviewer consults the `docs/ARCHITECTURE.md` of other Lands in the
   Federation to find all Lands that consume the changed contract.
4. For each dependent Land, the reviewer assesses impact: _breaks_ (requires
   coordinated change), _needs update_ (should adapt but won't break
   immediately), or _unaffected_ (backward-compatible). The assessment is
   recorded in the PR description.
5. For each Land marked _breaks_ or _needs update_, a linked issue is
   created in that Land's repository before the original PR merges.

**Result:** Contract changes never silently break dependent Lands. Every
cross-Land impact is assessed, documented, and tracked before merging.

### F12: Reproducible Development Environment Requirement

1. Developer enters a Land repository and reads environment activation steps in
   that Land's `CLAUDE.md`, including the worktree bootstrap command.
2. Developer initializes a fresh git worktree, runs the documented bootstrap
   entry point, and activates the stack-appropriate development environment from
   inside that worktree.
3. Developer and agent run build, lint, type-check, and test workflows without
   relying on undeclared global machine setup or prior setup in other
   worktrees.

**Result:** Environment setup is repeatable for each worktree, reducing setup
drift and hidden dependencies.

### F13: Infrastructure-Agnostic Governance

1. Developer reads the constitution's Infrastructure section, which defines
   outcome requirements for issue tracker, source code hosting, and CI/CD
   without naming specific vendors.
2. Developer fills in the Infrastructure section of their project's CLAUDE.md
   with the specific tools used (e.g., GitHub + GitHub Actions, or GitLab +
   GitLab CI), plus that Land's issue/PR linkage convention.
3. When an agent runs a command like `/ship` or `/address`, it reads the
   project's CLAUDE.md to determine which CLI or API to use and how to apply
   issue/PR linkage.
4. For projects on a supported platform, the agent can use a platform-specific
   skill from an external skill catalog (e.g., the `managing-github` skill for
   GitHub) for concrete CLI commands.

**Result:** The governance framework works with any combination of source code
hosting, issue tracking, and CI/CD. Projects self-declare their tooling, and
agents adapt.

## Success Criteria

- **F1:** The constitution covers principles, separation of powers, standard
  documents, guardrails (including automated dependency updates), agent
  environment, agent commands, the development workflow, federation management,
  archival, and the amendment process.
- **F2:** Command specifications exist for each governance workflow area, each
  defining the command's purpose, input, procedure, output format, and
  behavioral rules.
- **F3:** Running `install-commands.sh` creates working symlinks to
  `~/.claude/commands/` and `~/.codex/prompts/` for every command spec; the
  script is idempotent and handles existing symlinks, updated targets, and
  non-symlink conflicts.
- **F4:** `ADMITTANCE.md` describes all phases with concrete steps and
  includes a checklist for when a Land reaches "Governed" status.
- **F5:** `FEDERATION.md` contains a registry table with columns for standard
  documents, tracked guardrails, and key admittance requirements, with clear
  status indicators and a column legend.
- **F6:** Templates exist for `CLAUDE.md` and `CONVENTIONS.md` with bracketed
  placeholders and instructional comments covering all required sections,
  including worktree bootstrap and issue/PR linkage metadata.
- **F7:** Pre-commit hooks and CI run markdownlint, Prettier, ShellCheck, shfmt,
  and a conventions validation script (`check-conventions.sh`); CI blocks merges
  on failure. Every `[auto: <tool>]` rule in CONVENTIONS.md names the enforcing
  tool or rule. `/review` includes a step that checks `[review]`-tagged conventions
  against the PR diff.
- **F8:** The constitution documents archival triggers, the archival process,
  and the reactivation path.
- **F9:** The constitution defines the amendment process requiring the same
  planning-review workflow used for code changes.
- **F10:** The constitution documents the hotfix criteria, fast path, and
  mandatory cleanup steps.
- **F11:** The constitution defines what constitutes an external contract change,
  the four-step assessment process (flag, check dependencies, assess, notify),
  and the merge-blocking rule. Each Land tracks its own cross-Land dependencies
  in `docs/ARCHITECTURE.md`. `/review` includes a cross-Land impact step that
  checks contract changes against the architecture documents of dependent Lands.
- **F12:** The constitution and admittance process require each Land to document
  and validate a reproducible, worktree-ready development environment with
  minimal host prerequisites, a clear activation path, and a documented
  bootstrap entry point (`script/setup` preferred).
- **F13:** The constitution's Infrastructure section defines outcome requirements
  for source code hosting, issue tracking, and CI/CD without naming specific
  vendors. The CLAUDE.md template includes an Infrastructure section with
  placeholders, including issue/PR linkage convention metadata. Command
  specifications use generic terms and reference the project's declared tooling
  and linkage convention. Vendor-specific CLI knowledge is available through
  dedicated skills (`managing-github` skill for GitHub,
  `managing-youtrack` skill for YouTrack, etc.), including skills provided by
  external catalogs such as
  [`forketyfork/agentic-skills`](https://github.com/forketyfork/agentic-skills).
