# DR-001: Markdown-based command specifications

**Status:** Accepted
**Date:** 2026-02-16

## Decision

Agent commands are plain Markdown files that are symlinked into agent tool configuration directories.

## Context

Commands must be readable by multiple AI agent tools (Claude Code, Codex, Junie) and editable by both humans and agents. A code-based plugin system would tie commands to a specific tool.

## Alternatives considered

### 1. JSON or YAML configuration files

Rejected because they are harder to read and write for both humans and agents, and they lack the expressiveness needed for procedural instructions.

### 2. Tool-specific plugin formats

Rejected because each tool has its own format, and the governance framework must work across tools.
