#!/usr/bin/env bash
# Wrapper for an unattended agent job.
#
# Everything here exists because a scheduled job runs in a different world than
# your terminal: minimal environment, no graphical session, no human to see a
# failure. Each section below is one of those differences, handled explicitly.
#
# Replace the ${PLACEHOLDER} values before use.

set -uo pipefail

# --- 1. Absolute paths, always ------------------------------------------------
# A scheduled job does not inherit your interactive PATH or your shell profile,
# so a bare command name that works when you type it may not resolve here. Pin
# the interpreter and set PATH explicitly rather than hoping it is inherited.
AGENT_BIN="${AGENT_BIN:-${AGENT_BIN_PATH}}"     # e.g. /usr/local/bin/your-agent
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

LOG_DIR="${LOG_DIR:-$HOME/.agent/logs}"
LOG="$LOG_DIR/${JOB_NAME}.log"
mkdir -p "$LOG_DIR"

log() { printf '%s %s\n' "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" "$1" >> "$LOG"; }

# --- 2. Notify a human when it breaks ----------------------------------------
# A scheduled failure has no audience. Route it somewhere a person actually
# looks. Replace this with a real channel - a message, an email, a webhook. The
# default deliberately writes a marker file rather than doing nothing, so a
# missing notifier is itself discoverable.
notify_failure() {
  local msg="$1"
  log "FAILURE: $msg"
  : > "$LOG_DIR/${JOB_NAME}.FAILED"
  # ${NOTIFY_COMMAND} "$msg"
}

# --- 3. Do not run two copies at once ----------------------------------------
# A job that takes longer than its interval will otherwise stack up copies of
# itself until the machine is on its knees.
LOCK="$LOG_DIR/${JOB_NAME}.lock"
if ! mkdir "$LOCK" 2>/dev/null; then
  log "SKIP: previous run still in progress"
  exit 0
fi
trap 'rmdir "$LOCK" 2>/dev/null' EXIT

# --- 4. Fail loudly, with the OS-permission hint -----------------------------
# The single most common cause of "works by hand, fails on schedule" is a
# missing OS privacy grant for the binary that actually executes. Say so in the
# failure message, because the raw error almost never does.
log "START"

if [ ! -x "$AGENT_BIN" ]; then
  notify_failure "$AGENT_BIN is not executable or not found. A scheduled job does not inherit your interactive PATH - use an absolute path."
  exit 1
fi

if ! "$AGENT_BIN" ${AGENT_ARGS} >> "$LOG" 2>&1; then
  rc=$?
  notify_failure "job exited $rc. If this same command succeeds when run by hand in a terminal, suspect a missing OS permission grant for $AGENT_BIN (local network, Documents, external volumes) before suspecting the code - a background job has no graphical session and cannot prompt for one."
  exit $rc
fi

log "OK"
