# DR-003: Nix-based reproducible toolchain

**Status:** Accepted
**Date:** 2025 (inferred — verify with maintainer)

## Decision

Use a Nix flake to provide the development environment, pre-commit hooks, and all linting and formatting tools.

## Context

The repository needs consistent tooling across developer machines and CI. Nix provides hermetic, reproducible environments. The `git-hooks.nix` flake input generates pre-commit configuration automatically, and the same hooks run in CI via `nix flake check`.

## Alternatives considered

### 1. npm and Node.js toolchain

Rejected because this is not a JavaScript project, and adding a Node runtime for Markdown tooling adds unnecessary complexity.

### 2. Manual tool installation with version pinning

Rejected because it relies on developers maintaining consistent tool versions, which is exactly the kind of drift governance aims to prevent.
