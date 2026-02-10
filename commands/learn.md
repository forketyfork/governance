---
description: "Extract learnings from sessions to update CLAUDE.md"
---

Analyze this session to extract learnings for CLAUDE.md.

First, read the current CLAUDE.md and understand its structure.

Identify from this session:

1. **Blockers:** Where did you get stuck, retry, or need correction?
2. **Discoveries:** What non-obvious information was needed to succeed?
3. **Corrections:** What in CLAUDE.md was wrong or outdated?
4. **Missing context:** What project knowledge would have helped from the start?

For each item, draft an update:

- Blockers → Add to a "Known Pitfalls" or "Gotchas" section
- Discoveries → Add to relevant technical section (create if needed)
- Corrections → Edit in place, note what changed
- Missing context → Add to "Project Setup" or "Architecture" section

Abstraction test: Before adding anything, ask "Would this help on a _different_ task in this project?" If no, it's too specific — generalize or skip.

Output a diff preview:

```
# Proposed CLAUDE.md Changes
## Added to [Section Name]
+ <new content>
## Modified in [Section Name]
- <old content>
+ <new content>
## Removed
- <outdated content>
Reason: <why>
## Structural changes
<description if sections were moved/merged>
```

Wait for my approval before applying changes.
