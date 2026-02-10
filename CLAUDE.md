# CLAUDE.md

## Project

**Name:** Governance
**Description:** Federated governance framework for AI-assisted software projects. Defines the constitution, standard documents, guardrails, agent commands, and admittance process that all governed projects (Lands) must follow. This repository is the single source of truth for how AI agents work across the Federation.
**Stack:** Markdown, Bash (scripts)
**Status:** Active development

## Build & Run

```bash
# Install agent commands (symlinks command specs to ~/.claude/commands and ~/.codex/prompts)
./scripts/install-commands.sh

# Lint (Markdown)
npx markdownlint-cli2 '**/*.md'

# Format check (Markdown)
npx prettier --check '**/*.md' '**/*.md.template'

# Lint (Shell)
shellcheck scripts/*.sh

# Format check (Shell)
shfmt -d scripts/*.sh

# Run all checks at once
pre-commit run --all-files
```

There is no build or test step — this is a documentation-only repository.

## Governance

This repository IS the Federation's governance framework. The constitution is defined in [CONSTITUTION.md](CONSTITUTION.md).

## Repository Structure

```
governance/
├── CONSTITUTION.md             # Principles, guardrails, workflows
├── FEDERATION.md               # Registry of governed Lands
├── ADMITTANCE.md               # How to admit a new Land
├── CLAUDE.md                   # This file
├── README.md                   # Project overview
├── commands/                   # Agent command specs (symlinked by install-commands.sh)
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
├── docs/                       # Standard docs directory
├── .github/workflows/ci.yml   # CI pipeline
├── .editorconfig
├── .markdownlint-cli2.jsonc
├── .prettierrc
└── .pre-commit-config.yaml
```

## Agent Rules

1. Do not modify CONSTITUTION.md, FEDERATION.md, or ADMITTANCE.md without explicit user approval.
2. Command specifications in `commands/` follow the format expected by Claude Code and Codex. Preserve the existing structure when editing.
3. Templates in `templates/` use `[bracketed placeholders]` for values that each Land fills in. Keep placeholders generic.
4. Use conventional commit messages.
5. Do not introduce new files outside the existing directory structure without asking first.

## Project-Specific Notes

- The `install-commands.sh` script creates symlinks, not copies. Changes to files in `commands/` take effect immediately in all tools that consumed the symlinks.
- Quality is maintained through markdownlint, Prettier, ShellCheck, shfmt, pre-commit hooks, CI, and human review.
- When editing command specs, consider that they are used across all Lands in the Federation. Changes here affect every governed project.
