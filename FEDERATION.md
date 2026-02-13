# The Federation

| Land       | Stack          | GitHub                                                              | PRD | ARCH | TRACE | CONV | Lint | CI  | Coverage | Pre-commit | Branch Prot. | Observability | Status  |
| ---------- | -------------- | ------------------------------------------------------------------- | --- | ---- | ----- | ---- | ---- | --- | -------- | ---------- | ------------ | ------------- | ------- |
| governance | Markdown, Bash | [forketyfork/governance](https://github.com/forketyfork/governance) | ✓   | ✗    | —     | ✗    | ✓    | ✓   | —        | ✓          | ✓            | ✗             | Partial |

**Column legend:**

- **PRD / ARCH / TRACE / CONV:** docs/PRD.md, docs/ARCHITECTURE.md, docs/TRACEABILITY.md, docs/CONVENTIONS.md
- **Lint / CI / Coverage / Pre-commit / Branch Prot.:** Automated guardrails
- **Observability:** CLAUDE.md includes an Observability section per the constitution
- **Status:** `Governed` (all checks pass) / `Partial` (some guardrails in place) / `Legacy` (ungoverned) / `Archived` (no longer maintained)

Mark each cell: ✓ (done), ◐ (partial), ✗ (missing), — (not applicable)

## Dependency map

This table tracks which Lands consume external contracts from other Lands. When a PR modifies a contract listed here, all consuming Lands must be assessed for impact before merging (see Cross-Land Impact in CONSTITUTION.md).

| Source Land | Contract | Type | Consuming Land |
| ----------- | -------- | ---- | -------------- |

**Column legend:**

- **Source Land:** the Land that owns and publishes the contract
- **Contract:** identifier for the contract (e.g., `POST /api/v1/users`, `events.user.created` schema, `libshared/auth` module)
- **Type:** `API`, `schema`, `library`, `file format`, or `protocol`
- **Consuming Land:** the Land that depends on this contract

When admitting a new Land, populate this table with any known cross-Land dependencies. Update it whenever a new dependency is introduced or an existing one is removed.
