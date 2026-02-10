You are in PRD DOCUMENTATION mode.

Your job: create or update docs/PRD.md for this project by reverse-engineering the product from the codebase and interviewing the user for intent.

## Procedure

1. Read CLAUDE.md (or AGENTS.md) and all existing docs/ files.
2. Read the entire codebase: source files, tests, config, README, any existing documentation.
3. If docs/PRD.md already exists:
   - Verify every listed feature actually exists in the code.
   - Flag features listed in the PRD that have no corresponding implementation.
   - Flag implemented features missing from the PRD.
   - Check non-goals: are any of them actually implemented? If so, flag the contradiction.
   - Update and present the revised document.
4. If docs/PRD.md does not exist:
   - Reverse-engineer the feature list from the code.
   - Present a draft to the user.
5. After producing the draft, ask the user:
   - "Are there features I missed?"
   - "Are there features listed here that you consider incomplete or experimental?"
   - "What are the non-goals — things this project should explicitly NOT do?"

## Document Structure

### Problem Statement
One paragraph. What does this project solve and for whom? This is the "why does this exist" paragraph. If you can't infer this clearly from the code, ask the user.

### Core Features
Numbered list. Each feature:
- **F{N}: {Feature Name}** — One sentence description of what the user can do.
- No feature exists in this document unless it's implemented in code (or explicitly marked as "Planned").

### Non-Goals
Bulleted list of things this project explicitly does NOT do. Critical for preventing scope creep during vibecoding. If you can't infer these, ask the user.

### User Flows
For each core feature, a numbered sequence:
1. What the user does
2. What happens in response
3. End state

Keep these at the user-interaction level, not the code level. "User clicks X, system shows Y" — not "function Z calls function W."

### Success Criteria
For each core feature, one or more concrete, testable criteria. These become the basis for acceptance tests. Format:
- **F{N}:** <criterion>

## Quality Checks

Before presenting the document, verify:
1. Every feature in "Core Features" has a corresponding "User Flow" and "Success Criteria" entry.
2. Every feature maps to actual code. If you find code that implements something not in the feature list, either add it or ask the user if it's intentional.
3. Non-goals do not contradict implemented features.

## Output

Write the complete docs/PRD.md file. If updating, present a summary of changes: features added, features removed, corrections made.

After presenting the document, always ask the user to review and correct it. The PRD is the one document where the user's intent matters more than what the code says — the code might be wrong.

## Rules
- This document is the source of truth for WHAT the software does. docs/ARCHITECTURE.md covers HOW.
- Do not include implementation details. No module names, no function names, no file paths.
- Do not list aspirational features unless the user explicitly says to include them as "Planned."
- If a feature is partially implemented, list it and mark it as "Partial — {what's missing}."
- Keep the language non-technical. A product manager should be able to read this.
- Feature numbering (F1, F2, ...) is stable — when updating, do not renumber existing features. Add new features at the end.
