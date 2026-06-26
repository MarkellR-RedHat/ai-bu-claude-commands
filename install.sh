#!/usr/bin/env bash
set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

COMMANDS_DIR="$HOME/.claude/commands"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/.claude/commands"

echo -e "${BOLD}AI BU Claude Commands Installer${NC}"
echo ""

if [ ! -d "$SOURCE_DIR" ]; then
    echo -e "${RED}Error: commands directory not found at $SOURCE_DIR${NC}"
    exit 1
fi

mkdir -p "$COMMANDS_DIR"

installed=()
skipped=()
overwritten=()

for cmd in "$SOURCE_DIR"/*.md; do
    if [ -f "$cmd" ]; then
        filename="$(basename "$cmd")"
        target="$COMMANDS_DIR/$filename"

        if [ -f "$target" ]; then
            # Check if the file content is different
            if ! diff -q "$cmd" "$target" > /dev/null 2>&1; then
                echo -e "${YELLOW}Found existing command: ${BOLD}$filename${NC}"
                read -r -p "  Overwrite? [y/N] " response
                case "$response" in
                    [yY][eE][sS]|[yY])
                        cp "$cmd" "$target"
                        overwritten+=("$filename")
                        echo -e "  ${GREEN}Overwritten${NC}"
                        ;;
                    *)
                        skipped+=("$filename")
                        echo -e "  ${BLUE}Skipped${NC}"
                        ;;
                esac
            else
                echo -e "  ${BLUE}$filename${NC} (already up to date)"
                skipped+=("$filename")
            fi
        else
            cp "$cmd" "$target"
            installed+=("$filename")
            echo -e "  ${GREEN}Installed: $filename${NC}"
        fi
    fi
done

echo ""
echo -e "${BOLD}Results:${NC}"
echo "-------------------------------"

if [ ${#installed[@]} -gt 0 ]; then
    echo -e "${GREEN}Installed (${#installed[@]}):${NC}"
    for f in "${installed[@]}"; do
        cmd_name="${f%.md}"
        echo -e "  ${GREEN}+${NC} /$cmd_name"
    done
fi

if [ ${#overwritten[@]} -gt 0 ]; then
    echo -e "${YELLOW}Overwritten (${#overwritten[@]}):${NC}"
    for f in "${overwritten[@]}"; do
        cmd_name="${f%.md}"
        echo -e "  ${YELLOW}~${NC} /$cmd_name"
    done
fi

if [ ${#skipped[@]} -gt 0 ]; then
    echo -e "${BLUE}Skipped (${#skipped[@]}):${NC}"
    for f in "${skipped[@]}"; do
        cmd_name="${f%.md}"
        echo -e "  ${BLUE}-${NC} /$cmd_name"
    done
fi

total=$(( ${#installed[@]} + ${#overwritten[@]} ))
echo ""
if [ $total -gt 0 ]; then
    echo -e "${GREEN}${BOLD}Done.${NC} $total command(s) installed to $COMMANDS_DIR"
    echo "Restart Claude Code or open a new session to use them."
else
    echo -e "${BLUE}No changes made.${NC} All commands are already up to date."
fi
