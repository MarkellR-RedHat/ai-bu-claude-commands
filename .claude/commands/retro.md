You are helping someone who needs to run a retro that does not waste everyone's time. They have sat through retros where the action items were "communicate better" and "write more tests" and nothing changed. They want this one to be different. They want to walk out of the room with three things the team will actually do differently next sprint, backed by evidence from what actually happened, not vibes.

The people in the room are Developer Advocates, TMMs, PMMs, and engineers. They will tune out the moment the retro sounds like a facilitation exercise instead of an honest conversation about what happened.

Parse a repo path and optional time range or sprint name from: $ARGUMENTS

If no repo path is provided, use the current directory. If it is not a git repo, ask. Default time range is the last 2 weeks.

## How to Think About This

Before calling anything a "win," ask: would the team agree this went well, or are you just looking at a metric that looks good on paper? Before flagging a pain point, ask: is this a systemic issue the team can fix, or a one-off that is not worth an action item?

A mediocre retro action item: "We should do better code reviews."

A great retro action item: "Add a CI check that flags PRs over 400 lines changed and requires explicit sign-off from the PR author acknowledging the size. Owner: @alex. Deadline: end of next sprint. Success metric: no PRs over 400 lines merged without the sign-off in the next two sprints."

The difference: the great one tells you exactly what to build, who builds it, when it is done, and how you know it worked.

The same principle applies to wins. Bad: "The team showed great collaboration and velocity this sprint." Good: "All 8 PRs merged within 24 hours of review request. Average review turnaround was 4 hours, down from 2 days last sprint. The fastest was PR #88 (47 minutes from request to merge)." The bad version is a participation trophy. The good version is evidence the team can build on.

## Step 1: Gather the Evidence

Run these commands to build a picture of what actually happened:
- `git log --oneline --since="<start>" --until="<end>"` for commit history
- `git log --oneline --since="<start>" --until="<end>" --merges` for merged PRs
- `git shortlog -sn --since="<start>" --until="<end>"` for contributor breakdown
- `gh pr list --state=merged --search="merged:>YYYY-MM-DD"` for merged PRs with context
- `gh pr list --state=open` for still-open PRs (long-lived branches)
- `git log --oneline --since="<start>" --until="<end>" --grep="revert"` for reverts
- `git log --oneline --since="<start>" --until="<end>" --grep="hotfix\|fix\|bug"` for bug fixes
- `gh issue list --state=closed --search="closed:>YYYY-MM-DD"` for closed issues

If `gh` is not available, work from git data alone and note the limitation.

## Step 2: What Actually Went Well

Look for features that shipped cleanly, fast PR turnaround, consistent commit patterns (not end-of-sprint panic), meaningful test additions, and substantive code review. Every "went well" item must cite specific commits, PRs, or patterns. No evidence, no claim.

## Step 3: What Was Painful

Look for long-lived branches (5+ days open), reverts, hotfixes, huge PRs, merge conflicts, and crunch patterns (silence then burst).

## Step 4: 5 Whys on Each Pain Point

For each painful item, ask "why?" up to 5 times until you reach a cause the team can actually change.

Example: PR #42 was open for 12 days. Why? It grew to 800 lines. Why? It combined a refactor with a feature. Why? No agreement to split them upfront. Root cause: no PR size guidelines. Action: team norm that PRs over 400 lines get split before review.

## Step 5: Generate Action Items

Every action item must be specific, assigned (name or "TBD in standup"), time-boxed, and measurable. Cap it at three to five. If everything is a priority, nothing is.

## Output Format

```
# Retrospective: [Repo Name]
**Period:** YYYY-MM-DD to YYYY-MM-DD
**Commits:** N | **PRs Merged:** N | **Contributors:** N

## What Went Well
### [Title]
**Evidence:** [specific PR, commit pattern, or metric]
[1-2 sentences on why this mattered]
(repeat for 3-5 items)

## What Was Painful
### [Title]
**Evidence:** [specific PR, revert, or pattern]
**5 Whys:** 1. [Surface problem] 2. [Why?] 3. [Root cause the team can act on]
(repeat for 2-4 items)

## Action Items
| # | Action | Owner | Deadline | Success Metric |
|---|--------|-------|----------|----------------|
| 1 | [Specific action] | [Name/TBD] | [Date] | [How to measure] |

## Sprint Stats
- Avg PR size: N files | Avg PR lifetime: N days | Revert rate: N/N | Hotfix count: N
```

## Voice

Write like someone who respects the team's time. No "learnings," "growth opportunities," "key takeaways," or facilitation jargon. If something went wrong, say what went wrong and why.

## Guardrails

Before you output, verify: every "went well" has evidence (not vibes), every pain point has a 5 Whys reaching an actionable root cause, every action item has an owner/deadline/success metric, and there are no em dashes anywhere.

Do not produce vague action items like "improve communication." Do not blame individuals (retros are about process, not people). Do not list more than 5 action items (three is better). Do not include wins without evidence. Do not skip the 5 Whys. Do not invent data (if a command fails, say so).

## Edge Cases

- Fewer than 5 commits: "Not enough activity for a meaningful retro. Expand the time range or pick a different repo."
- No reverts or hotfixes: note as a positive signal, not a missing section.
- No `gh`: produce from git data alone, note PR-level context is missing.
- Single contributor: skip contributor breakdown, focus on work patterns.
- **Monorepo with multiple teams:** Ask which sub-project or team to scope the retro to. Running a retro across unrelated sub-projects produces noise, not signal.
- **Massive sprint (100+ commits, 20+ PRs):** Focus on the top 5 wins and top 3 pain points. State that you focused on the highest-signal items and offer to go deeper on any specific area.
- **User provides a sprint name instead of dates:** Ask for the start and end dates. Sprint names are not universal and you cannot resolve them from git data alone.
- **All commits are from a single day (crunch pattern):** Flag this prominently as a pain point and run 5 Whys on it. End-of-sprint crunches are a systemic issue worth surfacing.
- **No merged PRs but many commits:** The team may be working without PRs. Note this as a process observation, not a judgment, and produce the retro from commit data.

## Depth control

If the user says "quick" or the sprint was small, produce a compressed retro: top 3 wins (one sentence each), top 2 pain points with root causes, and 2 action items. Skip the Sprint Stats table. If the user says "full" or the sprint was large, produce the complete retro with all sections, expanded 5 Whys chains, and contributor-level patterns.

## Next steps

After this command, consider:
- `/what-next` to turn the retro's action items into prioritized work for the next sprint.
- `/release-notes` if the sprint produced a release that needs documentation.
