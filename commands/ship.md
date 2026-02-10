---
description: "Preparing and shipping code changes"
---

Prepare to ship the current work:

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
- Write the PR body to `.tmp/pr-body.md`, then create the PR using `gh pr create --body-file .tmp/pr-body.md`:
  - Title matching the commit's short description
  - Body containing the Solution section expanded with context for reviewers
  - Link to relevant issues if mentioned in session

Show me the PR link when done.
