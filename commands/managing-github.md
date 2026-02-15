---
description: >-
  Interact with GitHub via the gh CLI: create issues, PRs, fetch review
  threads, post comments, search. Use when the project's source code hosting
  (declared in CLAUDE.md) is GitHub.
---

# GitHub CLI Reference

## Creating Issues

```bash
gh issue create --title "<title>" --label "<labels>" --body "<body>"
```

For long bodies, write to a temp file and use `--body-file`:

```bash
gh issue create --title "<title>" --label "<labels>" --body-file .tmp/issue-body-$RANDOM.md
```

## Searching Issues

```bash
gh issue list --search "<query>"
gh issue list --label "bug"
```

## Creating Pull Requests

Write the PR body to a temp file, then create the PR:

```bash
gh pr create --title "<title>" --body-file .tmp/pr-body-$RANDOM.md
```

To create a draft PR:

```bash
gh pr create --draft --title "<title>" --body-file .tmp/pr-body-$RANDOM.md
```

### Auto-Close Convention

Include `fixes #<number>` in the PR title or body to auto-close the linked
issue on merge.

## Fetching Unresolved Review Threads

Use the GraphQL API to get review threads with resolution state:

```bash
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

Filter for threads where `isResolved` is `false`.

## Posting Comments

### Reply to a Review Comment

```bash
gh api repos/<org>/<repo>/pulls/<pr>/comments \
  --method POST \
  --field in_reply_to=<comment_id> \
  --field body="<reply text>"
```

### Post an Issue Comment

```bash
gh api repos/<org>/<repo>/issues/<number>/comments \
  --method POST \
  --field body="<comment text>"
```

### Avoiding Shell Expansion Issues

Write the reply body to a temp file and reference it:

```bash
gh api repos/<org>/<repo>/pulls/<pr>/comments \
  --method POST \
  --field in_reply_to=<comment_id> \
  --field body=@.tmp/reply.txt
```

## Viewing PR Details

```bash
gh pr view <number>
gh pr view --json number --jq '.number'
gh pr diff <number>
```

## Fetching PR Comments (Paginated)

```bash
gh api repos/<org>/<repo>/pulls/<pr>/comments --paginate
```

To get only root-level comments (excluding replies), filter by
`in_reply_to_id`:

```bash
gh api repos/<org>/<repo>/pulls/<pr>/comments --paginate \
  --jq '[.[] | select(.in_reply_to_id == null)]'
```
