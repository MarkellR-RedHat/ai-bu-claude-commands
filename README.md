# ai-bu-claude-commands

Slash commands for Claude Code built by the Red Hat AI BU team. Twelve commands that handle the work you actually do: release notes, demo prep, competitive analysis, announcements, retros, and more.

Each command is prompt-engineered with chain-of-thought reasoning, self-critique gates, and anti-pattern bans so the output looks like a senior engineer spent 30 minutes on it, not like an LLM wrote it.

## Installation

```bash
git clone https://github.com/MarkellR-RedHat/ai-bu-claude-commands.git
cd ai-bu-claude-commands
./install.sh
```

The installer copies commands to `~/.claude/commands/` so they are available globally. It checks for existing commands and asks before overwriting.

For project-scoped installation, copy the `.claude/commands/` directory into your project root instead.

## Commands

| Command | What it does |
|---------|-------------|
| `/release-notes` | Generate release notes from a git ref range |
| `/changelog` | Generate a CHANGELOG.md entry (Keep a Changelog format) |
| `/demo-prep` | Structured demo prep with STAR-based talking points and fallback plans |
| `/blog-from-pr` | Draft a blog post from a pull request |
| `/explain-for-customer` | Rewrite technical concepts for non-technical audiences |
| `/competitive-snapshot` | Competitive analysis grounded in public evidence |
| `/summarize-thread` | Summarize a GitHub issue or PR discussion thread |
| `/write-docs` | Generate inline docs and markdown reference from source code |
| `/what-next` | Analyze your open work and tell you the highest-impact thing to do |
| `/draft-announcement` | Draft an announcement for Slack, blog, social, and email at once |
| `/retro` | Data-driven sprint retrospective from git history |
| `/tldr-repo` | 5-minute briefing on any repo you have never seen before |

## Examples

### /what-next

Find the highest-impact thing to work on right now. Scans your open PRs, assigned issues, review requests, and uncommitted work, then ranks them using the Eisenhower Matrix.

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

### 3. Finish inference pool validation (branch: feature/pool-validation)
- **Why now:** Branch is 6 days old with 80% of the work done. Finishing
  it now is cheaper than context-switching back later.
- **Time estimate:** Half day
- **What "done" looks like:** PR opened with passing tests

## Parked Items
- Issue #34 (docs cleanup): No one is blocked. Do it on a slow Friday.
- Dependabot PRs: Batch them at end of week.

## Heads Up
Your branch feature/pool-validation has not been pushed in 4 days.
If your laptop catches fire, that work is gone.
```

### /draft-announcement

Generate an announcement for multiple channels at once. One command, four versions tuned for different audiences.

```
/draft-announcement llm-d v0.3.0 ships prefix-aware routing and autoscaling
```

**Output:**

```markdown
# Announcement: llm-d v0.3.0

---

## Slack (Internal)

llm-d v0.3.0 is out. Two big additions: prefix-aware routing for KV cache
reuse (35% lower time-to-first-token on shared-prefix workloads) and
HPA-based autoscaling that scales inference pools to zero. Full release
notes: [LINK]. Try it on your test cluster and file issues if anything
breaks. :rocket:

---

## Blog Intro Paragraph

Multi-tenant LLM inference wastes compute when identical prompt prefixes
are re-processed across backends. llm-d v0.3.0 addresses this with
prefix-aware routing, which hashes prompt prefixes and routes requests to
backends that already have them cached. In benchmarks on shared-prefix
workloads, median time-to-first-token dropped by 35%. This release also
adds HPA-based autoscaling, allowing inference pools to scale to zero
when idle and spin up on demand.

---

## Social Post

llm-d v0.3.0: prefix-aware routing cuts time-to-first-token 35% on
shared-prefix workloads. Plus scale-to-zero for inference pools. [LINK]

---

## Stakeholder Email

llm-d v0.3.0 shipped today with two capabilities that directly reduce
inference cost for multi-tenant deployments.

Prefix-aware routing reuses cached prompt prefixes across requests,
reducing median time-to-first-token by 35% on workloads where users
share the same system prompt. HPA-based autoscaling lets inference
pools scale to zero when idle, cutting compute costs during off-peak.

The release is available now. Teams running llm-d on OpenShift can
upgrade by updating their InferencePool CR. Migration guide is in
the release notes.
```

### /retro

Run a data-driven retrospective by analyzing actual git history. No sticky notes required.

```
/retro ./llm-d 2026-06-01..2026-06-14
```

**Output:**

```markdown
# Retrospective: llm-d
**Period:** 2026-06-01 to 2026-06-14
**Commits:** 47 | **PRs Merged:** 12 | **Contributors:** 5

---

## What Went Well

### Fast PR turnaround on the metrics stack
**Evidence:** PRs #88, #89, #90 opened and merged within 24 hours each
Clean, focused changes (under 200 lines each) with substantive review
comments that caught two edge cases before merge.

### Zero reverts this sprint
**Evidence:** `git log --grep="revert"` returned nothing for this period
Twelve PRs merged with no rollbacks. The team's pre-merge testing
process is working.

---

## What Was Painful

### PR #82 (autoscaler) was open for 11 days
**Evidence:** Opened 2026-06-02, merged 2026-06-13
**5 Whys Analysis:**
1. PR was 1,200 lines across 28 files
2. Combined the autoscaler feature with a refactor of the pool manager
3. No design review before implementation started
4. Root cause: No team norm on PR size limits or splitting strategy

### Two hotfixes after the config migration merge
**Evidence:** Commits a3f19e2 and b7c44d1 within 6 hours of PR #85 merge
**5 Whys Analysis:**
1. Config migration broke two edge cases in production
2. Edge cases involved clusters with non-default label selectors
3. Test fixtures only covered the default selector
4. Root cause: No test matrix covering non-default configurations

---

## Action Items

| # | Action | Owner | Deadline | Success Metric |
|---|--------|-------|----------|----------------|
| 1 | Add PR size warning at 400 lines (CI check) | TBD | June 28 | No PRs over 400 lines merged without explicit sign-off |
| 2 | Require design doc for changes touching 3+ packages | @alex | July 1 | Template exists, first design doc filed |
| 3 | Add non-default label selectors to test matrix | @sarah | June 21 | 3 new test cases covering edge selectors |

---

## Sprint Stats
- Average PR size: 180 lines changed
- Average PR lifetime: 2.8 days (open to merge)
- Revert rate: 0/12 PRs
- Hotfix count: 2
```

### /tldr-repo

Get up to speed on a repo you have never seen before, fast.

```
/tldr-repo https://github.com/kubernetes-sigs/llm-d
```

**Output:**

```markdown
# TL;DR: llm-d

## What It Does
A Kubernetes-native inference gateway that routes LLM requests to
vLLM backends using prefix-aware, load-aware, and session-aware
scheduling.

## Tech Stack
- **Language:** Go
- **Framework:** Kubernetes controller-runtime, Gateway API
- **Build:** Make, ko
- **Deploy:** Kubernetes (Helm chart or raw manifests)

## Architecture

| Directory | Purpose |
|-----------|---------|
| `api/` | CRD type definitions (InferencePool, InferenceModel) |
| `pkg/epp/` | Ext-proc plugin: the core routing engine |
| `pkg/epp/scheduling/` | Scheduling algorithms (prefix, load, session) |
| `config/` | Kustomize manifests for CRDs and RBAC |
| `test/e2e/` | End-to-end test suite using kind clusters |

Key files:
- `pkg/epp/scheduling/scheduler.go` - where routing decisions happen
- `api/v1alpha2/types.go` - the CRD schema everything else references

## Get It Running

Prerequisites: Go 1.22+, kind, kubectl, Helm

    git clone https://github.com/kubernetes-sigs/llm-d.git
    cd llm-d
    make docker-build
    kind create cluster
    make deploy

## How To Contribute

- Branch from: `main`
- PR process: Fork, branch, open PR against upstream main
- Tests: `make test` (unit), `make test-e2e` (requires kind cluster)
- CI checks: lint, unit tests, e2e tests, generated code freshness

## Gotchas

- The ext-proc plugin requires Envoy Gateway installed in the cluster.
  Without it, the EPP pod starts but never receives traffic.
- CRD updates require `make generate` and `make manifests` before
  committing. CI will reject PRs with stale generated code.

## The One Thing

Everything flows through the ext-proc plugin in `pkg/epp/`. It sits
in the Envoy data path and makes per-request routing decisions. If you
understand how `scheduler.go` picks a backend, you understand the core
of this project.
```

## How commands work

Each `.md` file in `.claude/commands/` becomes a slash command. The filename (minus `.md`) is the command name. Use `$ARGUMENTS` in the prompt to capture user input.

Example: `commands/my-command.md` becomes `/my-command`.

## Writing good commands

The commands in this repo follow a pattern that produces consistently high-quality output:

1. **Role framing.** Tell the model who it is and what good looks like.
2. **Input validation.** Handle missing, vague, and ambiguous input before doing anything.
3. **Chain-of-thought steps.** Force sequential reasoning: gather, analyze, write, verify.
4. **Self-critique gate.** A checklist the model must pass before outputting.
5. **Anti-pattern bans.** Explicit "DO NOT" rules for the most common failure modes.
6. **Output format.** Exact structure so the output is copy-paste ready.
7. **Edge cases.** What to do when the input is trivial, massive, ambiguous, or missing.

## Contributing

Add new commands as `.md` files in both `.claude/commands/` and `commands/`. Follow the pattern above. Run `./install.sh` to test locally.

## License

MIT
