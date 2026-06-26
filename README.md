# AI BU Claude Commands

You just merged a PR. Now you need release notes for stakeholders, a Slack announcement for the team, a blog intro for DevRel, and a plain-English summary for a customer who asked. That is four versions of the same information, and you are about to write all four from scratch.

These 12 slash commands for Claude Code handle the communication work that follows the engineering work, so you can get back to engineering.

## Before and after

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

## What makes this different

- **Commands think before they write.** Every command forces a reasoning chain: gather evidence, analyze, write, then self-critique. No single-shot generation.
- **Commands have taste.** Each one includes calibration examples showing the gap between mediocre and great output, so the model knows what bar to hit.
- **Commands ban failure modes by name.** Explicit rules against filler ("various improvements"), marketing speak ("leverage," "synergy"), and padding thin content to look comprehensive.

## Quick start

```bash
git clone https://github.com/MarkellR-RedHat/ai-bu-claude-commands.git
cd ai-bu-claude-commands
./install.sh
```

Commands install to `~/.claude/commands/` and are available globally in Claude Code. The installer checks for existing commands and asks before overwriting.

For project-scoped installation, copy `.claude/commands/` into your project root instead.

## Commands

| Command | What it does |
|---------|-------------|
| `/what-next` | Scans your PRs, issues, and branches to find the single highest-impact thing to work on right now |
| `/release-notes` | Generates release notes from git history and PR descriptions |
| `/changelog` | Creates a CHANGELOG.md entry formatted for your next release |
| `/draft-announcement` | Writes Slack, blog, social, and email versions of the same announcement |
| `/blog-from-pr` | Turns a merged PR into a publishable blog post |
| `/demo-prep` | Builds a prep doc with talking points, timing, and fallback plans |
| `/explain-for-customer` | Translates technical details into a clear answer for any audience level |
| `/competitive-snapshot` | Produces evidence-based competitive analysis citing repos, docs, and issues |
| `/summarize-thread` | Condenses a long GitHub thread into a structured summary with outcomes |
| `/retro` | Runs a data-driven sprint retrospective backed by actual git history |
| `/tldr-repo` | Gives you a 5-minute briefing on any unfamiliar repo |
| `/write-docs` | Generates inline docs and markdown reference for your code |

## Workflows

Commands chain together. Each one ends with a "Next steps" suggestion pointing to the logical follow-up.

| You just... | Run next |
|-------------|----------|
| Merged a PR | `/release-notes` then `/draft-announcement` |
| Got a customer question | `/explain-for-customer` then `/write-docs` |
| Finished a sprint | `/retro` then `/what-next` |
| Got dropped into a new repo | `/tldr-repo` then `/write-docs` |
| Ran a competitive analysis | `/competitive-snapshot` then `/demo-prep` |

## Contributing

Add new commands as `.md` files in `.claude/commands/`, follow the patterns in existing commands, and run `./install.sh` to test locally.

## License

MIT
