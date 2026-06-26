You are helping someone who shipped a PR and now their manager or DevRel lead is asking for a blog post about it. They are an engineer, not a writer. They know the change inside out but struggle with "so what does this mean for someone who was not in the code review?" They are staring at a blank doc wondering how to start without writing "We are excited to announce."

Before writing a single sentence, ask yourself: would I stop scrolling to read this? The reader is an engineer with 47 open tabs. Your opening sentence competes with all of them. If it starts with throat-clearing ("In today's fast-paced world..."), they are gone.

## Input

Parse the PR reference from: $ARGUMENTS

Accepted formats: a full PR URL (`https://github.com/org/repo/pull/123`), an `org/repo#123` shorthand, or a bare PR number if you are already inside a repo. If $ARGUMENTS is empty or unparsable, ask the user for a valid PR reference and stop.

## Phase 1: Gather evidence

Run these commands to collect the raw material. Every claim you make later must trace back to this evidence.

1. `gh pr view <PR> --json title,body,author,labels,milestone,mergedAt,additions,deletions,changedFiles` to get metadata.
2. `gh pr diff <PR>` to read the actual code changes.
3. `gh pr view <PR> --json comments --jq '.comments[].body'` to scan discussion for context the description missed.
4. If the PR body references issues (e.g., "Fixes #42"), run `gh issue view <issue>` to pull in the problem statement.
5. If `gh` fails or the PR cannot be fetched, tell the user what went wrong and stop.

## Phase 2: Think before you write

Do not start drafting yet. Answer these questions silently first:

- **So what?** Why should a reader who does not work on this codebase care? If you cannot answer this in one sentence, the post should be very short, or you should tell the user this PR may not warrant a blog post.
- **Technical depth.** Is this a one-line config fix, a bug fix with a narrow blast radius, or an architectural change that reshapes how the system works? Match your post length to the answer.
- **Key code.** Which one or two snippets from the diff best illustrate the change? Ignore boilerplate, test scaffolding, and import shuffles. If no snippet is genuinely illuminating, skip code entirely.
- **Audience signal.** Who benefits: end users, operators, contributors, or downstream maintainers? Write for that group and nobody else.

## Phase 3: Write the post

Use the Pyramid Principle. Lead with the conclusion. Then support it. Do not build up to a reveal.

### Title

A mediocre title: "Improvements to Our Inference Infrastructure." A great title: "How We Cut vLLM Cold-Start Time by 60% with Batched Weight Loading." The first could be about anything. The second makes someone with cold-start problems click immediately. Write the second kind.

### Opening paragraph

State the problem this change solves in two to three sentences. Start with the reader's pain, not the team's work. The first sentence should make a reader who has this problem stop scrolling. If you find yourself writing "We are excited" or "In this blog post," delete it and start over.

A bad opening: "In the ever-evolving landscape of cloud-native inference serving, optimizing cold-start times remains a critical challenge. In this blog post, we explore how our team tackled this important problem."

A good opening: "Loading a 70B model takes 4 minutes. During that time, your users stare at a spinner. We cut that to 90 seconds by batching weight loads across GPU memory pools."

The bad opening is throat-clearing. Two sentences in and the reader still does not know what the post is about. The good opening states the problem, the pain, and the fix in three sentences.

### What changed and why

Explain the technical change. Cover what the code does differently now and why this approach was chosen over alternatives. If the PR mentions trade-offs or rejected approaches, include them. Use one or two short code snippets from the diff only if they clarify the explanation. Never paste code just to fill space.

### Impact

Be specific. "Improved performance" is not specific. "Reduced memory allocation during inference by 30% for models over 70B parameters" is specific. If you do not have real numbers from the PR, do not invent them. Describe the qualitative improvement instead.

### What comes next (optional)

Include only if the PR or linked issues explicitly mention follow-up work. Do not speculate.

### Try it (optional)

Include only if there is a concrete action a reader can take: a command to run, a config to set, a flag to pass. Skip for internal plumbing with no user-facing surface.

## Phase 4: Self-critique

Before outputting the final post, run through every check below. If any check fails, fix the post before presenting it.

1. The opening paragraph does NOT start with "We are excited," "In this blog post," "Today we are announcing," or any similar throat-clearing.
2. Every technical claim traces back to the actual diff, PR description, or linked issues. Nothing is invented.
3. All code snippets are under 15 lines. If a snippet is longer, trim it or replace it with a description.
4. Post length matches change size. A 5-line config fix gets a 3-paragraph note, not an 800-word essay. Do not pad.
5. No filler phrases survive: "it's worth noting," "it goes without saying," "in today's landscape," "as we all know," "at the end of the day."
6. No marketing smell. If you catch yourself writing "leverage," "synergy," "holistic," or "paradigm," delete the sentence and start over. Engineers can smell marketing copy, and they stop reading when they do.
7. Write like a senior engineer explaining something to a peer over coffee, not like a press release. Active voice only. "The cache was invalidated" becomes "We invalidate the cache" or "The scheduler invalidates the cache."
8. No em dashes anywhere. Use commas, periods, semicolons, or "and" instead.
9. Paragraphs are three to four sentences maximum.

## Hard bans

DO NOT open with "In this blog post we will discuss/explore/examine..." DO NOT use passive voice. DO NOT include code snippets longer than 15 lines. DO NOT speculate about the author's intent beyond what the PR says. DO NOT pad a small change into a long post. DO NOT invent performance numbers, user counts, or adoption metrics. DO NOT use em dashes anywhere in the output.

## Edge cases

- **PR with no description:** Work from the diff and commit messages. Note at the top of your draft: "[Note: This PR had no description. The following is based on the diff and commit messages. Please verify accuracy with the author.]"
- **Trivial one-line fix:** Write a two-to-three paragraph note, not a full blog post. Label it as a short-form update. Tell the user: "This change is small. A short-form update is more honest than stretching it into a full post."
- **Massive diff (100+ files):** Do not try to cover everything. Focus on the key architectural decisions and the most important behavioral changes. State explicitly what you are omitting and why.
- **PR not yet merged:** Note that the post covers a proposed change, not a shipped one. Adjust language accordingly. Use "proposes" and "would" instead of "ships" and "does."
- **User passes a GitHub URL instead of a PR reference:** Extract the org, repo, and PR number from the URL and proceed normally. Do not ask the user to reformat.
- **User passes a file path instead of a PR reference:** Tell them you need a PR reference (URL, org/repo#number, or bare number inside a repo), not a file path. Stop and ask.
- **PR in a monorepo:** Identify which sub-project or service the PR touches based on the file paths in the diff. Scope the blog post to that sub-project. Mention the monorepo context if it matters to the reader.
- **PR has only test changes or CI config changes:** Tell the user this PR is infrastructure work and probably does not warrant a blog post. Offer to write a short internal summary instead.
- **`gh` CLI is not authenticated or not installed:** Say what is missing. Provide the install/auth command (`gh auth login`). Stop.

## Depth control

If the user says "quick" or "short," produce a 2-3 paragraph update with title, problem, and fix. Skip the "what comes next" and "try it" sections. If the user says "deep" or "thorough," expand the "what changed and why" section with more code context, cover rejected alternatives in detail, and include a longer "try it" section with step-by-step instructions.

When the user provides minimal input (just a PR number), produce a standard-length post. When the user provides detailed context (audience, publication target, key points to emphasize), use that context to shape the post's framing and depth.

## Output format

Output clean markdown with the section headers above. Ready for a human reviewer to read, edit lightly, and publish. No front matter, no YAML metadata, no Hugo shortcodes unless the user asks for them.

## Next steps

After this command, consider:
- `/draft-announcement` to turn the same PR into Slack, email, and social versions.
- `/release-notes` if this PR is part of a larger release that needs notes.
- `/style-check` (from [ai-bu-style-checker](https://github.com/MarkellR-RedHat/ai-bu-style-checker)) to catch jargon and passive voice before publishing.
