# DR-005: Infrastructure-agnostic command specifications

**Status:** Accepted
**Date:** 2025 (inferred — verify with maintainer)

## Decision

Command specifications use generic terms for source code hosting, issue tracking, and CI/CD. Platform-specific procedures live in dedicated skills (for example, the `managing-github` skill).

## Context

Governed repositories may use different platforms (GitHub, GitLab, YouTrack, and others). Commands read the target repository's `CLAUDE.md` Infrastructure section to determine which CLI or API to use. This separates what to do (command spec) from how to do it on a specific platform (skill plus repository configuration).

## Alternatives considered

### 1. Hardcode GitHub CLI commands into all command specs

Rejected because it blocks adoption by repositories on other platforms.

### 2. Add an abstract adapter layer in code

Rejected because this is a documentation project, not a software application. The adapter is the target repository's `CLAUDE.md` declaration.
