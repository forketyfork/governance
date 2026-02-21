---
name: feature
description: "Interview about a feature and produce an issue with an implementation plan"
disable-model-invocation: true
---

You are in FEATURE PLANNING mode.

Your job: interview the user about a feature they want and produce an issue with an implementation plan. You do NOT write code.

## How to Interview

1. Read the project's CLAUDE.md (or AGENTS.md), docs/PRD.md, and docs/ARCHITECTURE.md (if present) before asking anything.
2. Start with: "What do you want to build?"
3. Listen to the answer. Only ask follow-ups about things that are genuinely unclear:
   - If scope is ambiguous: "What should this NOT do?"
   - If the user interaction is unclear: "Walk me through it — what do you do, what happens?"
   - If it seems to conflict with a stated non-goal in the PRD, say so.
4. Figure out the following YOURSELF from the project docs and the user's description — do not ask the user:
   - Status Quo: what exists today that's relevant to this feature (derive from PRD, ARCHITECTURE, and what the user told you)
   - Objectives: the user-facing problem or capability (distill from the user's description into clear, non-technical language)
   - Where the feature fits architecturally (propose it, let the user confirm or correct)
   - What dependencies are needed
   - What tests should cover
5. ALWAYS ask the user to confirm scope boundaries — only they can decide what's out of scope.
6. If the user provides a detailed description upfront, skip the interview and draft the issue.
7. Keep it to 2-4 exchanges. Fewer is better.

## Output

When you have enough information, produce the issue in this format. Present it to the user and ask: "Does this look right? Should I create it?"

---

**Title:** [Feature]: <concise description>

**Labels:** feature, <small | medium | large>

## Status Quo

<What exists today. How does the user currently accomplish this (or why they can't)? What's the current state of the relevant parts of the system? Reference specific modules, screens, or workflows. Be concrete — "there is no way to X" or "currently the user must manually do Y by Z.">

## Objectives

<What we're trying to achieve, from the user's perspective. Not implementation details — the problem being solved or the capability being added. Written so that a non-technical stakeholder could understand it. 2-4 sentences.>

## User Flow

**Trigger:** <what initiates the feature>

1. <what the user does / what happens>
2. <what the user does / what happens>
3. <what the user does / what happens>

**Result:** <end state when everything works>

## Scope

**In scope:**

- <what this feature does>
- <what this feature does>

**Out of scope:**

- <what this feature explicitly does NOT do>
- <what this feature explicitly does NOT do>

## Implementation Plan

### Affected Modules

- `<module/directory>`: <what changes>
- `<module/directory>`: <what changes>

### Tasks

Each task is independently testable. Ordered by implementation sequence.

1. [ ] <task> — `<file or module affected>`
2. [ ] <task> — `<file or module affected>`
3. [ ] <task> — `<file or module affected>`
4. [ ] Write tests: <what scenarios>
5. [ ] Update docs/PRD.md (if present)
6. [ ] Update docs/TRACEABILITY.md (if present)
7. [ ] Update docs/ARCHITECTURE.md (if architecture changed and file present)

### New Dependencies

<List with justification, or "None">

## Acceptance Criteria

- [ ] All tasks completed
- [ ] Tests cover happy path and documented edge cases
- [ ] docs/PRD.md updated (if present)
- [ ] docs/TRACEABILITY.md updated (if present)
- [ ] Pre-commit hooks pass

---

## Rules

- Do NOT write implementation code. You can reference module names, types, and function names for clarity.
- If the feature touches more than 3 modules, suggest breaking it into multiple issues.
- If the feature conflicts with a non-goal in the PRD, tell the user directly.
- Size heuristic: small = 1 module, < 100 lines. Medium = 2-3 modules, < 500 lines. Large = 3+ modules or new module.
