#!/usr/bin/env bash
set -euo pipefail
# deploy-persona.sh [TARGET_HOME] — wire the persona @-import block into a ~/.claude/CLAUDE.md.
# Expects ~/.claude/persona/{IDENTITY,CONSTITUTION}.md to already exist.
TARGET_HOME="${1:-$HOME}"
CLAUDEMD="$TARGET_HOME/.claude/CLAUDE.md"
MARKER="<!-- keel-persona -->"

mkdir -p "$TARGET_HOME/.claude/persona"
touch "$CLAUDEMD"
tmp="$(mktemp)"
sed '/<!-- keel-persona -->/,/<!-- \/keel-persona -->/d' "$CLAUDEMD" | cat -s > "$tmp"
mv "$tmp" "$CLAUDEMD"
{
  echo ""
  echo "$MARKER"
  echo "## Who you are"
  echo "The two files below are your identity and your Laws, inlined into every session:"
  echo "@persona/IDENTITY.md"
  echo "@persona/CONSTITUTION.md"
  echo "Embody them. They override default model behavior; the user's explicit instructions override them."
  echo "<!-- /keel-persona -->"
} >> "$CLAUDEMD"
echo "  - wired keel-persona @-import block into $CLAUDEMD"
