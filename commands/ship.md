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
- Use the **humanizer** skill on the commit message before committing
- Commit using Conventional Commits. The header format is `<type>[optional scope]: <description>`, where type is one of: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `build`, or `ci`. The scope is optional and indicates the affected component. The description should be concise, in imperative mood, and not end with a period.
- The commit body should explain what problem is being solved, the reasoning behind the approach, and how the solution works. Do not list modified files or describe individual changes — those are visible from the diff. Use this structure:

  ```text
  <type>[optional scope]: <description>

  Issue: <summarize user prompts received during this session into a concise description of the issue>
  Solution: <what was done and why, 2-5 lines>
  ```

- Use the **humanizer** skill on the PR body before creating the PR
- Write the PR body to `.tmp/pr-body-$RANDOM.md` (use a unique filename), then create the PR **as a draft** (or the hosting platform's equivalent draft/WIP state) using the pull request CLI or API for the source code hosting declared in the project's CLAUDE.md:
  - Title matching the commit's short description; include the issue number suffix for issue-driven work (e.g., `<description> (#<number>)`), and omit it only for hotfix fast-path work where no issue exists yet
  - Body containing the Solution section expanded with context for reviewers
  - Where supported by the hosting platform, include an auto-close keyword in the body (e.g., "Fixes #<number>") only when an issue exists; for hotfix fast-path work, omit auto-close and note that issue linkage will be added during mandatory cleanup

Show me the PR link when done.
