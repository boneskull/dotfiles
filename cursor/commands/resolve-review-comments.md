---
description: Address any valid, outstanding pull request (PR) review comments
argument-hint: [PR_NUMBER]
---

# /resolve-review-comments

## Purpose

Address any valid, outstanding pull request (PR) review comments

## Contract

**Inputs:** `PR_NUMBER` (optional) — PR number to check (defaults to current branch's PR)
**Outputs:** `STATUS=<OK|FAIL> [key=value ...]`

## Instructions

1. **Identify the PR:**
   - If PR_NUMBER provided, use it
   - Otherwise, detect PR from current branch using `gh pr view`

2. **Fetch review comments:**
   - Get all review threads using GitHub GraphQL API
   - Filter for unresolved threads
   - Show comment details: file, line, author, body

3. **For each unresolved comment:**
   - Read the comment and assess validity
   - If valid:
     - Implement the suggested fix
     - Test the fix (lint, run relevant tests)
     - Commit the fix with message referencing the review
     - Push to PR branch
     - **Add reply to review comment conversation** explaining the fix concisely
     - Mark thread as resolved using GraphQL API
   - If invalid:
     - **Add reply to review comment conversation** explaining why it's invalid concisely
     - Mark thread as resolved using GraphQL API
   - If unclear:
     - Ask user whether to address it or skip

4. **Output status:**
   - Print `STATUS=OK RESOLVED=N` where N is count of resolved comments
   - Print `STATUS=FAIL ERROR="message"` on failure

## Example Workflow

```bash
# 1. Get unresolved review threads
gh api graphql -f query='
  query {
    repository(owner: "OWNER", name: "REPO") {
      pullRequest(number: PR_NUM) {
        reviewThreads(first: 50) {
          nodes {
            id
            isResolved
            comments(first: 10) {
              nodes {
                id
                databaseId
                body
                path
                line
                author { login }
              }
            }
          }
        }
      }
    }
  }
'

# 2. Add reply to review comment conversation (NOT issue comment!)
# Use the first comment's databaseId as in_reply_to
gh api repos/OWNER/REPO/pulls/PR_NUM/comments \
  -f body="✅ Fixed in commit abc1234..." \
  -F in_reply_to=COMMENT_DATABASE_ID

# 3. Resolve the thread
gh api graphql -f query='
  mutation {
    resolveReviewThread(input: {threadId: "THREAD_ID"}) {
      thread { id isResolved }
    }
  }
'
```

## Constraints

- Only address comments marked as "valid" after analysis
- Always test fixes before committing
- Use conventional commit messages referencing the review
- Atomic commits per review comment
- Ask user for confirmation on ambiguous cases
- **IMPORTANT:** Add replies to review comment conversations (using `in_reply_to`), NOT to the issue
- Keep replies concise (1-3 sentences explaining fix or why invalid)
