---
description: >-
  Interact with GitHub via the gh CLI: create issues, PRs, fetch review
  threads, post comments, search. Use when the project's source code hosting
  (declared in CLAUDE.md) is GitHub.
---

# GitHub CLI Reference

## Repository Setup

These procedures implement the constitution's supply-chain security, branch
protection, and repository hygiene requirements for GitHub-hosted Lands.

### Repository Metadata

Set a description and topics for discoverability:

```bash
gh repo edit --description "<description>" \
  --add-topic "<topic1>" --add-topic "<topic2>"
```

Add a homepage link if applicable:

```bash
gh repo edit --homepage "<url>"
```

### Default Branch

Rename the default branch to `main` if it is still named `master`:

```bash
gh api repos/<org>/<repo> --method PATCH --field default_branch=main
```

### Secret Scanning and Push Protection

Enable via the repository security settings page:

`https://github.com/<org>/<repo>/settings/security_analysis`

- **Secret Protection:** enabled
- **Push protection:** enabled

### Code Scanning (CodeQL)

Enable CodeQL with default settings via the repository security settings page:

`https://github.com/<org>/<repo>/settings/security_analysis`

- **CodeQL analysis:** enabled with default setup

If the default setup fails, configure advanced settings with a custom workflow.

### CI Workflow Permissions

In every GitHub Actions workflow file, add a top-level `permissions` block with
the minimum required access:

```yaml
permissions:
  contents: read
```

Grant additional permissions only when explicitly needed by a specific job.

### Branch Rulesets

On the Rulesets page (`https://github.com/<org>/<repo>/settings/rules`), create
a ruleset named "Protect the main" targeting the default branch with these
settings:

- **Require status checks to pass** — add the CI build job as a required check
- **Require branches to be up to date before merging**
- **Block force pushes**
- **Restrict deletions**
- **Require code scanning results**

### Dependabot Configuration

Create `.github/dependabot.yml` with ecosystem-appropriate entries. Example for
a Maven/Gradle project:

```yaml
version: 2
updates:
  - package-ecosystem: "maven"
    directory: "/"
    schedule:
      interval: "daily"
    groups:
      all-dependencies:
        patterns:
          - "*"

  - package-ecosystem: "github-actions"
    directory: "/"
    schedule:
      interval: "weekly"
    groups:
      all-actions:
        patterns:
          - "*"
```

Enable Dependabot alerts and grouped security updates via the security settings
page:

`https://github.com/<org>/<repo>/settings/security_analysis`

- **Dependency graph:** enabled
- **Dependabot alerts:** enabled
- **Grouped security updates:** enabled
- **Dependabot security updates:** enabled

---

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
