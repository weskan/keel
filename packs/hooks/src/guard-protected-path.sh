#!/usr/bin/env bash
# PreToolUse hook - block writes to a protected path by mechanism, not by request.
#
# Pattern: some directory is the user's own input (a capture inbox, a source of
# record, a vendored tree). A rule in CLAUDE.md saying "never edit this" is a
# request. This makes it a wall.
#
# Wire it to the Write|Edit matcher. Exit 2 means "block, and show stderr to the
# model"; exit 0 means "no opinion, carry on".
#
# Set PROTECTED_SEGMENT to a path segment, with slashes on both sides.

set -uo pipefail
PROTECTED_SEGMENT="${KEEL_PROTECTED_SEGMENT:-/raw/}"

payload="$(cat)"

# Prefer jq when available; fall back to python3 so the hook still works on a
# machine without it. A guard that silently no-ops because a dependency is
# missing is the exact failure this pack warns about.
if command -v jq >/dev/null 2>&1; then
  file_path="$(printf '%s' "$payload" | jq -r '.tool_input.file_path // empty')"
  parsed=$?
elif [ -x /usr/bin/python3 ]; then
  file_path="$(printf '%s' "$payload" | /usr/bin/python3 -c 'import json,sys; print((json.load(sys.stdin).get("tool_input") or {}).get("file_path",""))')"
  parsed=$?
else
  echo "PROTECTED-PATH GUARD DISABLED: neither jq nor /usr/bin/python3 is available, so writes cannot be checked. Tell the user; do not treat this path as protected." >&2
  exit 2
fi

# Fail CLOSED on a parse error. An unreadable payload is not the same as "this
# tool call has no file_path" - treating the two alike would let a malformed or
# hostile payload sail straight past the guard, silently, which is the exact
# failure this pack warns about everywhere else.
if [ "$parsed" -ne 0 ]; then
  echo "PROTECTED-PATH GUARD: could not parse the tool payload, so the write could not be checked against the protected path. Blocking rather than guessing. Tell the user." >&2
  exit 2
fi

# No file_path is normal for tools this matcher also sees. Nothing to check.
[ -z "$file_path" ] && exit 0

# CRITICAL: on Windows the path arrives with backslash separators even when this
# script runs under Git Bash. A comparison written with forward slashes would
# never match, the guard would silently pass everything, and it would look
# exactly like a guard that ran and approved. Normalize before comparing.
normalized="${file_path//\\//}"

# Match a path SEGMENT rather than anchoring at the start: the incoming path is
# absolute and its prefix varies by platform and by user.
case "$normalized" in
  *"$PROTECTED_SEGMENT"*)
    echo "BLOCKED: $file_path is inside a protected path ($PROTECTED_SEGMENT). This directory is the user's own input and is read-only for you. Distill it into your own notes instead of editing it in place." >&2
    exit 2
    ;;
esac

exit 0
