# DR-004: Symlink-based command distribution

**Status:** Superseded by DR-008
**Date:** 2026-02-16

## Decision

`install-commands.sh` creates symlinks from `commands/*.md` to agent tool directories (`~/.claude/commands/`, `~/.codex/prompts/`) rather than copying files.

This decision remains in force for Claude Code. Codex prompt installation was
superseded when Codex moved from prompt files to skill folders.

## Context

When command specs are edited in the governance repository, changes must propagate immediately to all tools without re-running an install step. Symlinks achieve this automatically.

## Alternatives considered

### 1. File copying with a watcher

Rejected because it requires a running process and adds complexity.

### 2. Git submodules in each target repository

Rejected because it couples each repository to governance history and requires submodule update discipline.
