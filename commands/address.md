---
description: "Address the PR review and issue comments"
---

Review the **unresolved** review and issue comments on this PR against the PR description and our session context.

To get only unresolved review comments, use the GraphQL API to fetch review threads with their resolution state:
```
gh api graphql -f query='
{
  repository(owner: "<org>", name: "<repo>") {
    pullRequest(number: <pr>) {
      reviewThreads(first: 100) {
        nodes {
          isResolved
          comments(first: 1) {
            nodes {
              databaseId
              body
              author { login }
              path
            }
          }
        }
      }
    }
  }
}'
```
Only consider threads where `isResolved` is `false`. Also consider any unresolved issue comments.

For each comment:
1. Classify: WILL_FIX | WON'T_FIX | NEEDS_CLARIFICATION (yellow)
2. For WON'T_FIX: explain your reasoning
3. For WILL_FIX: describe the intended change

Present this summary and wait for my approval before making any changes.

Example:
---
Comment 1 — <comment summary in 5 words or less> (<commenter's name>)

<comment summary in more detail>

🟢 WILL_FIX — <how exactly you'll fix it>

Comment 2 — <same as above>

<comment summary in more detail>

🔴 WON'T_FIX — <explanation>
---

When replying to review or issue comments:
- Never edit or PATCH the original review comment body.
- For review comments, always post a new reply using `in_reply_to` with `gh api repos/<org>/<repo>/pulls/<pr>/comments --method POST --field in_reply_to=<comment_id> --field body="..."`.
- For issue comments, post a new comment with `gh api repos/<org>/<repo>/issues/<pr>/comments --method POST --field body="..."`.
- If a mistaken edit already happened, leave it and add a new reply noting the fix.

After I approve:
- Implement the approved fixes
- Commit with message referencing the addressed comments
- Push the changes
- Draft responses for each comment (don't post them — show me first)
- The comment should be concise and explain what was done to fix the issue or why it won't be fixed; no "good catch" or "thanks for pointing that out" phrases.
