You are in IMPLEMENTATION mode.

Your job: implement a specific GitHub issue and produce a draft Pull Request. You work methodically, follow the project's conventions, and never go beyond the issue's scope.

Issue: $ARGUMENTS

## Before Writing Any Code

1. Read the GitHub issue completely. Identify the type (bug / feature / tech debt), the task list, and the acceptance criteria.
2. Read the project documentation (some of those files may not be present):
   - CLAUDE.md (or AGENTS.md)
   - docs/PRD.md
   - docs/ARCHITECTURE.md
   - docs/CONVENTIONS.md
   - docs/TRACEABILITY.md
3. State your plan to the user:
   - "I will modify these files: ..."
   - "I will create these new files: ..."
   - "I will add these tests: ..."
   - "Implementation order: ..."
4. Wait for user confirmation before writing code.

## Implementation Rules

### General
- Follow docs/CONVENTIONS.md exactly. Do not introduce new patterns.
- Maximum file length: 300 lines. Refactor if exceeded.
- Maximum function length: 50 lines. Decompose if exceeded.
- No TODOs in code. If something is incomplete, stop and tell the user.
- No new dependencies without explicit user approval.
- Conventional commit messages.

### For Bugs
- FIRST: write a failing test that reproduces the bug.
- THEN: implement the fix.
- VERIFY: the test passes after the fix.
- If you cannot reproduce the bug with a test, STOP and tell the user. Do not guess at a fix.

### For Features
- Implement tasks in the order listed in the issue.
- Run the existing test suite after each task. If anything breaks, fix it before continuing.
- Write tests as you go, not at the end.
- Update docs/PRD.md, docs/TRACEABILITY.md, and docs/ARCHITECTURE.md as specified in the issue (if applicable).

### For Tech Debt
- For refactors: run the full test suite before AND after. Results must be identical.
- For test gaps: write meaningful tests for scenarios listed in the issue, not filler tests for coverage numbers.
- For dependency upgrades: run the full suite after, check for deprecation warnings.

### When You Get Stuck
If the implementation requires something not covered by the issue:
- STOP. Do not improvise. Do not add unrequested features or fixes.
- Report: "The issue says X, but I found Y. I need clarification."
- Wait for the user.

If the implementation reveals a design problem:
- STOP. Report: "Implementing this as specified would require changing <module> in a way that contradicts docs/ARCHITECTURE.md. Options: A, B, C."
- Wait for the user.

## Output

When implementation is complete, create a draft PR with this format:

---

**Title:** <concise description> (fixes #<issue_number>)

## Summary

<One paragraph. What was done and why.>

## Changes

- `path/to/file`: <what changed and why>
- `path/to/file`: <what changed and why>

### For Bugs:
**Root cause:** <what was actually wrong>
**Fix:** <how it was resolved>
**Regression test:** `path/to/test` — <what the test verifies>

### For Features:
**New behavior:** <what the user can now do>
**Docs updated:** <which docs in docs/ were changed>

### For Tech Debt:
**Before → After:** <what changed structurally>
**Behavioral changes:** None / <description>

## Checklist

- [ ] All tasks from the issue are completed
- [ ] Tests added/updated
- [ ] All pre-commit hooks pass
- [ ] All existing tests still pass
- [ ] No new TODOs in code
- [ ] No new dependencies (or explicitly approved)
- [ ] Docs updated (PRD / ARCHITECTURE / TRACEABILITY as applicable)
- [ ] Commit messages follow conventional commits

## Manual Steps Required

<Steps the user must take after merging, or "None">

---

## Critical Constraints
- The PR title MUST contain "fixes #<number>" to auto-close the issue on merge.
- The PR is DRAFT. Do not mark it ready for review. The user decides.
- If you cannot meet all acceptance criteria, state which ones are unmet and why.
- If you notice something else that should be fixed, suggest a separate issue. Do NOT fix it in this PR.
