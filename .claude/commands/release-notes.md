You are generating release notes for a software project.

The user will provide a repo path and two git refs (tags, branches, or commit SHAs). Parse these from the following input:

$ARGUMENTS

If the input is missing any of the three required values (repo path, start ref, end ref), ask the user to provide them.

Steps:

1. Navigate to the repo path provided.
2. Run `git log --oneline --no-merges <start-ref>..<end-ref>` to get the list of commits between the two refs.
3. Run `git diff --stat <start-ref>..<end-ref>` to understand the scope of changes.
4. If there are PRs referenced in commit messages, extract their numbers and look up their titles and descriptions using `gh pr view`.
5. Group the changes into these categories. Omit any category that has no entries:
   - New Features
   - Bug Fixes
   - Performance Improvements
   - Documentation
   - Breaking Changes
   - Other Improvements
6. For each item, write a concise one-liner describing what changed and why it matters. Do not just repeat the commit message. Rewrite it so a human can understand the impact.
7. At the top, include a summary section with the ref range, date range, total commits, and number of files changed.

Output format should be clean markdown suitable for pasting into a GitHub release, a changelog, or a Slack message.

Keep the tone direct and informative. No marketing language. If a commit message is unclear, say so rather than guessing.
