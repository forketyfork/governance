---
name: learn
description: "Extract learnings from sessions to update CLAUDE.md"
---

Analyze this session to extract learnings for CLAUDE.md.

First, read the current CLAUDE.md and understand its structure.

Identify from this session:

1. **Blockers:** Where did you get stuck, retry, or need correction?
2. **Discoveries:** What non-obvious information was needed to succeed?
3. **Corrections:** What in CLAUDE.md was wrong or outdated?
4. **Missing context:** What project knowledge would have helped from the start?

Before drafting any updates, deduplicate and prune:

1. **Deduplication:** For each learning identified above, check if CLAUDE.md already covers the topic. If it does and the existing entry is correct and complete, skip it. If it covers the topic but needs updating, propose an update to the existing entry rather than adding a new one.
2. **Pruning:** Review existing CLAUDE.md entries that relate to this session's work. If any are now outdated, incorrect, or contradicted by what happened in this session, propose their removal or update. Stale knowledge is worse than missing knowledge.

For each remaining item, draft an update:

- Blockers → Add to a "Known Pitfalls" or "Gotchas" section
- Discoveries → Add to relevant technical section (create if needed)
- Corrections → Edit in place, note what changed
- Missing context → Add to "Project Setup" or "Architecture" section

Abstraction test: Before adding anything, ask "Would this help on a _different_ task in this project?" If no, it's too specific — generalize or skip.

Output a diff preview:

```diff
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
