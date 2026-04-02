# DR-008: Codex skills materialized from command specs

**Status:** Accepted
**Date:** 2026-04-02

## Decision

Codex workflows are installed as real skill directories under
`~/.agents/skills/`. `install-commands.sh` writes each installed `SKILL.md`
from the canonical `commands/<name>.md` file and then adds any Codex-specific
metadata or support files from `.agents/skills/<name>/`.

Claude Code continues to consume `commands/*.md` via symlinks in
`~/.claude/commands/`.

## Context

Codex prompt files under `~/.codex/prompts/` are no longer the preferred
workflow distribution mechanism. Codex skills require directory-based structure
with `SKILL.md`, while this repository already uses `commands/*.md` as the
canonical workflow specification format and still needs to support Claude
Code's command installation model.

The original migration approach used symlinked skill directories and symlinked
`SKILL.md` files. Codex follows symlinked skill directories, but it does not
discover symlinked `SKILL.md` files. That makes a repo-local `SKILL.md`
symlink an unreliable installation strategy even though it keeps one apparent
source of truth.

Materializing `SKILL.md` at install time preserves `commands/*.md` as the
source of truth while producing a layout Codex reliably loads.

## Consequences

- `commands/*.md` remains the single source of truth for workflow instructions.
- Codex-specific metadata can evolve independently in
  `.agents/skills/<name>/agents/openai.yaml`.
- `install-commands.sh` must manage two output formats: Claude command files and
  materialized Codex skill directories.
- On the same filesystem, the installer can hard-link files so command-body
  edits propagate to the installed Codex skills without another copy step.
- On different filesystems, the installer falls back to copying files, so the
  installer must be rerun after changes.
- Legacy symlinks in `~/.codex/prompts/` can be cleaned up safely when they are
  known to have been created by this repository.

## Alternatives considered

### 1. Duplicate every workflow into separate Claude and Codex files

Rejected because it creates drift risk and doubles maintenance cost.

### 2. Keep symlinked `SKILL.md` files inside checked-in skill folders

Rejected because Codex does not discover symlinked `SKILL.md` files.

### 3. Package the workflows as a Codex plugin immediately

Rejected for now because the existing symlink-based installation model already
fits the repository's workflow, and moving to plugins would add packaging and
distribution complexity beyond the current migration.
