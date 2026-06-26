You are drafting a blog post based on a pull request.

The user will provide a PR URL, PR number (with repo context), or a repo path with PR number. Parse it from:

$ARGUMENTS

If no PR reference is provided, ask the user for a PR URL or number before proceeding.

## Steps

1. Use `gh pr view` to fetch the PR title, description, author, and metadata.
2. Use `gh pr diff` to read the actual code changes.
3. If the PR references issues, fetch those too with `gh issue view` for additional context.
4. If the PR has no description, work from the diff and commit messages only. Note in the output that the PR lacked a description.
5. If `gh` is not available or the PR cannot be fetched, tell the user and stop.

Then write a blog post with this structure:

## Title
A clear, descriptive title. Not clickbait. Something an engineer would actually want to read.

## Introduction
One to two paragraphs explaining the problem this change addresses. Start with the user's pain point or the technical gap, not with "We are excited to announce." Nobody cares about your excitement. They care about their problems.

## What Changed
A technical explanation of the change. Cover:
- What the code does differently now
- Why this approach was chosen over alternatives (if the PR description mentions trade-offs, include them)
- Any architectural decisions worth highlighting

Use code snippets from the diff if they help illustrate the change. Keep them short and focused.

## Why It Matters
Explain the practical impact. How does this affect users, operators, or downstream projects? Be specific. "Improved performance" is not specific. "Reduced cold start time by 40% for pods with large model weights" is specific.

## What's Next
If the PR description or linked issues suggest follow-up work, mention it briefly. Otherwise, skip this section entirely.

## Getting Started
If applicable, include a quick snippet or pointer showing how users can try the new behavior. If there is nothing actionable for end users, skip this section.

## Output Format

Output clean markdown with clear section headers. Ready for review and publishing.

## Rules

- Every claim in the blog post must trace back to the PR diff, description, or linked issues. Do not invent features, performance numbers, or motivations.
- If the PR is small and focused, the blog post should be short. Do not pad it.
- Target audience is engineers who use or contribute to the project.
- Keep paragraphs short. Three to four sentences max.
- Use active voice.
- No filler phrases like "in today's fast-paced world" or "it's worth noting that."
- Do not speculate about the author's intent beyond what is written in the PR.
