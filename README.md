# ai-bu-claude-commands

A collection of custom slash commands for Claude Code, built for the AI BU team at Red Hat.

These commands handle common tasks that come up in engineering work: writing release notes, prepping demos, explaining technical concepts to customers, running competitive analysis, and turning PRs into blog posts.

## Installation

Clone the repo and run the install script:

```bash
git clone https://github.com/MarkellR-RedHat/ai-bu-claude-commands.git
cd ai-bu-claude-commands
chmod +x install.sh
./install.sh
```

This copies the command files to `~/.claude/commands/`, which makes them available globally in Claude Code as slash commands.

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

## Contributing

Add new commands as markdown files in `.claude/commands/`. Each file becomes a slash command named after the file (minus the `.md` extension). Use `$ARGUMENTS` in the prompt to reference user input.

## License

MIT
