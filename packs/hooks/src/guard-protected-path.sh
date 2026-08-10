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

# Empty stdin is NOT "a call with no file_path" - it is a payload we never saw.
# jq treats it as success with empty output, so without this check a truncated
# or dropped payload looks exactly like an approved write. Block it.
if [ -z "${payload//[[:space:]]/}" ]; then
  echo "PROTECTED-PATH GUARD: received an empty tool payload, so the write could not be checked. Blocking rather than guessing." >&2
  exit 2
fi

# Three tiers, in order of reliability. The third exists so a stock machine with
# neither jq nor a system python - the default state of a fresh Windows box -
# still gets a working guard instead of one that blocks every write on the
# machine. See the DEPENDENCIES note in INSTALL.md.
file_path=""
parsed=1

if command -v jq >/dev/null 2>&1; then
  file_path="$(printf '%s' "$payload" | jq -r '.tool_input.file_path // empty')"
  parsed=$?
elif [ -x /usr/bin/python3 ]; then
  file_path="$(printf '%s' "$payload" | /usr/bin/python3 -c 'import json,sys; print((json.load(sys.stdin).get("tool_input") or {}).get("file_path",""))')"
  parsed=$?
elif command -v python3 >/dev/null 2>&1; then
  file_path="$(printf '%s' "$payload" | python3 -c 'import json,sys; print((json.load(sys.stdin).get("tool_input") or {}).get("file_path",""))')"
  parsed=$?
else
  # Last resort: extract the one field we need with sed. Deliberately narrow -
  # it reads the first "file_path": "..." value, honouring backslash escapes.
  # If the payload does not look like it contains the field at all, we fall
  # through to the fail-closed branch below rather than assuming absence.
  if printf '%s' "$payload" | grep -q '"file_path"[[:space:]]*:'; then
    # Portable BRE only - no \| alternation, which BSD sed does not support and
    # which silently yields an empty match there. A path containing a literal
    # escaped quote is not handled, and is caught by the fail-closed check below.
    file_path="$(printf '%s' "$payload" \
      | sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' \
      | head -1)"
    # Unescape the two sequences that appear in real Windows and POSIX paths.
    file_path="${file_path//\\\\/\\}"
    file_path="${file_path//\\\//\/}"

    # The field was present but we could not read a value out of it. That is a
    # parser failure, NOT an absent field - and the difference matters, because
    # falling through with an empty file_path would hit the "nothing to check"
    # exit below and wave the write straight through.
    if [ -z "$file_path" ]; then
      echo "PROTECTED-PATH GUARD: a file_path field is present but could not be read without jq or python3. Blocking rather than guessing.
Install jq (or python3) and start a new session, or delete the PreToolUse block from settings.json to remove this guard." >&2
      exit 2
    fi
    parsed=0
  else
    parsed=0   # field genuinely absent - normal for tools with no file_path
    file_path=""
  fi
fi

# Fail CLOSED on a parse error. An unreadable payload is not the same as "this
# tool call has no file_path" - treating the two alike would let a malformed or
# hostile payload sail straight past the guard, silently, which is the exact
# failure this pack warns about everywhere else.
if [ "$parsed" -ne 0 ]; then
  echo "PROTECTED-PATH GUARD: could not parse the tool payload, so the write could not be checked against the protected path. Blocking rather than guessing.
To remove this guard: delete the PreToolUse block from your settings.json and start a new session." >&2
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
