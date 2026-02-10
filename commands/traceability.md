You are in TRACEABILITY MATRIX mode.

Your job: create or update docs/TRACEABILITY.md by mapping features from docs/PRD.md to their corresponding tests.

## Procedure

1. Read docs/PRD.md. If it does not exist, STOP and tell the user: "There's no PRD to trace against. Run /prd first."
2. Read all test files in the project. Identify the test framework and test organization pattern.
3. For each feature in the PRD (F1, F2, ...), find tests that verify that feature's behavior.
4. If docs/TRACEABILITY.md already exists:
   - Verify all mappings: do the listed test files still exist? Do they still test what's claimed?
   - Add mappings for any new features.
   - Remove mappings for deleted features.
   - Update coverage status.
5. If docs/TRACEABILITY.md does not exist, create it from scratch.

## Document Structure

### Traceability Matrix

| Feature             | Test File(s)        | Scenarios Covered                                                | Status                      |
| ------------------- | ------------------- | ---------------------------------------------------------------- | --------------------------- |
| F1: {name from PRD} | `path/to/test_file` | {list of what's tested: happy path, error case, edge case, etc.} | Covered / Partial / Missing |
| F2: {name from PRD} | —                   | —                                                                | Missing                     |

### Coverage Gaps

For each feature with "Partial" or "Missing" status, explain:

- **F{N}: {name}** — What's missing: {specific scenarios that have no test coverage}. Priority: {high if the feature is user-facing and critical, medium if it's secondary, low if it's rarely used}.

### Test Organization Notes

Brief description of how tests are organized in this project, so the implementing agent knows where to add new tests:

- Test framework: {name and version}
- Test location: {directory pattern, e.g., `src/test/kotlin/` or `tests/` or colocated with source}
- Naming convention: {e.g., `test_*.py`, `*_test.zig`, `*Test.kt`}
- Run command: {e.g., `npm test`, `zig build test`, `./gradlew test`}

## Mapping Rules

When deciding if a test covers a feature:

- A test covers a feature if it exercises the feature's user-facing behavior as described in the PRD's User Flow and Success Criteria.
- A test that only exercises internal implementation details (private functions, internal state) does NOT count as feature coverage. It's a unit test, not a feature test.
- A test that exercises the feature but only covers the happy path is "Partial," not "Covered." "Covered" requires happy path + at least one error/edge case.
- Integration tests and end-to-end tests that exercise a feature count as coverage even if they don't test it in isolation.

## Quality Checks

Before presenting the document:

1. Every feature from the PRD has a row in the matrix. No exceptions.
2. Every test file referenced in the matrix actually exists.
3. "Covered" features have tests for both happy path and at least one error/edge case.
4. The Coverage Gaps section lists ALL Partial and Missing features with specific missing scenarios.

## Output

Write the complete docs/TRACEABILITY.md file. If updating, present a summary: new mappings added, stale mappings removed, status changes.

After presenting, highlight the top 3 highest-priority coverage gaps and suggest the user address them next (via /tech with type "test-gap").

## Rules

- This document maps features to tests, not code to tests. The unit of tracing is the PRD feature, not the source file.
- Do not inflate coverage. If you're unsure whether a test covers a feature, mark it "Partial" and explain your uncertainty in Coverage Gaps.
- Do not suggest writing tests in this mode. Just document what exists. The user can run /tech to create test-gap issues.
- Feature numbers (F1, F2, ...) must match docs/PRD.md exactly. If they don't match, the PRD was updated without updating traceability — flag this to the user.
- Keep this document low-maintenance: reference test files by path, not by individual test function names. Test functions change frequently; file paths are more stable.
