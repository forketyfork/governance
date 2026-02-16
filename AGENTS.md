# AGENTS.md (symlinked as CLAUDE.md)

Canonical file: `AGENTS.md`. Keep `CLAUDE.md` as a symlink to `AGENTS.md`.

## Project

**Name:** governance  
**Description:** Shared command specs, templates, and process documentation for AI-assisted software projects. This repository defines the baseline workflow and standards that other projects can adopt.  
**Stack:** Markdown, Bash, Nix, GitHub Actions  
**Status:** Active development

## Build & Run

```bash
# Worktree bootstrap (run in a fresh worktree)
direnv allow    # optional, one-time per worktree if direnv is installed

# Environment activation
nix develop
#
# Minimal host prerequisites:
# - Nix
# - Git

# Build
nix flake check

# Run
./scripts/install-commands.sh

# Test
pre-commit run --all-files

# Type check
N/A (documentation and shell scripts only)

# Lint
markdownlint-cli2 '**/*.md'
shellcheck scripts/*.sh

# Format check
prettier --check '**/*.md' '**/*.md.template'
shfmt -d scripts/*.sh
```

## Infrastructure

- **Source code hosting:** GitHub — URL: `https://github.com/forketyfork/governance` — CLI: `gh`
- **Issue tracker:** GitHub Issues — URL: `https://github.com/forketyfork/governance/issues` — CLI: `gh issue`
- **CI/CD:** GitHub Actions — config: `.github/workflows/ci.yml`
- **Issue/PR linkage convention:** For issue-driven work, include the issue number in the PR title as `(#<number>)` and add `Fixes #<number>` in the PR body. For hotfixes without an issue, omit linkage first and add it after creating the retroactive issue.

## Governance

This repository is the source of command and process guidance. During day-to-day work in other repositories, commands must rely only on that target repository's local `CLAUDE.md`/`AGENTS.md` and local docs.

## Project Documentation

Read these before making any changes:

- `CONSTITUTION.md` — Principles, guardrails, and workflow model
- `ADMITTANCE.md` — Project onboarding protocol and checklist
- `FEDERATION.md` — Registry of tracked projects and status
- `docs/PRD.md` — Product requirements for this repository

## Agent Rules

1. Read the project documentation listed above before writing any code.
2. Follow existing conventions in command specs and templates; keep changes consistent with current file structure and formatting.
3. Do not modify `CONSTITUTION.md`, `FEDERATION.md`, or `ADMITTANCE.md` without explicit user approval.
4. Do not introduce new dependencies without asking first.
5. Use conventional commit messages.
6. For day-to-day command specs (`/bug`, `/feature`, `/tech`, `/implement`, `/ship`, `/review`, `/address`), do not reference governance-repository documents or federation-specific terminology. Assume the agent only has access to the target repository's local instructions and docs.

## Observability

### What the agent can do independently

- Run repository checks (`pre-commit run --all-files`, `nix flake check`)
- Run markdown and shell quality tools directly
- Create and update issues and pull requests via `gh`
- Inspect CI workflow runs and logs via `gh`

### What requires developer assistance

- Repository/org settings that require elevated permissions or web UI access (rulesets, branch protection, security settings)
- Organization-level policy decisions

### Debug mode

- `bash -x scripts/install-commands.sh` for command-install script tracing
- `pre-commit run --all-files --verbose` for hook diagnostics
- `NIX_DEBUG=1 nix flake check` for Nix diagnostics

## Project-Specific Notes

- `scripts/install-commands.sh` creates symlinks; it does not copy command files.
- Changes in `commands/` affect agent behavior across projects that consume these command specs.
- Keep temporary files in `.tmp/` with unique names.
