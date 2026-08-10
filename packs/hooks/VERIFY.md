# Verify: hooks pack

**You are an AI confirming this install worked.** Run every check. Report PASS,
FAIL, or SKIP for each, then the summary table.

A hook that is installed but not firing is the exact failure mode this pack
exists to prevent — so "the file is there" is not evidence. Check 4 is the one
that matters.

---

## Check 1 — The script exists and is executable

macOS / Linux:

```bash
test -x ~/.claude/hooks/inject-memory-index.sh && echo PASS || echo FAIL
```

Windows:

```powershell
Test-Path "$env:USERPROFILE\.claude\hooks\inject-memory-index.ps1"
```

FAIL → re-run INSTALL Step 2.

---

## Check 2 — The script emits valid JSON, and nothing before it

**Do not use `python3` on Windows for this.** A default Windows box has only the
zero-byte Microsoft Store stub on PATH, so `python3 -m json.tool` fails on a
perfectly correct install and you will chase a bug that is not there. Use the
platform's own JSON parser.

macOS / Linux:

```bash
bash ~/.claude/hooks/inject-memory-index.sh | python3 -m json.tool > /dev/null && echo PASS || echo FAIL
```

Windows — `ConvertFrom-Json` is built in, no dependency:

```powershell
$out = powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$env:USERPROFILE\.claude\hooks\inject-memory-index.ps1"
try { $null = $out | ConvertFrom-Json; "PASS" } catch { "FAIL: $_" }
if ($out.Substring(0,1) -ne '{') { "FAIL - output does not start with {" }
```

FAIL usually means something is printing before the JSON — a shell profile
banner, a version-manager warning, a stray `echo`. Find it and silence it. Do
not work around it by having the hook swallow its own output.

---

## Check 3 — settings.json is valid and preserved the user's other keys

macOS / Linux:

```bash
python3 -m json.tool < ~/.claude/settings.json > /dev/null && echo "JSON OK"
```

Windows:

```powershell
try { $null = Get-Content -Raw "$env:USERPROFILE\.claude\settings.json" | ConvertFrom-Json; "JSON OK" } catch { "INVALID: $_" }
```

Then compare against the backup:

```bash
python3 - <<'PY'
import json, pathlib
new = json.loads(pathlib.Path.home().joinpath(".claude/settings.json").read_text())
bak = pathlib.Path.home().joinpath(".claude/settings.json.bak")
if not bak.exists():
    print("SKIP - no backup, fresh install")
else:
    old = json.loads(bak.read_text())
    lost = [k for k in old if k not in new]
    print("FAIL - keys lost in merge:", lost) if lost else print("PASS - all prior keys survived")
    oldhooks = set((old.get("hooks") or {}).keys())
    newhooks = set((new.get("hooks") or {}).keys())
    missing = oldhooks - newhooks
    print("FAIL - prior hook events dropped:", missing) if missing else print("PASS - prior hook events intact")
PY
```

FAIL → restore from `~/.claude/settings.json.bak` and redo the merge as an
addition, not a replacement.

---

## Check 4 — It actually fires in a live session

**This is the check that counts.** The previous three prove the parts exist;
this proves the harness runs them.

Ask the user to start a **fresh** session — `SessionStart` does not re-fire in
the session you are currently in — and to ask their AI:

> Quote the first three lines of the global memory index you were given.

- **PASS** — it quotes lines that match `~/.claude/memory/MEMORY.md`.
- **FAIL** — it says it has no index, or describes reading the file itself
  rather than being handed it. The hook is not firing. Check the platform entry
  matches the machine, and on Windows confirm which shell is actually running
  the command.

---

## Check 5 — Failure paths are loud (fault injection)

Confirm the health-reporting actually works, by breaking it on purpose:

```bash
KEEL_MEMORY_DIR=/tmp/keel-does-not-exist bash ~/.claude/hooks/inject-memory-index.sh
```

- **PASS** — output is JSON containing a `WARNING: MEMORY SYSTEM BROKEN` message.
- **FAIL** — empty output, or a bare non-zero exit with no message.

A silent failure here means that if the user's memory root ever disappears,
nothing will tell them. Do not accept a FAIL on this check.

---

## Summary

| Check | What it confirms |
|---|---|
| 1 | The script is installed and executable |
| 2 | It emits clean JSON with no leading noise |
| 3 | settings.json is valid and no prior keys or hooks were lost |
| 4 | The harness actually fires it in a fresh session |
| 5 | Failure paths report loudly instead of vanishing |

Checks 1–4 must PASS. Check 5 must PASS for the install to be trustworthy —
it is the difference between a memory system that works and one that only
appears to.
