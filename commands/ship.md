---
description: "Prreparing and shipping code changes"
---

Prepare to ship the current work:

1. Read the uncommitted files
2. Provide a summary of the changes to commit based on the current work session (if there are changes not related to your work, mention them separately)
3. Wait for my confirmation before proceeding

After confirmation:

- If on main/master: create branch named `<type>/<short-description>` (e.g., `fix/null-pointer-auth`, `feat/user-export`)
- Stage only files relevant to this task, unless I instruct otherwise
- Commit with this structure:

  ```
  <commit header, according to conventional commits>

  Issue: <summarize user prompts received during this session into a concise description of the issue>
  Solution: <what was done and why, 2-5 lines>
  ```

- Push and create a PR with:
  - Title matching the commit's short description
  - Body containing the Solution section expanded with context for reviewers
  - Link to relevant issues if mentioned in session

Show me the PR link when done.
