# DR-006: Single-file agent instructions with symlink alias

**Status:** Accepted
**Date:** 2025 (inferred — verify with maintainer)

## Decision

Each project maintains `CLAUDE.md` as the canonical agent instructions file and keeps `AGENTS.md` as a symlink to it.

## Context

Different AI tools look for different filenames (`CLAUDE.md` for Claude Code, `AGENTS.md` for other tools). A symlink ensures both tools find the same content without duplication or drift.

## Alternatives considered

### 1. Maintain two separate files

Rejected because content would inevitably diverge.

### 2. Use only one filename

Rejected because it would break compatibility with tools that expect the other filename.
