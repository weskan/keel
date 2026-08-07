#!/usr/bin/env bash
# SessionStart hook — inject the global memory index into every session, and
# announce its own health, loudly, in-context.
#
# WHY THIS EXISTS
# The harness auto-injects only the project-local memory directory. A global
# memory root is never loaded automatically, so "read the global index at
# session start" is an instruction the model has to remember — which fails
# silently and indefinitely. This makes it a harness guarantee instead.
#
# WHY IT SELF-REPORTS
# A memory system that dies quietly keeps looking healthy: the agent still
# answers, just from its priors instead of your notes. Do NOT add a separate
# monitor to watch this script — a monitor can die just as quietly. Instead the
# load-bearing thing announces its own health in the one place read every
# session. Every failure path below emits a VISIBLE warning; none exit silently.
#
# DEPENDENCIES
# /usr/bin/python3 is pinned deliberately: it is the system interpreter, always
# present on macOS, and not managed by a version manager. A bare `python3`
# resolves differently in an interactive shell than in the clean environment a
# hook runs in — and that ambiguity is a silent-break vector. If it is missing
# we degrade to plain stdout rather than emitting nothing at all.

MEM_DIR="${KEEL_MEMORY_DIR:-$HOME/.claude/memory}"
INDEX="$MEM_DIR/MEMORY.md"
PY=/usr/bin/python3

# Emit text as SessionStart additionalContext. Falls back to plain stdout (also
# accepted by the harness) if the pinned interpreter is gone, so a broken
# dependency still surfaces instead of vanishing.
emit() {
  if [ -x "$PY" ]; then
    MEMTEXT="$1" "$PY" -c 'import json,os,sys; sys.stdout.write(json.dumps({"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":os.environ["MEMTEXT"]}}))'
  else
    printf '%s\n' "$1"
  fi
}

# --- Failure paths: loud, never silent ---------------------------------------
# Guard the interpreter first: without it the success path would emit nothing at
# all, which is precisely the silent failure this hook exists to prevent.
if [ ! -x "$PY" ]; then
  printf '%s\n' "WARNING: MEMORY SYSTEM BROKEN - $PY is missing, so the global memory index could not be loaded.
Cross-project memory (preferences, durable feedback, domain knowledge) is absent from this session.
Tell the user; do not assume recall is working."
  exit 0
fi

if [ ! -d "$MEM_DIR" ]; then
  emit "WARNING: MEMORY SYSTEM BROKEN - the global memory root $MEM_DIR does not exist.
This tier holds cross-project preferences, feedback, and domain knowledge. It is NOT
auto-injected by the harness, so its absence is otherwise invisible.
Tell the user before relying on recall this session; do not silently proceed as if memory were intact."
  exit 0
fi

if [ ! -s "$INDEX" ]; then
  emit "WARNING: MEMORY SYSTEM DEGRADED - the global index $INDEX is missing or empty,
though $MEM_DIR exists. Leaf memories may still be present but are now unindexed and
effectively unreachable. Rebuild the index from the tree and tell the user.
Do not assume recall is working this session."
  exit 0
fi

# --- Success path: emit index + flag any rot ---------------------------------
# The broken-link check enforces "verify before acting on memory" at the system
# level: an index entry naming a file that no longer exists is stale recall
# waiting to happen.
MEMDIR="$MEM_DIR" INDEXFILE="$INDEX" "$PY" - <<'PY'
import json, os, re, pathlib

memdir = pathlib.Path(os.environ["MEMDIR"])
index = pathlib.Path(os.environ["INDEXFILE"])
body = index.read_text(encoding="utf-8", errors="replace")

# Markdown links to local .md files, e.g. [Title](domain/topic.md)
broken = []
for target in re.findall(r"\]\(([^)]+\.md)\)", body):
    if target.startswith(("http://", "https://", "#")):
        continue
    if not (memdir / target).exists():
        broken.append(target)

header = (
    f"Contents of {index} (GLOBAL cross-project memory index - spans every project, "
    "not just this working directory).\n\n"
    "This is an INDEX, not content. Proactively open the leaf files whose one-line hooks "
    "match the current task BEFORE starting work - the actionable detail lives in the "
    "leaves. Verify any file or symbol a memory names still exists before acting on it. "
    "When you state a fact that came from memory, cite the file it came from.\n\n"
)

if broken:
    header += (
        "WARNING: MEMORY INDEX ROT - these indexed files no longer exist:\n"
        + "".join(f"  - {b}\n" for b in broken)
        + "Do not cite them as sources. Surface this to the user and repair the index.\n\n"
    )

print(json.dumps({
    "hookSpecificOutput": {
        "hookEventName": "SessionStart",
        "additionalContext": header + body,
    }
}))
PY
