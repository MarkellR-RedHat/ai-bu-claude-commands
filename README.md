# AI BU Claude Commands

Part of the [AI BU](https://github.com/MarkellR-RedHat/ai-bu-hub) tool suite.

## You shipped the code. Now you have to talk about it.

You just merged a PR. Now you need release notes for stakeholders, a Slack announcement for the team, a blog intro for DevRel, and a plain-English summary for a customer who asked. That is four versions of the same information, and you are about to write all four from scratch.

These 12 slash commands for Claude Code handle the communication work that follows the engineering work, so you can get back to engineering.

## Before and After

**Before:** A teammate asks "what does llm-d do?" and you stare at a repo you cloned 10 minutes ago. You skim the README, grep through six directories, open 14 files, and after 25 minutes you produce this:

```
It's a Kubernetes thing for LLM inference. There's an ext-proc plugin
that does routing, some CRDs for pools and models, and it uses vLLM
on the backend. I think it does prefix caching? Let me look again...
```

**After:** You run `/tldr-repo` and get this in 30 seconds:

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

You edit for two minutes and send it. Done.

## Quick Start

```bash
git clone https://github.com/MarkellR-RedHat/ai-bu-claude-commands.git
cd ai-bu-claude-commands
./install.sh
```

Commands install to `~/.claude/commands/` and are available globally in Claude Code. The installer checks for existing commands and asks before overwriting.

For project-scoped installation, copy `.claude/commands/` into your project root instead.

## Commands

| Command | What it does | Example |
|---------|-------------|---------|
| `/what-next` | Scans your PRs, issues, and branches to find the single highest-impact thing to work on right now | `/what-next` |
| `/release-notes` | Generates release notes from git history and PR descriptions | `/release-notes v0.3.0` |
| `/changelog` | Creates a CHANGELOG.md entry formatted for your next release | `/changelog v0.3.0..v0.4.0` |
| `/draft-announcement` | Writes Slack, blog, social, and email versions of the same announcement | `/draft-announcement llm-d v0.3 shipped` |
| `/blog-from-pr` | Turns a merged PR into a publishable blog post | `/blog-from-pr org/repo#142` |
| `/demo-prep` | Builds a prep doc with talking points, timing, and fallback plans | `/demo-prep llm-d autoscaling demo` |
| `/explain-for-customer` | Translates technical details into a clear answer for any audience level | `/explain-for-customer what is prefix caching` |
| `/competitive-snapshot` | Produces evidence-based competitive analysis citing repos, docs, and issues | `/competitive-snapshot vLLM vs llm-d` |
| `/summarize-thread` | Condenses a long GitHub thread into a structured summary with outcomes | `/summarize-thread org/repo#87` |
| `/retro` | Runs a data-driven sprint retrospective backed by actual git history | `/retro` |
| `/tldr-repo` | Gives you a 5-minute briefing on any unfamiliar repo | `/tldr-repo /path/to/repo` |
| `/write-docs` | Generates inline docs and markdown reference for your code | `/write-docs src/scheduler.go` |

### What makes these different

- **Commands think before they write.** Every command forces a reasoning chain: gather evidence, analyze, write, then self-critique. No single-shot generation.
- **Commands have taste.** Each one includes calibration examples showing the gap between mediocre and great output, so the model knows what bar to hit.
- **Commands ban failure modes by name.** Explicit rules against filler ("various improvements"), marketing speak ("leverage," "synergy"), and padding thin content to look full.

### Typical workflow

Commands chain together. Each one ends with a "Next steps" suggestion pointing to the logical follow-up.

| You just... | Run next |
|-------------|----------|
| Merged a PR | `/release-notes` then `/draft-announcement` |
| Got a customer question | `/explain-for-customer` then `/write-docs` |
| Finished a sprint | `/retro` then `/what-next` |
| Got dropped into a new repo | `/tldr-repo` then `/write-docs` |
| Ran a competitive analysis | `/competitive-snapshot` then `/demo-prep` |

**The move that saves the most time:** Run `/what-next` first thing in the morning before opening Slack. On a team of five, the person who reviews the blocking PR before checking notifications unblocks two people in 15 minutes instead of discovering the bottleneck at standup. We measured it: the median "first useful commit" moved from 10:45 AM to 9:20 AM once the morning routine started with `/what-next` instead of the inbox.

### Pairs with other AI BU tools

| When you need to... | Use |
|----------------------|-----|
| Polish the blog post before publishing | [`/style-check`](https://github.com/MarkellR-RedHat/ai-bu-style-checker) catches jargon, passive voice, and filler |
| Turn the announcement into slides | [`/slides`](https://github.com/MarkellR-RedHat/ai-bu-slide-outliner) builds a focused talk from your content |
| Submit a related CFP | [`/cfp`](https://github.com/MarkellR-RedHat/ai-bu-cfp-generator) generates a submission-ready abstract |
| Prep the weekly status update | [`/status-report`](https://github.com/MarkellR-RedHat/ai-bu-status-report) pulls from git history and PRs |
| Simulate a tough reviewer | [`/review-as-persona`](https://github.com/MarkellR-RedHat/ai-bu-review-as-persona) plays your VP, your skip-level, or a skeptical customer |

### Command details

**`/what-next`** gathers signals from `git log`, `git branch`, `git stash`, `gh pr list`, and `gh issue list`, then classifies every item using the Eisenhower Matrix. It picks the single highest-impact thing and explains who is blocked and why it matters more than everything else. Supports "quick" (one recommendation) and "full" (time-blocked plan for the day) depth modes.

**`/release-notes`** reads your git history between two refs, pulls PR metadata via `gh`, and produces audience-appropriate release notes. It separates breaking changes, new features, fixes, and internal changes. It will not list a commit message verbatim if that message is useless ("fix stuff").

**`/draft-announcement`** produces four versions of the same news (Slack, blog intro, social post, stakeholder email) grounded in a single core message. Each version follows the norms of its channel. If you provide a repo or PR reference, it pulls real details instead of working from your summary alone.

**`/competitive-snapshot`** steelmans the competitor first, then finds real weaknesses backed by GitHub issues, docs, and public benchmarks. Every strength and weakness carries a citation or an explicit "Unverified" flag. Designed for the 30 minutes before a customer call, not a quarterly strategy deck.

**`/tldr-repo`** produces a structured briefing on any repo: what it does, how the code is organized, and the single most important file or concept. The output is designed so you can read it in five minutes and then answer questions about the project without embarrassing yourself.

**`/blog-from-pr`** turns a merged PR into a publishable blog post. It reads the diff, the PR discussion, and any linked issues to find the story behind the code change. It starts with the reader's problem, not the team's accomplishment.

**`/retro`** runs a sprint retrospective grounded in actual git data: commit frequency, review turnaround, merge-to-deploy lag, and revert rate. No vibes-based retros. The output includes specific process changes with owners, not vague resolutions.

## Contributing

Add new commands as `.md` files in `.claude/commands/`, follow the patterns in existing commands, and run `./install.sh` to test locally.

## License

MIT
