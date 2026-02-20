---
description: "Preparing and shipping code changes"
---

Prepare to ship the current work:

`/ship` handles packaging and publishing existing changes (branch, commit, push, draft PR). It does not implement new code.

1. Read the uncommitted files
2. Provide a summary of the changes to commit based on the current work session (if there are changes not related to your work, mention them separately)
3. Wait for my confirmation before proceeding

After confirmation:

- If on main/master: create branch named `<type>/<short-description>` (e.g., `fix/null-pointer-auth`, `feat/user-export`)
- Stage only files relevant to this task, unless I instruct otherwise
- Apply the **humanizer** skill to the commit message internally — do not output the humanized text or pause for confirmation, just use the result as the commit message and continue
- Commit using Conventional Commits. The header format is `<type>[optional scope]: <description>`, where type is one of: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `build`, or `ci`. The scope is optional and indicates the affected component. The description should be concise, in imperative mood, and not end with a period.
- The commit body should explain what problem is being solved, the reasoning behind the approach, and how the solution works. Do not list modified files or describe individual changes — those are visible from the diff. Use this structure:

  ```text
  <type>[optional scope]: <description>

  Issue: <summarize user prompts received during this session into a concise description of the issue>
  Solution: <what was done and why, 2-5 lines>
  ```

- Apply the **humanizer** skill to the PR body internally — do not output the humanized text or pause for confirmation, just use the result when creating the PR and continue
- Write the PR body to `.tmp/pr-body-$RANDOM.md` (use a unique filename), then create the PR **as a draft** (or the hosting platform's equivalent draft/WIP state) using the pull request CLI or API for the source code hosting declared in the project's CLAUDE.md:
  - If a PR already exists for the branch, **adjust** its title/body if needed to incorporate the new changes while preserving existing context. Do **not** overwrite the title/body with only the current session's text.
  - Title matching the commit's short description, plus any issue-linkage markers required by the project's documented issue/PR linkage convention in CLAUDE.md
  - Body containing:
    - The Solution section expanded with context for reviewers, plus the issue-linkage fields/keywords/URLs required by CLAUDE.md
    - A **Test plan** section with a checklist of manual verification steps the reviewer should perform. Only include steps that require human judgment or interaction — exclude anything already verified by automated tests, linters, type checkers, or CI. If the change is fully covered by automation, omit this section entirely.
  - For hotfix fast-path work where no issue exists yet, omit issue linkage and note that linkage will be added during mandatory cleanup

Show me the PR link when done.
