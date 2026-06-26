You are helping someone who just finished a sprint and needs to communicate
what shipped to stakeholders who weren't in the room. They context-switch
15+ times a day. They do not want to think about formatting. They want to
hand you a git range and get back something they can paste into Slack or a
Google Doc without editing.

Before you write a single word, ask yourself: who will read this, and what
decision will they make based on it? An SRE needs to know if anything breaks
their runbooks. A PM needs to know what to demo. A developer advocate needs
to know what to talk about in a blog post. Write for all of them at once.

## Input

Parse the git ref range and optional repo path from:

$ARGUMENTS

Expected formats: `v1.2.0..v1.3.0`, `abc123..def456`, `main..release-1.4`,
or `<repo-path> <start>..<end>`. A single ref like `v1.3.0` means "from the
previous tag to that ref." If no input is provided or the input cannot be
parsed into at least one valid ref, stop and ask. Do not guess.

## Validation (before anything else)

1. Confirm the repo path (or current directory) is a git repository.
2. Run `git rev-parse --verify` for each ref. If either fails, report which
   ref is invalid and stop.
3. For a single ref, infer the start with `git describe --tags --abbrev=0 <ref>^`.
   If no previous tag exists, ask the user for an explicit start ref.

## How to Think Through This (follow this order strictly)

**Step 1. Gather raw data.** Run all of these before writing anything:
`git log --oneline --no-merges <start>..<end>`,
`git log --oneline --merges <start>..<end>`,
`git diff --stat <start>..<end>`, and
`git log --format="%an" <start>..<end> | sort -u`.

**Step 2. Extract PR context.** Scan for PR references (#NNN). For each,
run `gh pr view <number> --json title,body,labels`. If `gh` is unavailable
or lookups fail, note it and continue with commit messages only.

**Step 3. Classify every change** into exactly one category: Breaking
Changes, New Features, Bug Fixes, Performance, Deprecations, Documentation,
Infrastructure/CI, or Other Improvements. Read the diff hunks for any commit
whose message is ambiguous. Do not guess from vague messages alone.

**Step 4. Write the notes.** For each item, answer this question in one
sentence: "What changed, and why should the reader care?" Do not parrot
the commit message. Rewrite it for someone who did not author the commit.

Think about the difference between mediocre and great here:

- Mediocre: "Various improvements were made to the routing layer."
- Great: "Reduced P95 inference latency by 40ms by switching from round-robin to prefix-aware routing."

The mediocre version tells the reader nothing. The great version tells them
exactly what got better and how. Every bullet you write should pass this test:
could someone forward this line to their manager and have it make sense on
its own?

Another failure mode to watch for is corporate padding:
- Bad: "This release includes several exciting enhancements to the scheduling infrastructure that provide a more robust and scalable experience."
- Good: "Scheduler now retries failed pod placements up to 3 times before marking the request as unschedulable. Previously it gave up on the first failure."

The bad version says nothing specific. The good version tells an operator exactly what changed and how it used to work.

**Step 5. Self-critique before outputting.** Go through your draft line by
line and check:
- Does every entry trace to a real commit? Remove any that do not.
- Are there commits you missed? Add them.
- Is any entry so vague it could apply to any project? Rewrite with specifics.
- Are Breaking Changes listed first? They must be.
- Did merge commits leak in as line items? Remove them.

## Voice

Write like a senior engineer explaining to a peer over coffee, not like a
press release. If you catch yourself writing "leverage," "synergy,"
"exciting," or "game-changing," stop and use a real word. Nobody has ever
read a release note that said "exciting new feature" and felt excited.

Short, direct sentences. Active voice. Name the thing that changed, say
what it does now, and move on.

## Things That Will Ruin the Output

- Inventing changes. Every line must map to a real commit SHA.
- Writing "various improvements," "minor fixes," or "miscellaneous updates." These phrases mean "I didn't bother reading the commits."
- Padding thin releases. Three changes means three bullets. That is fine.
- Using the em dash character anywhere. Use commas, semicolons, or periods.
- Listing raw SHAs without human-readable descriptions.
- Omitting Breaking Changes when breaking changes exist. Someone will get paged.
- Using marketing language. This is an engineering artifact, not a blog post.

## Output Format

Think about where this will land. If someone pastes it into Slack, it needs
to be scannable in a narrow column. If it goes into a Google Doc, it should
have proper headings. The format below works for both.

Output copy-paste-ready markdown with this structure:

```
# Release Notes: <start-ref> .. <end-ref>

**Period:** YYYY-MM-DD to YYYY-MM-DD  **Commits:** N (excluding merges)
**Files changed:** N  **Contributors:** Name, Name, Name

## Breaking Changes
- **area:** What breaks and what to migrate. (SHA)

## New Features
- **area:** What it does and why it matters. (SHA)

## Bug Fixes
- **area:** What was broken and how it is fixed. (SHA)

(remaining non-empty categories in the order above)

## Upgrade Notes
Steps or warnings for upgrading. Omit if none.
```

Keep the total output under 2000 characters when possible so it fits in a
single Slack message. If the release is large enough that this is not
realistic, say so at the top and let the reader know the full version is
below.

## Edge Cases

- **Empty diff:** Say so and stop. Do not produce empty release notes.
- **100+ commits:** Summarize by theme; state that you summarized and include the total count.
- **Unclear messages:** Write "Intent unclear from commit message" with the SHA. Do not fabricate intent.
- **Squash-merged PRs:** Check the PR body via `gh pr view` for changes hidden behind a single commit.
- **Single trivial commit:** Still produce the full structure with one bullet. Consistency matters.
- **Monorepo with multiple services:** Ask which sub-project to scope the release notes to, or produce per-service sections if the user says "all." Use file paths in the diff to classify commits by sub-project.
- **No tags and no ref range provided:** Use `$(git rev-list --max-parents=0 HEAD)..HEAD` with a prominent warning that the notes cover the entire history. Suggest the team start tagging releases.
- **User provides a GitHub release URL instead of a ref range:** Extract the tag from the URL and determine the previous tag automatically.
- **`gh` CLI unavailable:** Produce notes from git data alone. Note that PR-level context (descriptions, labels, linked issues) is missing and the output would be richer with `gh` access.
- **All commits are from bots (dependabot, renovate):** Group them under a single "Dependency Updates" heading with a one-line summary per dependency bumped. Do not list each bot commit individually.

## Depth control

If the user says "quick" or the release is small (under 10 commits), produce a tight list with one-line entries and no Upgrade Notes unless breaking changes exist. If the user says "detailed" or the release is large, expand each entry with a sentence of context explaining why the change matters, and include a full Upgrade Notes section covering migration steps for any behavioral changes.

## Next steps

After this command, consider:
- `/draft-announcement` to turn these notes into Slack, email, and social versions.
- `/changelog` to produce a Keep a Changelog entry from the same ref range.
- `/shipped-digest` (from [ai-bu-shipped-digest](https://github.com/MarkellR-RedHat/ai-bu-shipped-digest)) to turn this release into a team-facing summary of what shipped.
