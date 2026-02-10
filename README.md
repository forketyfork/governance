# Governance

Federated governance framework for AI-assisted software projects.

## What This Is

When a single developer maintains 10+ projects where AI agents write most of the code, things rot silently. This repository defines the shared governance model — the constitution, standard documents, guardrails, agent commands, and admittance process — that all governed projects (called Lands) must follow.

The core idea: standardized documentation, mandatory automated checks, structured workflows, and human checkpoints at every boundary. The developer steers architecture and reviews boundaries; the agents write code within constraints defined here.

## Quick Start

### Install Agent Commands

The `install-commands.sh` script symlinks command specifications to your Claude Code and Codex configuration directories:

```bash
./scripts/install-commands.sh
```

Changes to files in `commands/` take effect immediately across all tools that consumed the symlinks.

### Set Up Development Environment

With [direnv](https://direnv.net/) (recommended):

```bash
direnv allow
```

Or manually:

```bash
nix develop
```

This enters a Nix dev shell with all tools on PATH and pre-commit hooks installed automatically. On every commit, hooks check markdown lint, markdown formatting, shell lint, and shell formatting.

## Repository Structure

```text
governance/
├── CONSTITUTION.md             # Principles, guardrails, workflows
├── FEDERATION.md               # Registry of governed Lands
├── ADMITTANCE.md               # How to admit a new Land
├── CLAUDE.md                   # Agent instructions for this repo
├── README.md                   # This file
├── commands/                   # Agent command specifications
│   ├── address.md
│   ├── architecture.md
│   ├── bug.md
│   ├── feature.md
│   ├── implement.md
│   ├── knowledge.md
│   ├── learn.md
│   ├── prd.md
│   ├── review.md
│   ├── ship.md
│   ├── tech.md
│   └── traceability.md
├── templates/                  # Templates for bootstrapping new Lands
│   ├── CLAUDE.md.template
│   └── CONVENTIONS.md.template
├── scripts/
│   └── install-commands.sh
├── docs/                       # Standard docs directory (empty, for future use)
├── .github/workflows/ci.yml   # CI pipeline
├── flake.nix                   # Nix flake (toolchain + git hooks)
├── flake.lock
├── .envrc                      # direnv config
├── .editorconfig
├── .markdownlint-cli2.jsonc
└── .prettierrc
```

## How It Works

### The Constitution

[CONSTITUTION.md](CONSTITUTION.md) defines the principles, standard documents, guardrails, and agent commands that every Land must follow.

### Standard Documents

Every Land maintains these in a `docs/` directory:

- **PRD.md** — what the software does, for whom, and why
- **ARCHITECTURE.md** — how the software is built
- **CONVENTIONS.md** — coding patterns for the specific project
- **TRACEABILITY.md** — maps PRD features to test files

### Agent Commands

The `commands/` directory contains specifications for agent commands that structure the development workflow. Documentation commands (`/prd`, `/architecture`, `/traceability`) create and maintain the standard documents. Workflow commands (`/bug`, `/feature`, `/tech`, `/implement`, `/ship`, `/review`, `/address`) handle the full cycle from planning to shipping.

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

## Adding a New Project

See [ADMITTANCE.md](ADMITTANCE.md) for the step-by-step process to bring a project under governance.

## Linting and Formatting

Run all checks at once:

```bash
pre-commit run --all-files
```

Or run individual tools (inside the dev shell):

```bash
markdownlint-cli2 '**/*.md'
prettier --check '**/*.md' '**/*.md.template'
shellcheck scripts/*.sh
shfmt -d scripts/*.sh
```
