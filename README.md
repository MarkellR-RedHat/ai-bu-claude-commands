# ai-bu-claude-commands

You just shipped a feature. Your PM wants release notes. Your blog team wants a post draft. A customer asked for a plain-English explanation. That is three different formats of the same information, and you are about to write all three from scratch.

These commands exist so you do not have to.

Twelve slash commands for Claude Code, built by the Red Hat AI BU team, that handle the communication work that follows the engineering work. Release notes, demo prep, competitive analysis, announcements, retros, customer explanations, and more. Each one is tuned to produce output that sounds like a senior engineer spent 30 minutes on it, not like it was generated.

## The problem these solve

Developer Advocates, TMMs, PMMs, and engineers context-switch between coding, writing, presenting, and customer conversations 15+ times per day. The work itself is not the bottleneck. The bottleneck is reformatting the same information for different audiences, over and over, while your actual engineering work piles up.

**Before:** You merge a PR. Then you spend 45 minutes writing release notes, a Slack announcement, a stakeholder email, and a blog intro. Each one requires a different voice, different level of detail, different format. By the time you finish, you have lost your flow state and two more PRs need review.

**After:** You run `/draft-announcement` and get all four versions in 30 seconds. You edit for 5 minutes because you know the details better than any tool. You move on.

## Getting started

```bash
git clone https://github.com/MarkellR-RedHat/ai-bu-claude-commands.git
cd ai-bu-claude-commands
./install.sh
```

The installer copies commands to `~/.claude/commands/` so they are available globally in Claude Code. It checks for existing commands and asks before overwriting anything.

For project-scoped installation, copy the `.claude/commands/` directory into your project root instead.

**Your first command:** Open Claude Code and type `/what-next`. It scans your open PRs, assigned issues, review requests, and uncommitted work, then tells you the single highest-impact thing to do right now.

## Commands

| Command | When to use it |
|---------|---------------|
| `/what-next` | You sat down and have 15 things you could work on. This tells you which one actually matters. |
| `/release-notes` | Sprint is done, stakeholders need to know what shipped. |
| `/changelog` | You need a CHANGELOG.md entry before cutting a release. |
| `/draft-announcement` | Something shipped and you need Slack, blog, social, and email versions. |
| `/blog-from-pr` | Your DevRel lead wants a blog post about a PR you authored. |
| `/demo-prep` | You have a live demo in 2 hours and need a prep doc with fallbacks. |
| `/explain-for-customer` | A customer asked a technical question and needs a clear answer. |
| `/competitive-snapshot` | A competitor came up in a meeting and you need ground truth fast. |
| `/summarize-thread` | A GitHub thread has 47 comments and someone asked "what is the deal with that issue?" |
| `/retro` | Sprint retro time. You want action items backed by git data, not vibes. |
| `/tldr-repo` | You got dropped into a repo you have never seen and need to sound informed in 5 minutes. |
| `/write-docs` | Code review says "please add docs" and you are staring at six parameters. |

## Cross-tool workflow

These commands are designed to chain together. Each command ends with a "Next steps" suggestion pointing you to the logical follow-up command. Common workflows:

| You just... | Run next |
|-------------|----------|
| Merged a PR | `/release-notes` then `/draft-announcement` then `/blog-from-pr` |
| Got a customer question | `/explain-for-customer` then `/write-docs` to prevent the question from recurring |
| Finished a sprint | `/retro` then `/what-next` to turn action items into priorities |
| Got dropped into a new repo | `/tldr-repo` then `/write-docs` on the functions you need to call |
| Summarized a long thread | `/summarize-thread` then `/explain-for-customer` to relay the outcome |
| Ran a competitive analysis | `/competitive-snapshot` then `/demo-prep` to show the Red Hat alternative |

You do not have to follow the suggestions. They are there so you do not have to remember which commands exist when you are in the middle of something.

## What it looks like

### You need to figure out what to work on

```
/what-next
```

**Output:**

```markdown
# What To Work On Next

## If you only have 30 minutes
Merge PR #87 (prefix-aware routing). It has two approvals, CI is green,
and @sarah and @david are blocked on it for the metrics integration.

## Priority Queue

### 1. Merge PR #87: prefix-aware routing
- **Why now:** Two teammates are blocked. CI passed. Two approvals already in.
- **Time estimate:** 15 minutes (address one nit, then merge)
- **What "done" looks like:** PR merged, @sarah and @david unblocked

### 2. Review PR #91: health check refactor
- **Why now:** @alex requested your review 3 days ago. Review queue is your
  team's biggest bottleneck this sprint.
- **Time estimate:** 30 minutes
- **What "done" looks like:** Review submitted with actionable feedback
```

Not a to-do list. A decision.

### You need to announce a release across four channels

```
/draft-announcement llm-d v0.3.0 ships prefix-aware routing and autoscaling
```

You get Slack, blog intro, social post, and stakeholder email versions in one shot. Each tuned for its channel:

**Slack (casual, scannable):**
> llm-d v0.3.0 is out. Prefix-aware routing drops TTFT 35% on shared-prefix
> workloads. HPA autoscaling lets pools scale to zero. Release notes: [LINK].
> Try it on your test cluster.

**Stakeholder email (impact-focused, concise):**
> llm-d v0.3.0 shipped today with two capabilities that directly reduce
> inference cost for multi-tenant deployments. Prefix-aware routing reuses
> cached prompt prefixes across requests, reducing median TTFT by 35%.
> HPA-based autoscaling lets pools scale to zero when idle.

Same facts. Different framing. Five minutes of editing instead of 45 minutes of writing.

### You need to get up to speed on a new repo

```
/tldr-repo https://github.com/kubernetes-sigs/llm-d
```

**Output:**

```markdown
# TL;DR: llm-d

## What It Does
A Kubernetes-native inference gateway that routes LLM requests to
vLLM backends using prefix-aware, load-aware, and session-aware scheduling.

## Architecture

| Directory | Purpose |
|-----------|---------|
| `pkg/epp/` | Ext-proc plugin: the core routing engine |
| `pkg/epp/scheduling/` | Scheduling algorithms (prefix, load, session) |
| `api/` | CRD type definitions (InferencePool, InferenceModel) |

## The One Thing
Everything flows through the ext-proc plugin in pkg/epp/. It sits in the
Envoy data path and makes per-request routing decisions. If you understand
how scheduler.go picks a backend, you understand the core of this project.
```

Five minutes from "never heard of it" to "can have an intelligent conversation about it."

## What people say

> "I used to spend the first hour after a release writing announcements for four different channels. Now I run one command and spend 10 minutes editing. That hour back is worth more than any other tool I have installed this year."
>, Developer Advocate

> "The retro command pulled actual data from our git history and found that our average PR was open for 11 days. We had no idea. That one number changed how we plan sprints."
> , Engineering Manager

> "I got pulled into a customer call about a competitor I had never used. Ran /competitive-snapshot 10 minutes before the call. The analysis cited actual GitHub issues and docs, not marketing fluff. I sounded like I had been tracking them for months."
> , Technical Marketing Manager

> "The demo-prep command saved my talk at Summit. It made me write down fallbacks for every step. When my cluster lost connectivity on stage, I had a pre-recorded terminal session ready. Nobody in the audience knew."
> , Principal Engineer

## How commands work

Each `.md` file in `.claude/commands/` becomes a slash command in Claude Code. The filename (minus `.md`) is the command name. `$ARGUMENTS` in the prompt captures whatever you type after the slash command.

Example: `commands/demo-prep.md` becomes `/demo-prep`.

## What makes these commands different

Most AI prompts say "generate X." These commands are built differently:

1. **They start with your mental state.** Each command opens by acknowledging where you are (overwhelmed, behind, about to go on stage) and what you actually need, not just what format to output.

2. **They think before they write.** Every command forces a reasoning chain: gather evidence, analyze it, write, then self-critique before outputting. No single-shot generation.

3. **They have taste.** Each command includes calibration examples showing the difference between mediocre and great output, so the model knows what quality bar to hit.

4. **They ban common failure modes.** Explicit rules against filler ("various improvements"), marketing speak ("leverage," "synergy"), and padding thin content to look comprehensive.

5. **They handle edge cases.** Empty git history, missing PR descriptions, ambiguous input, repos with no README. Each command knows what to do when things are messy.

## Contributing

Add new commands as `.md` files in both `.claude/commands/` and `commands/`. Follow the patterns in the existing commands. Run `./install.sh` to test locally.

## License

MIT
