#!/usr/bin/env bash
set -euo pipefail

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

# Paths
COMMANDS_DIR="$HOME/.claude/commands"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/.claude/commands"

# Header
echo ""
echo -e "  ${BOLD}AI BU Claude Commands${NC}"
echo -e "  ${DIM}Red Hat AI Business Unit${NC}"
echo ""

# Validate source
if [ ! -d "$SOURCE_DIR" ]; then
    echo -e "  ${YELLOW}Could not find commands at${NC} ${DIM}$SOURCE_DIR${NC}"
    echo -e "  Run this from the repo root."
    exit 1
fi

available=$(find "$SOURCE_DIR" -name "*.md" -type f | wc -l | tr -d ' ')
echo -e "  ${DIM}$available commands${NC} ${DIM}-> ${NC}${DIM}$COMMANDS_DIR${NC}"
echo ""

mkdir -p "$COMMANDS_DIR"

# Command descriptions for post-install display
declare -A CMD_DESC
CMD_DESC[what-next]="Find your highest-impact task right now"
CMD_DESC[release-notes]="Generate release notes from git history"
CMD_DESC[changelog]="Create a CHANGELOG.md entry"
CMD_DESC[draft-announcement]="Write Slack, blog, social, and email versions"
CMD_DESC[blog-from-pr]="Turn a PR into a blog post"
CMD_DESC[demo-prep]="Prep doc with talking points and fallbacks"
CMD_DESC[explain-for-customer]="Translate technical concepts for any audience"
CMD_DESC[competitive-snapshot]="Evidence-based competitive analysis"
CMD_DESC[summarize-thread]="Summarize a GitHub issue or PR thread"
CMD_DESC[retro]="Data-driven sprint retrospective"
CMD_DESC[tldr-repo]="5-minute briefing on an unfamiliar repo"
CMD_DESC[write-docs]="Generate inline docs and markdown reference"

# Install loop
installed=()
skipped=()
overwritten=()

for cmd in "$SOURCE_DIR"/*.md; do
    if [ -f "$cmd" ]; then
        filename="$(basename "$cmd")"
        target="$COMMANDS_DIR/$filename"
        cmd_name="${filename%.md}"

        if [ -f "$target" ]; then
            if ! diff -q "$cmd" "$target" > /dev/null 2>&1; then
                echo -e "  ${YELLOW}~${NC}  ${BOLD}/$cmd_name${NC} ${DIM}(yours differs)${NC}"
                read -r -p "     Overwrite? [y/N] " response
                case "$response" in
                    [yY][eE][sS]|[yY])
                        cp "$cmd" "$target"
                        overwritten+=("$filename")
                        echo -e "     ${GREEN}Updated${NC}"
                        ;;
                    *)
                        skipped+=("$filename")
                        echo -e "     ${BLUE}Kept yours${NC}"
                        ;;
                esac
            else
                skipped+=("$filename")
            fi
        else
            cp "$cmd" "$target"
            installed+=("$filename")
            echo -e "  ${GREEN}+${NC}  ${BOLD}/$cmd_name${NC}"
        fi
    fi
done

# Results
total=$(( ${#installed[@]} + ${#overwritten[@]} ))
echo ""

if [ $total -gt 0 ]; then
    echo -e "  ${GREEN}Installed $total command(s).${NC}"
else
    echo -e "  ${BLUE}All $available commands are up to date.${NC}"
fi

echo ""
echo -e "  ${BOLD}Your commands:${NC}"
echo ""

for cmd in "$COMMANDS_DIR"/*.md; do
    if [ -f "$cmd" ]; then
        cmd_name="$(basename "${cmd%.md}")"
        desc="${CMD_DESC[$cmd_name]:-}"
        if [ -n "$desc" ]; then
            printf "    ${CYAN}/%-24s${NC} ${DIM}%s${NC}\n" "$cmd_name" "$desc"
        else
            echo -e "    ${CYAN}/$cmd_name${NC}"
        fi
    fi
done

echo ""
echo -e "  ${BOLD}Try first:${NC}  Open Claude Code and run ${CYAN}/what-next${NC}"
echo -e "  ${DIM}It scans your open PRs, issues, and branches, then tells you${NC}"
echo -e "  ${DIM}the single most impactful thing to work on right now.${NC}"
echo ""
