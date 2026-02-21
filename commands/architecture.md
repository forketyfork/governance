---
name: architecture
description: "Create or update the architecture documentation"
disable-model-invocation: true
---

You are in ARCHITECTURE DOCUMENTATION mode.

Your job: create or update docs/ARCHITECTURE.md for this project. Read the entire codebase first, then produce or revise the document.

## Procedure

1. Read CLAUDE.md (or AGENTS.md) and all existing docs/ files.
2. Read the entire codebase: directory structure, all source files, build configuration, dependency manifests, CI config.
3. If docs/ARCHITECTURE.md already exists:
   - Treat it as a draft to be verified and improved, not as ground truth.
   - Check every claim against the actual code. Flag and fix anything that's wrong.
   - Add missing sections. Remove outdated information.
   - Preserve existing ADRs but verify their accuracy. Update dates and "alternatives considered" if the code has evolved.
4. If docs/ARCHITECTURE.md does not exist, create it from scratch.

## Document Structure

Produce the document with these exact sections in this order. If a section would be empty or trivial for this project, omit it.

### System Overview

One paragraph. Architecture style, key technologies, threading/concurrency model, main patterns used. This is the "explain it to a new team member in 30 seconds" paragraph.

### System Context (include only if this service communicates with external systems)

Mermaid diagram with this service in the center and all external systems it communicates with: upstream callers, downstream dependencies, databases, message queues, third-party APIs, other internal services. For each arrow, label with: protocol (HTTP, gRPC, WebSocket, Unix socket, etc.), direction (inbound/outbound/bidirectional), and a one-line description of what data flows. Example label: "REST / inbound / submits orders"

### Inter-Service Flows (include only if System Context section exists)

For each significant flow that crosses a service boundary, provide a Mermaid sequence diagram or numbered step list showing: who initiates, what this service receives (protocol, payload shape), what it does internally (reference modules), what it calls downstream, and what it returns. For each flow, note:

- Sync/Async: does the caller block?
- Failure mode: what happens when a dependency is unavailable?
- Retry/fallback: is there retry logic, circuit breaking, or graceful degradation?

### Service Contract Summary (include only if System Context section exists)

Table with columns: Direction (inbound/outbound/bidirectional), Counterpart, Protocol, Endpoint/Topic/Socket, Payload (brief), Auth, Owner (team, if known).

### Cross-Project Dependencies (include only if this project consumes contracts from other related projects)

Table listing external contracts this project depends on from other related projects. Columns: Source Project, Contract (identifier such as endpoint, schema, module), Type (`API`, `schema`, `library`, `file format`, or `protocol`), Description (what this project uses it for). This section is the authoritative record of external contracts consumed by this project and is consulted during cross-project impact assessment.

### Component Diagram

Mermaid diagram showing LAYERS, not individual files. Group related files into labeled subgraphs. Target 10-20 boxes maximum. Each box: module/file name + one-line italic responsibility description. Show dependency arrows between groups. If the diagram would exceed 20 boxes, you are showing too much detail — collapse further.

### Dependency Rules

State the dependency direction invariant: which layers may depend on which. List exceptions. Include a simple ASCII tree showing the layer hierarchy. State invariants as testable rules, e.g., "Module X never imports from module Y."

### Rules for New Code

3-6 mandatory patterns that any new code must follow. Each rule: one sentence stating what to do, one sentence stating what NOT to do, and a reference to the ADR that explains why. These are extracted from the ADRs — not new inventions. They exist so the implementing agent doesn't have to read all ADRs to know the critical rules.

### Where to Put New Code

Table: "I need to..." → "Put it in..." — covering the most common types of changes for this project. Include at minimum: new UI element, new endpoint/command, new data model, new config option, new test, new external integration.

### Data Flow

ASCII or Mermaid diagrams for each major data path within this service. At minimum: the main loop or request lifecycle, primary input path, primary output path. Add additional paths for async/event-driven flows. After the diagrams, include tables for:

- Entry Points (how data gets in)
- Storage (where state lives)
- Exit Points (how data gets out)

### Module Boundary Table

One row per architectural module, NOT per file. Group closely related files into single rows. Target 10-20 rows. Columns: Module, Responsibility, Public API (key functions/types), Dependencies.

Collapse rules:

- If a group of files all implement the same interface/pattern (e.g., UI components, API handlers, repository classes), they get ONE row.
- If a module has fewer than 3 public functions and no independent consumers, fold it into its parent module's row.
- Helper/utility files that only serve one module go into that module's row.

### Key Architectural Decisions

ADR format for every non-obvious decision. Each ADR:

- Decision: what was decided
- Context: why this decision was needed
- Alternatives considered: at least 2 alternatives, each with a reason for rejection
- Date: when (approximate is fine)

Include ADRs for: architecture style, key dependency choices (frameworks, libraries, databases), communication/concurrency patterns, caching/performance strategies, configuration approach, security decisions, and any pattern that a contributor would get wrong without documentation.

## Quality Checks

Before presenting the document, verify:

1. Every module in the Module Boundary Table actually exists in the codebase.
2. Every dependency arrow in the Component Diagram corresponds to actual imports in the code.
3. The Dependency Rules are not violated by the actual code. If they are, document the violation as an exception or flag it as tech debt.
4. No file appears in more than one row of the Module Boundary Table.
5. The Component Diagram has 20 or fewer boxes. If not, collapse further.
6. The Module Boundary Table has 20 or fewer rows. If not, collapse further.

## Uncertainty

If you are unsure about a decision's rationale, state your best inference and mark it with "(inferred — verify with maintainer)". Do not invent rationale. Do not omit decisions just because you're unsure of the "why."

## Output

Write the complete docs/ARCHITECTURE.md file. If updating an existing file, present a summary of changes first: what was added, what was corrected, what was removed.

## Rules

- This document is read by AI coding agents before implementing changes. Optimize for that reader.
- Prefer concrete, testable rules over vague principles like "keep it simple" or "follow best practices."
- Do not pad. If a section adds no information, omit it.
- Do not list every file. The Module Boundary Table and Component Diagram must stay at the architectural level, not the file level.
- Do not invent patterns that don't exist in the code. Document what IS, not what should be.
- If the codebase violates its own patterns, document the violation honestly rather than pretending consistency.
