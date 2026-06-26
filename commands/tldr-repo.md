You are helping someone who just got dropped into a new codebase. Maybe they got reassigned to a project. Maybe a customer asked about a repo they have never seen. Maybe they need to review a PR in an unfamiliar project and do not want to look clueless in the review comments. They need to go from "I have no idea what this repo does" to "I can have an intelligent conversation about it" in five minutes.

The user will provide a repo path, a GitHub URL, or a repo name. Parse from:

$ARGUMENTS

If no input is provided, use the current directory. If the current directory is not a git repo, ask the user to specify one. If a GitHub URL is provided, clone it to a temp directory first using `gh repo clone` or `git clone`. If cloning fails, tell the user and stop.

## How to Think About This

Do not just describe the directory structure. Think about what a newcomer actually needs to know to be dangerous. What is the mental model? Where does the interesting logic live? What will trip them up that is not obvious from the README?

Write the briefing you wish someone had written for you on your first day. No filler. No "various utilities" or "helper functions" as directory descriptions. If you do not know what a directory does, say so. Work through these steps in order.

**Step 1: Figure out what this thing is.** Read README.md, CONTRIBUTING.md, Makefile, Dockerfile, docker-compose.yml, the primary manifest (go.mod, package.json, pyproject.toml, Cargo.toml, pom.xml, requirements.txt), .github/workflows/, and the main entry point. From these, determine what the project does (one sentence, no jargon), what languages and frameworks it uses, and how it is built and deployed.

**Step 2: Build the mental model.** Run `find . -type f | head -200` and `ls -la` at the top level. For each key directory, read enough to understand its purpose. Do not stop at labels. Figure out where the interesting logic actually lives and how data or control flows through the system.

**Step 3: Figure out how to run it.** Look for Makefile targets, Dockerfiles, package manager scripts, CI workflows, and CONTRIBUTING.md setup instructions. Produce the minimum set of commands to get from "I just cloned this" to "it is running locally."

**Step 4: Figure out how to contribute.** Look for branch naming conventions, PR templates, CI checks, linter/formatter configs, and test requirements.

**Step 5: Identify gotchas.** Non-obvious env vars or config files, external service dependencies, known issues, slow or unusual build steps, anything that confused you during analysis.

**Step 6: Find "the one thing."** The single most important thing someone needs to understand about this codebase to have a useful mental model.

## Calibration

A mediocre summary: "This is a Go project with several packages for handling Kubernetes resources."

A great summary: "This is a Kubernetes-native inference gateway. Everything flows through the ext-proc plugin in pkg/epp/, which sits in the Envoy data path and makes per-request routing decisions. If you understand how scheduler.go picks a backend, you understand the core of the project."

The great summary gives someone a place to start reading and a reason to care. Aim for that.

Also watch the "Get It Running" section. Bad: "Please refer to the CONTRIBUTING.md for detailed setup instructions and prerequisites." Good: "Run `make build && make run`. Needs Go 1.22+ and a running Kind cluster. If you do not have Kind: `go install sigs.k8s.io/kind@latest && kind create cluster`." The bad version sends someone on a scavenger hunt. The good version gets them to a running process in 30 seconds.

## Output Format

```
# TL;DR: [Repo Name]

## What It Does
[One sentence. If you cannot explain it in one sentence, the repo probably needs a better README.]

## Tech Stack
- **Language:** [primary language(s)]
- **Framework:** [if applicable]
- **Build:** [build tool]
- **Deploy:** [deployment method if apparent]

## Architecture
| Directory | Purpose |
|-----------|---------|
| `src/` | [one-line description] |
| `pkg/` | [one-line description] |

Key files:
- `[path]` - [why this file matters]

## Get It Running
```bash
[exact commands, from clone to running]
```
**Prerequisites:** [what needs to be installed first]

## How To Contribute
- Branch from: `[default branch]`
- PR process: [brief description]
- Tests: `[test command]`
- CI checks: [what must pass]

## Gotchas
- [Specific thing that will trip you up and how to avoid it]

## The One Thing
[The single most important concept, pattern, or decision someone must understand. 2-3 sentences max.]
```

## Quality Gates

Before outputting, verify:
- "What It Does" is genuinely one sentence and would make sense to someone outside the project
- "Get It Running" commands would actually work if someone ran them right now
- Every directory description is concrete enough that someone could guess what code lives there
- Gotchas are specific and actionable, not generic warnings
- "The One Thing" is the most important insight, not just the first thing you noticed
- The briefing gives someone a place to start reading, not just a list of what exists
- No filler phrases: "various utilities," "helper functions," "miscellaneous tools"
- No guessed build commands. If unclear, say "Build process unclear from repo contents."
- No directories or files you did not actually read. If you skipped it, do not describe it.
- No wall of text. This is a 5-minute briefing, not a design document.

## Edge Cases

- No README: say "No README found. This repo has a discoverability problem." Then do your best from the code.
- Monorepo: focus on top-level structure, list sub-projects with one-line descriptions, offer to deep-dive.
- Empty or tiny repo: say so. Do not pad.
- Archived or stale (no commits in over a year): note the last commit date, flag it may be unmaintained.
