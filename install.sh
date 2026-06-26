#!/usr/bin/env bash
set -euo pipefail

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RED='\033[0;31m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

# Paths
COMMANDS_DIR="$HOME/.claude/commands"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/.claude/commands"

# Header
echo ""
echo -e "  ${BOLD}AI BU Claude Commands${NC}  ${DIM}12 slash commands for the work after the work${NC}"
echo ""

# Validate source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo -e "  ${RED}Error:${NC} Commands directory not found at ${DIM}$SOURCE_DIR${NC}"
    echo -e "  Run this script from the repository root."
    exit 1
fi

# Validate source has commands
available=$(find "$SOURCE_DIR" -name "*.md" -type f | wc -l | tr -d ' ')
if [ "$available" -eq 0 ]; then
    echo -e "  ${RED}Error:${NC} No .md command files found in ${DIM}$SOURCE_DIR${NC}"
    exit 1
fi

# Create target directory
if ! mkdir -p "$COMMANDS_DIR" 2>/dev/null; then
    echo -e "  ${RED}Error:${NC} Cannot create ${DIM}$COMMANDS_DIR${NC}"
    echo -e "  Check your permissions on ${DIM}$HOME/.claude/${NC}"
    exit 1
fi

# Command descriptions (shown during install)
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
installed=0
skipped=0
updated=0

for cmd in "$SOURCE_DIR"/*.md; do
    [ -f "$cmd" ] || continue

    filename="$(basename "$cmd")"
    target="$COMMANDS_DIR/$filename"
    cmd_name="${filename%.md}"
    desc="${CMD_DESC[$cmd_name]:-}"

    if [ -f "$target" ]; then
        if ! diff -q "$cmd" "$target" > /dev/null 2>&1; then
            echo -e "  ${YELLOW}~${NC}  /${BOLD}${cmd_name}${NC}  ${DIM}${desc}${NC}"
            echo -e "     ${DIM}Your version differs from the repo version.${NC}"
            read -r -p "     Overwrite? [y/N] " response
            case "$response" in
                [yY][eE][sS]|[yY])
                    cp "$cmd" "$target"
                    ((updated++))
                    echo -e "     ${GREEN}Updated${NC}"
                    ;;
                *)
                    ((skipped++))
                    echo -e "     ${BLUE}Kept yours${NC}"
                    ;;
            esac
        else
            ((skipped++))
        fi
    else
        cp "$cmd" "$target"
        ((installed++))
        echo -e "  ${GREEN}+${NC}  /${BOLD}${cmd_name}${NC}  ${DIM}${desc}${NC}"
    fi
done

# Summary
total=$((installed + updated))
echo ""

if [ $total -gt 0 ]; then
    echo -e "  ${GREEN}Done.${NC} Installed ${BOLD}$total${NC} command(s)."
elif [ $skipped -gt 0 ]; then
    echo -e "  ${BLUE}All $available commands are up to date.${NC}"
fi

echo ""
echo -e "  ${BOLD}Try first:${NC}  Open Claude Code and run ${CYAN}/what-next${NC}"
echo ""
