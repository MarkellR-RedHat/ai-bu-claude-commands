# ai-bu-claude-commands

A collection of custom slash commands for Claude Code, built for the AI BU team at Red Hat.

These commands handle common tasks that come up in engineering work: writing release notes, prepping demos, explaining technical concepts to customers, running competitive analysis, turning PRs into blog posts, generating changelogs, summarizing discussion threads, and writing documentation.

## Installation

Clone the repo and run the install script:

```bash
git clone https://github.com/MarkellR-RedHat/ai-bu-claude-commands.git
cd ai-bu-claude-commands
chmod +x install.sh
./install.sh
```

This copies the command files to `~/.claude/commands/`, which makes them available globally in Claude Code as slash commands. The installer will check for existing commands and ask before overwriting.

If you prefer to install them into a specific project, copy the `.claude/commands/` directory into your project root instead.

### Manual install

```bash
cp .claude/commands/*.md ~/.claude/commands/
```

## Commands

### /release-notes

Generate human-readable release notes from a git ref range. Provide a repo path, start ref, and end ref. The output groups changes by theme (features, fixes, improvements, breaking changes) and rewrites commit messages into plain language.

```
/release-notes /path/to/repo v1.2.0 v1.3.0
```

### /demo-prep

Generate a structured demo preparation document. Provide a topic or feature name. The output includes a prerequisites checklist, step-by-step script with talking points, fallback plans for when things break, and time estimates.

```
/demo-prep llm-d model serving on OpenShift
```

### /explain-for-customer

Rewrite a technical concept or error message for a non-technical audience. Provide the term, error message, or concept. The output is accurate but jargon-free, suitable for support tickets, customer emails, or knowledge base articles.

```
/explain-for-customer OOMKilled error in Kubernetes pod
```

### /competitive-snapshot

Produce a structured competitive analysis for a given product or project. The output covers strengths, weaknesses, how Red Hat's offering differs, and key takeaways. Grounded in facts, not marketing.

```
/competitive-snapshot vLLM
```

### /blog-from-pr

Draft a blog post from a pull request. Provide a PR URL or number. Reads the diff and description, then writes a post covering what changed, why it matters, and how to use it. Targets an engineering audience.

```
/blog-from-pr https://github.com/org/repo/pull/42
```

### /changelog

Generate a CHANGELOG.md entry following the Keep a Changelog format. Provide a repo path and version number. Optionally provide a git ref range.

```
/changelog /path/to/repo 1.4.0
/changelog /path/to/repo 1.4.0 v1.3.0 v1.4.0
```

### /summarize-thread

Summarize a long GitHub issue or PR discussion thread. Provide a GitHub URL. Returns a structured summary with key points, decisions, open questions, and action items.

```
/summarize-thread https://github.com/kubernetes-sigs/llm-d/issues/52
```

### /write-docs

Generate documentation for a function, module, class, or API endpoint from its source code. Provide a file path, function name, or module name. Outputs both inline documentation (docstrings, JSDoc, etc.) and a markdown reference document.

```
/write-docs src/scheduler/router.go
/write-docs MyClassName
```

## What Each Command Does (with examples)

### Example: /release-notes

**Input:**
```
/release-notes /home/user/projects/llm-d v0.1.0 v0.2.0
```

**Output:**
```markdown
# Release Notes: v0.1.0 to v0.2.0

**Date range:** 2026-05-10 to 2026-06-15
**Commits:** 34
**Files changed:** 87

## New Features
- Add prefix-aware routing for KV cache optimization, enabling
  shared prompt prefixes to be routed to the same backend
- Add Prometheus metrics endpoint exposing request latency,
  queue depth, and backend health per model

## Bug Fixes
- Fix goroutine leak in health checker when a backend becomes
  unreachable and the context is not cancelled
- Fix incorrect content-length header on streamed responses
  causing some clients to hang

## Performance Improvements
- Reduce P99 scheduling latency from 12ms to 4ms by switching
  from mutex-based locking to a lock-free ring buffer

## Breaking Changes
- Remove deprecated v1alpha1 CRD fields (migrationGuide in PR #78)
```

### Example: /explain-for-customer

**Input:**
```
/explain-for-customer OOMKilled error in Kubernetes pod
```

**Output:**
```markdown
## Summary
Your application was shut down because it tried to use more memory
than it was allowed.

## Details
The "OOMKilled" message means "Out of Memory, Killed." Every
application running in your environment has a memory limit set by
your team's configuration. When the application exceeds that limit,
the system stops it automatically to protect other applications
running alongside it.

Common causes:
- The application is processing a larger workload than expected
  (e.g., a bigger dataset or more concurrent users)
- The memory limit is set too low for the application's normal
  operation
- There is a memory leak where the application gradually uses
  more memory over time

Next steps:
1. Check your application logs for what it was doing right before
   the restart
2. Ask your engineering team whether the memory limit (currently
   set in the deployment config) needs to be increased
3. If this happens repeatedly, it may indicate a bug that needs
   investigation

## What This Means for You
- Your application restarted, which may have caused a brief
  interruption in service
- No data was lost on the platform side, but any in-progress
  requests at the time of the restart may need to be retried
- This is a recoverable situation and typically resolved by
  adjusting configuration or fixing the underlying cause
```

### Example: /blog-from-pr

**Input:**
```
/blog-from-pr https://github.com/kubernetes-sigs/llm-d/pull/105
```

**Output:**
```markdown
# Prefix-Aware Routing Lands in llm-d

Large language model inference has a dirty secret: KV cache misses
are expensive. Every time a request lands on a backend that has not
seen the prompt prefix before, the model re-computes attention for
the entire prefix. For long system prompts shared across thousands
of requests, that wasted compute adds up fast.

## What Changed

PR #105 introduces prefix-aware routing to the llm-d scheduler.
The router now hashes incoming prompt prefixes and maintains an
affinity map to backends that already have those prefixes cached.

The key change is in `scheduler/router.go`:

    func (r *Router) selectBackend(req *Request) *Backend {
        prefixHash := hashPrefix(req.Prompt, r.prefixLength)
        if backend, ok := r.affinityMap[prefixHash]; ok {
            return backend
        }
        return r.leastLoaded()
    }

When a matching backend is found, the request goes there. When
not, it falls back to least-loaded selection, which means the
first request with a new prefix still gets balanced normally.

## Why It Matters

In benchmarks included in the PR, prefix-aware routing reduced
median time-to-first-token by 35% for workloads with shared system
prompts. For multi-tenant deployments where many users share the
same base prompt, this eliminates redundant KV cache computation
across backends.

## Getting Started

Prefix-aware routing is off by default. Enable it in your
InferencePool CR:

    spec:
      routing:
        prefixAware:
          enabled: true
          prefixLength: 256
```

## Contributing

Add new commands as markdown files in `.claude/commands/`. Each file becomes a slash command named after the file (minus the `.md` extension). Use `$ARGUMENTS` in the prompt to reference user input.

When writing prompts:
- Include input validation (what if the user provides no arguments?)
- Add a Rules section to prevent common failure modes
- Specify the output format explicitly
- Handle edge cases (empty results, missing data, invalid input)

## License

MIT
