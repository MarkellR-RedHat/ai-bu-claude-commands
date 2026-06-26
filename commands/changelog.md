You are helping someone who needs to ship a changelog entry before they can cut a release. They probably have 10 other things on their plate and this feels like paperwork, but they know that a good changelog is the difference between users upgrading confidently and users staying on the old version because they cannot tell what changed.

Your job: read git history, classify changes, and produce a Keep a Changelog entry (https://keepachangelog.com/en/1.1.0/) that respects the reader's time.

## How to think about this

Before classifying any change, ask: if I were deciding whether to upgrade a production system, would this entry help me make that call? If not, rewrite it until it does.

A mediocre entry: "Update scheduler logic."
A great entry: "Fix race condition in scheduler queue that caused duplicate pod assignments under concurrent scale-up events (#212)."
The first tells you nothing. The second tells you whether this bug affects you.

Changelog entries should read like git commit messages written by someone who respects the reader's time. No marketing. No filler. Every word earns its place.

## Input

Parse the repo path, version, and optional ref range from:

$ARGUMENTS

Formats: `<repo-path> <version>` or `<repo-path> <version> <start>..<end>`. If repo path or version is missing, say what is needed and stop.

## Step 1: Validate

1. Confirm the repo path contains a `.git` directory. If not, stop.
2. If refs were provided, run `git rev-parse --verify` on each. Name the invalid ref and stop if either fails.
3. If no ref range was provided: run `git tag --sort=-version:refname`. Use the two most recent tags as the range. If one tag exists, use `<tag>..HEAD`. If no tags exist, use `$(git rev-list --max-parents=0 HEAD)..HEAD` and warn the user the entry covers the entire history.

## Step 2: Gather changes

1. Run `git log --oneline --no-merges <start>..<end>`. If empty, say so and stop.
2. Run `git diff --stat <start>..<end>` for scope context.
3. For unclear commit messages, run `git show --stat <sha>` and use filenames to inform classification.

## Step 3: Classify each change

Assign every commit to exactly one category:
- **Added**: new features, CLI flags, API endpoints, config options
- **Changed**: modified existing behavior, updated dependencies, behavioral refactors
- **Deprecated**: features marked for removal, deprecation warnings added
- **Removed**: deleted features, dropped platform support, removed flags
- **Fixed**: bug fixes, crash fixes, correctness fixes
- **Security**: patched CVEs, hardened auth, fixed vulnerability

If a commit spans multiple categories, split it into separate entries.

## Step 4: Write entries that help people make upgrade decisions

Rewrite each commit into a changelog entry. The person reading this is trying to figure out whether to upgrade, what will break, and what they gain. Write for them.

1. Start with a present-tense verb: Add, Change, Fix, Remove, Deprecate, Update, Drop, Patch, Harden.
2. Describe user-visible impact, not implementation. "Fix race condition in scheduler queue" not "Add mutex to goroutine." The reader does not care about your mutex. They care that pods were getting double-scheduled.
3. Include PR/issue refs in parentheses at the end: `(#142)`.
4. One sentence per entry. If it needs two, split it into two entries.
5. If a commit is genuinely unclear after checking the diff, write: "Unclear change; see commit `<short-sha>` for details." Do not guess.

## Step 5: Match existing style

Look for CHANGELOG.md, CHANGELOG, CHANGES.md, or HISTORY.md in the repo root. If found, read the most recent entry and match its heading style, bullet style, PR link format, and attribution conventions. If the existing format differs from Keep a Changelog, note the mismatch to the user but still produce Keep a Changelog format.

## Step 6: Self-critique

You are not done when you have entries. You are done when every entry would survive a code review from someone who has shipped dozens of changelogs. Before outputting, verify and fix any violations:

- Every entry starts with a verb. None begin with "The," "This," or a noun.
- No entry is a verbatim copy of a commit message. Each is rewritten for clarity.
- Empty categories are omitted. No heading appears without bullets beneath it.
- Date is ISO 8601 (YYYY-MM-DD). No passive voice. No merge commits.
- No filler. Two changes means two bullets, not five. Padding a thin release insults the reader.
- No unexplained jargon. Category order: Added, Changed, Deprecated, Removed, Fixed, Security.
- No em dashes anywhere in the output.

## Output format

```markdown
## [<version>] - YYYY-MM-DD

### Added
- Add `--dry-run` flag to the deploy command (#225)

### Fixed
- Fix token refresh loop causing excessive API calls under concurrency (#212)
```

Use today's date unless the user specifies otherwise. Omit categories with zero entries.

## Edge cases

- **No commits:** State it and stop. Do not produce an empty entry.
- **80+ commits:** Group by theme instead of listing individually. Note the summarization.
- **No tags, no ref range:** Use full history with a prominent warning. Suggest tagging releases.
- **Style mismatch:** Produce Keep a Changelog format and note the difference for the user.

## Rules

Do not use passive voice. Do not include merge commits. Do not pad thin releases with filler. Do not include internal jargon without explanation. Do not invent changes; every entry must trace to the git log. Do not use em dashes. Every entry exists to help someone decide whether to upgrade.
