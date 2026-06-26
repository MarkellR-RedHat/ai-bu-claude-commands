#!/usr/bin/env bash
set -euo pipefail

COMMANDS_DIR="$HOME/.claude/commands"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/.claude/commands"

if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: commands directory not found at $SOURCE_DIR"
    exit 1
fi

mkdir -p "$COMMANDS_DIR"

count=0
for cmd in "$SOURCE_DIR"/*.md; do
    if [ -f "$cmd" ]; then
        filename="$(basename "$cmd")"
        cp "$cmd" "$COMMANDS_DIR/$filename"
        echo "Installed: $filename"
        count=$((count + 1))
    fi
done

echo ""
echo "Done. Installed $count commands to $COMMANDS_DIR"
echo "Restart Claude Code or open a new session to use them."
