# DR-007: Conventional commit messages

**Status:** Accepted
**Date:** 2026-03-05

## Decision

All commits in governed repositories use the Conventional Commits format.

## Context

Governance workflows rely on consistent commit semantics across repositories and
agent sessions. Structured commit headers make history easier to scan, support
automation, and reduce ambiguity when tracing changes.

## Alternatives considered

### 1. Free-form commit messages

Rejected because message style drifts over time and weakens readability and
automation opportunities.

### 2. Repository-specific commit conventions

Rejected because differing formats increase cognitive load for cross-repository
work and reduce predictability for agent workflows.
