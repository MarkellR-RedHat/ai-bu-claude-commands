#!/usr/bin/env bash
set -euo pipefail

# ─── Colors ──────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

# ─── Paths ───────────────────────────────────────────────────────────
COMMANDS_DIR="$HOME/.claude/commands"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/.claude/commands"

# ─── Header ──────────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}${CYAN}  ┌──────────────────────────────────────────────┐${NC}"
echo -e "${BOLD}${CYAN}  │    AI BU Claude Commands Installer          │${NC}"
echo -e "${BOLD}${CYAN}  │    Red Hat AI Business Unit                  │${NC}"
echo -e "${BOLD}${CYAN}  └──────────────────────────────────────────────┘${NC}"
echo ""

# ─── Validate source ─────────────────────────────────────────────────
if [ ! -d "$SOURCE_DIR" ]; then
    echo -e "  ${RED}Error:${NC} Commands directory not found at ${DIM}$SOURCE_DIR${NC}"
    echo -e "  Make sure you are running this from the repo root."
    exit 1
fi

# Count available commands
available=$(find "$SOURCE_DIR" -name "*.md" -type f | wc -l | tr -d ' ')
echo -e "  ${DIM}Found ${BOLD}$available${NC}${DIM} commands to install${NC}"
echo -e "  ${DIM}Target: $COMMANDS_DIR${NC}"
echo ""

mkdir -p "$COMMANDS_DIR"

# ─── Install loop ────────────────────────────────────────────────────
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
                echo -e "  ${YELLOW}~${NC}  ${BOLD}/$cmd_name${NC} ${DIM}(local copy differs)${NC}"
                read -r -p "     Overwrite with new version? [y/N] " response
                case "$response" in
                    [yY][eE][sS]|[yY])
                        cp "$cmd" "$target"
                        overwritten+=("$filename")
                        echo -e "     ${GREEN}Updated${NC}"
                        ;;
                    *)
                        skipped+=("$filename")
                        echo -e "     ${BLUE}Kept existing${NC}"
                        ;;
                esac
            else
                skipped+=("$filename")
                echo -e "  ${DIM}-${NC}  ${DIM}/$cmd_name (up to date)${NC}"
            fi
        else
            cp "$cmd" "$target"
            installed+=("$filename")
            echo -e "  ${GREEN}+${NC}  ${BOLD}/$cmd_name${NC} ${GREEN}installed${NC}"
        fi
    fi
done

# ─── Results ─────────────────────────────────────────────────────────
echo ""
echo -e "  ${BOLD}────────────────────────────────────────────${NC}"

if [ ${#installed[@]} -gt 0 ]; then
    echo -e "  ${GREEN}New:${NC}       ${#installed[@]} command(s)"
fi

if [ ${#overwritten[@]} -gt 0 ]; then
    echo -e "  ${YELLOW}Updated:${NC}   ${#overwritten[@]} command(s)"
fi

if [ ${#skipped[@]} -gt 0 ]; then
    echo -e "  ${DIM}Unchanged: ${#skipped[@]} command(s)${NC}"
fi

total=$(( ${#installed[@]} + ${#overwritten[@]} ))
echo ""

if [ $total -gt 0 ]; then
    echo -e "  ${GREEN}${BOLD}Done.${NC} $total command(s) installed to ${DIM}$COMMANDS_DIR${NC}"
    echo ""
    echo -e "  ${BOLD}Quick start:${NC} Open Claude Code and type ${CYAN}/${NC} to see all commands."
    echo -e "  Try ${CYAN}/what-next${NC} to find your highest-impact task."
    echo ""
else
    echo -e "  ${BLUE}No changes.${NC} All $available commands are already up to date."
    echo ""
fi

# ─── List all available commands ─────────────────────────────────────
echo -e "  ${BOLD}Available commands:${NC}"
echo ""
for cmd in "$COMMANDS_DIR"/*.md; do
    if [ -f "$cmd" ]; then
        cmd_name="$(basename "${cmd%.md}")"
        echo -e "    ${CYAN}/${cmd_name}${NC}"
    fi
done
echo ""
