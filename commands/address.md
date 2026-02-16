---
description: "Address the PR review and issue comments"
---

Review the **unresolved** review and issue comments on this PR against the PR description and our session context.

Use the APIs or CLIs declared in the project's CLAUDE.md:

- Source code hosting: fetch unresolved PR review threads
- Issue tracker: fetch unresolved issue comments linked to this PR per the project's issue/PR linkage convention

Only consider unresolved threads/comments.

For each comment:

1. Classify: WILL_FIX | WON'T_FIX | NEEDS_CLARIFICATION (yellow)
2. For WON'T_FIX: explain your reasoning
3. For WILL_FIX: describe the intended change

Present this summary and wait for my approval before making any changes.

## Example

Comment 1 — <comment summary in 5 words or less> (<commenter's name>)

<comment summary in more detail>

🟢 WILL_FIX — <how exactly you'll fix it>

Comment 2 — <same as above>

<comment summary in more detail>

## 🔴 WON'T_FIX — <explanation>

When replying to review or issue comments:

- Never edit or PATCH the original review comment body.
- Always post a new reply using the correct system declared in CLAUDE.md: source code hosting for PR review comments, issue tracker for issue comments.
- To avoid shell expansion issues with backticks or special characters, write the reply body to a temp file and pass it by reference.
- If a mistaken edit already happened, leave it and add a new reply noting the fix.

After I approve:

- Implement the approved fixes
- Commit with message referencing the addressed comments
- Push the changes
- Draft responses for each comment (don't post them — show me first)
- Use the **humanizer** skill on each reply draft before presenting it
- The comment should be concise and explain what was done to fix the issue or why it won't be fixed; no "good catch" or "thanks for pointing that out" phrases.
