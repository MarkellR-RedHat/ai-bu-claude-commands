You are summarizing a GitHub issue or pull request discussion thread.

The user will provide a GitHub issue or PR URL. Parse it from:

$ARGUMENTS

If no URL is provided, ask the user for a GitHub issue or PR URL before proceeding.

## Input Validation

1. Verify the URL looks like a valid GitHub issue or PR URL (e.g., https://github.com/owner/repo/issues/123 or https://github.com/owner/repo/pull/456).
2. Extract the owner, repo, and number from the URL.
3. Determine whether it is an issue or PR from the URL path.

## Steps

1. For issues: run `gh issue view <number> --repo <owner>/<repo>` to get the issue title, body, and metadata.
2. For PRs: run `gh pr view <number> --repo <owner>/<repo>` to get the PR title, body, and metadata.
3. Fetch comments using `gh api repos/<owner>/<repo>/issues/<number>/comments --paginate` to get the full discussion thread.
4. For PRs, also fetch review comments with `gh api repos/<owner>/<repo>/pulls/<number>/comments --paginate` and reviews with `gh api repos/<owner>/<repo>/pulls/<number>/reviews --paginate`.
5. If `gh` is not available or the fetch fails, tell the user and stop.

## Output Format

```
# Thread Summary: <title>

**URL:** <original URL>
**Type:** Issue | Pull Request
**Status:** Open | Closed | Merged
**Participants:** list of usernames
**Comments:** N total

## TL;DR
Two to three sentence summary of the entire discussion.

## Key Points
- Bullet point for each significant point or decision made
- Include who raised it (by username)

## Open Questions
- Any unresolved questions or disagreements still pending

## Decisions Made
- Any concrete decisions, with who made them

## Action Items
- Any follow-up work mentioned, with assignees if stated
```

## Rules

- Attribute statements to their authors by GitHub username.
- Do not editorialize or add your own opinion. Report what was said.
- If the thread is very long (50+ comments), focus on the key turning points and decisions rather than summarizing every comment.
- If comments contain code snippets or technical details that are central to the discussion, include them briefly.
- If the thread contains heated disagreements, summarize both sides neutrally.
- Do not invent comments, usernames, or decisions that do not appear in the thread data.
- If the issue/PR has no comments, say "No discussion yet" and summarize only the original post.
