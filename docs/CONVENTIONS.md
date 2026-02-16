# Conventions

## Naming

### Files and Directories

- `[auto]` Command specs: `kebab-case.md` in `commands/`
- `[auto]` Templates: `PascalCase.md.template` in `templates/`
- `[auto]` Shell scripts: `kebab-case.sh` in `scripts/`
- `[review]` Governance documents: `UPPER_CASE.md` at repository root
- `[review]` Standard docs: `UPPER_CASE.md` in `docs/`

### Markdown Headings

- `[auto]` ATX-style headings only (`## Heading`, not underline style)
- `[review]` Use sentence case for headings, not title case

## Markdown Formatting

- `[auto]` Fenced code blocks must specify a language tag (`text` for
  ASCII diagrams, `bash` for shell, `mermaid` for diagrams)
- `[auto]` Tables must be pipe-aligned (enforced by markdownlint MD060)
- `[auto]` Prose wrap: preserve (Prettier does not reflow paragraphs)
- `[auto]` Print width: 100 characters (Prettier)
- `[auto]` Indent: 2 spaces (EditorConfig)
- `[auto]` Files end with a newline (EditorConfig)

## Shell Script Patterns

- `[auto]` Start every script with `#!/usr/bin/env bash` and `set -euo pipefail`
- `[auto]` Indent with tabs (EditorConfig + shfmt)
- `[auto]` Pass ShellCheck with no warnings
- `[review]` Quote all variable expansions: `"${VAR}"`, not `$VAR`
- `[review]` Use `"$(command)"` for command substitution, not backticks

## Command Specification Structure

### Format

- `[review]` Each command spec is a single Markdown file in `commands/`
- `[review]` The file begins with either:
  - A YAML frontmatter block (`---` / `description:` / `---`) for commands
    registered as agent skills (e.g., `ship.md`, `address.md`, `learn.md`,
    `knowledge.md`)
  - A direct mode/role declaration (e.g., "You are in BUG TRIAGE mode.") for
    commands loaded as slash commands
- `[review]` Standard sections appear in this order (omit sections that do not
  apply):
  1. Mode/role declaration
  2. Setup — what to read before acting
  3. Procedure or interview structure
  4. Output format
  5. Rules and constraints

### Content Rules

- `[review]` Day-to-day commands (`bug`, `feature`, `tech`, `implement`, `ship`,
  `review`, `address`) never reference governance-repository documents
  (`CONSTITUTION.md`, `FEDERATION.md`, `ADMITTANCE.md`) or use federation
  terminology like "Land"
- `[review]` Day-to-day commands reference the target project's `CLAUDE.md` and
  `docs/` files for infrastructure, tooling, and conventions
- `[review]` Platform-specific CLI commands belong in reference files
  (`managing-github.md`, `managing-youtrack.md`), not in command specs
- `[review]` Keep command specs concise — most are 50-90 lines

## Governance Documents

- `[review]` `CONSTITUTION.md`, `FEDERATION.md`, and `ADMITTANCE.md` require
  explicit user approval before modification
- `[review]` `CLAUDE.md` is the canonical agent instructions file; `AGENTS.md` is
  always a symlink to it — never a separate file
- `[review]` When adding a new feature to the governance framework, update
  `docs/PRD.md` with the feature entry and success criteria

## Nix Configuration

- `[review]` All linting and formatting tools are declared in `flake.nix` and
  exposed through the dev shell
- `[review]` Pre-commit hooks are managed via the `git-hooks.nix` flake input,
  not installed manually
- `[review]` Adding a new check means adding a hook in `flake.nix` — the CI
  pipeline (`nix flake check`) picks it up automatically

## External Contract Boundaries

These file patterns indicate external contracts consumed by other Lands.
Changes to these files require cross-Land impact assessment during `/review`.

- `commands/*.md` — agent command specifications (`command` contract type).
  Consumed by all governed Lands via symlinks. Changes affect agent behavior
  across the federation.
- `templates/*.md.template` — project bootstrapping templates (`file format`
  contract type). Consumed during Land admittance. Changes affect the starting
  structure of new Lands.
