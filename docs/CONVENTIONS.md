# Conventions

## Naming

### Files and Directories

- `[auto: ls-lint]` Command specs: `kebab-case.md` in `commands/`
- `[auto: ls-lint]` Templates: `UPPER_CASE.md.template` or
  `PascalCase.md.template` in `templates/`
- `[auto: ls-lint]` Shell scripts: `kebab-case.sh` in `scripts/`
- `[auto: ls-lint]` Governance documents: `UPPER_CASE.md` at repository root
- `[auto: ls-lint]` Standard docs: `UPPER_CASE.md` in `docs/`

### Markdown Headings

- `[auto: markdownlint MD003]` ATX-style headings only (`## Heading`, not
  underline style)
- `[review]` Use sentence case for headings, not title case

## Markdown Formatting

- `[auto: markdownlint MD040]` Fenced code blocks must specify a language tag
  (`text` for ASCII diagrams, `bash` for shell, `mermaid` for diagrams)
- `[auto: markdownlint MD060]` Tables must be pipe-aligned
- `[auto: Prettier]` Prose wrap: preserve (Prettier does not reflow paragraphs)
- `[auto: Prettier]` Print width: 100 characters
- `[auto: EditorConfig]` Indent: 2 spaces
- `[auto: EditorConfig]` Files end with a newline

## Shell Script Patterns

- `[auto: check-conventions]` Start every script with `#!/usr/bin/env bash` and
  `set -euo pipefail`
- `[auto: EditorConfig + shfmt]` Indent with tabs
- `[auto: ShellCheck]` Pass ShellCheck with no warnings
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

- `[auto: check-conventions]` Day-to-day commands (`bug`, `feature`, `tech`,
  `implement`, `ship`, `review`, `address`) never reference
  governance-repository documents (`CONSTITUTION.md`, `FEDERATION.md`,
  `ADMITTANCE.md`) or use federation terminology like "Land"
- `[review]` Day-to-day commands reference the target project's `CLAUDE.md` and
  `docs/` files for infrastructure, tooling, and conventions
- `[review]` Platform-specific CLI commands belong in reference files
  (`managing-github.md`, `managing-youtrack.md`), not in command specs
- `[auto: check-conventions]` Keep command specs concise — most are 50-90 lines,
  hard ceiling of 150 (reference files like `managing-*.md` are exempt)

## Governance Documents

- `[review]` `CONSTITUTION.md`, `FEDERATION.md`, and `ADMITTANCE.md` require
  explicit user approval before modification
- `[auto: check-conventions]` `CLAUDE.md` is the canonical agent instructions
  file; `AGENTS.md` is always a symlink to it — never a separate file
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
