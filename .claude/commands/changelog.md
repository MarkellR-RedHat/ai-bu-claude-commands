You are generating a CHANGELOG.md entry following the Keep a Changelog format (https://keepachangelog.com).

The user will provide a repo path, a version number, and optionally a git ref range. Parse these from the following input:

$ARGUMENTS

## Input Validation

At minimum, a repo path and version number are required. If the user does not provide a git ref range, use the two most recent tags. If there are no tags, use the full commit history and warn the user.

Before running any git commands, verify:
1. The repo path exists and is a git repository.
2. If refs are provided, both are valid by running `git rev-parse --verify <ref>` for each. If either ref is invalid, tell the user exactly which ref failed and stop.

## Steps

1. Navigate to the repo path.
2. Determine the git range to analyze:
   - If the user provided start and end refs, use those.
   - If only a version is provided, find the previous tag with `git describe --tags --abbrev=0 HEAD~1` or equivalent and use that as the start ref with HEAD as the end.
3. Run `git log --oneline --no-merges <start>..<end>` to get commits.
4. If the log is empty, tell the user there are no changes to report and stop.
5. Run `git diff --stat <start>..<end>` for scope context.
6. Classify each change into Keep a Changelog categories:
   - Added (new features)
   - Changed (changes to existing functionality)
   - Deprecated (features that will be removed)
   - Removed (features that were removed)
   - Fixed (bug fixes)
   - Security (vulnerability fixes)
7. Omit any category with no entries.

## Output Format

Output exactly this format:

```
## [X.Y.Z] - YYYY-MM-DD

### Added
- Description of new feature

### Changed
- Description of change to existing functionality

### Fixed
- Description of bug fix

(other categories as applicable)
```

Use ISO 8601 date format (YYYY-MM-DD). Use today's date unless the user specifies otherwise.

## Rules

- Follow Keep a Changelog format strictly. The categories, ordering, and heading format must match the spec.
- Each entry should be a single clear sentence starting with a verb (e.g., "Add support for...", "Fix crash when...", "Remove deprecated...").
- Only describe changes that appear in the git log. Never invent changes.
- If a commit message is unclear, write "Unclear change (see commit <sha>)" rather than guessing.
- Do not include merge commits.
- If an existing CHANGELOG.md file exists in the repo, read it first and format the new entry to match its existing style.
