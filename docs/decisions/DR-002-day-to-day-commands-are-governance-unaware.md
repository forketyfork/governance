# DR-002: Day-to-day commands are governance-unaware

**Status:** Accepted
**Date:** 2025 (inferred — verify with maintainer)

## Decision

Commands like `/bug`, `/feature`, `/implement`, `/ship`, `/review`, and `/address` never reference governance-repository documents or federation terminology. They rely only on the target repository's local `CLAUDE.md` and `docs/`.

## Context

When an agent runs in a target repository, it should not need access to the governance repository. Commands must be self-contained given the target repository's local documentation. This also prevents coupling between the governance framework and individual repositories.

## Alternatives considered

### 1. Fetch governance docs at runtime

Rejected because it creates a runtime dependency on the governance repository and requires network access.

### 2. Inline governance rules into each day-to-day command

Rejected because it duplicates information and creates a maintenance burden when governance rules change.
