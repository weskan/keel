# Verify: bounded-profile pack

You are an AI verifying that the bounded-profile pack installed correctly. Run each check in order and report PASS or FAIL with a brief note.

---

## Check 1 — settings.json exists and is valid JSON

```bash
python3 -m json.tool ~/.claude/settings.json > /dev/null && echo PASS || echo FAIL
```

Expected: `PASS`. If FAIL: the file is missing or malformed — rerun Step 5 of INSTALL.md. Do not proceed with other checks until this passes.

---

## Check 2 — deny floor contains the destructive minimum

Check that all four baseline deny entries are present:

```bash
python3 - <<'EOF'
import json, sys
with open(os.path.expanduser("~/.claude/settings.json")) as f:
    s = json.load(f)
import os
deny = s.get("permissions", {}).get("deny", [])
required = [
    "Bash(rm -rf:*)",
    "Bash(rm -r:*)",
    "Bash(sudo:*)",
    "Bash(git push --force:*)"
]
missing = [r for r in required if r not in deny]
if missing:
    print("FAIL — missing from deny:", missing)
else:
    print("PASS")
EOF
```

Expected: `PASS`. If FAIL: the deny floor was not set correctly — rerun Step 3 of INSTALL.md and re-merge.

---

## Check 3 — allow contains no bare Bash wildcard

A bare `Bash` or `Bash(*)` in `allow` defeats the model. Verify neither is present:

```bash
python3 - <<'EOF'
import json, os
with open(os.path.expanduser("~/.claude/settings.json")) as f:
    s = json.load(f)
allow = s.get("permissions", {}).get("allow", [])
bad = [e for e in allow if e in ("Bash", "Bash(*)", "Bash(*:*)", "*")]
if bad:
    print("FAIL — overly broad allow entries found:", bad)
else:
    print("PASS")
EOF
```

Expected: `PASS`. If FAIL: remove or narrow the flagged entries and re-merge.

---

## Check 4 — pre-existing non-permission settings survived the merge

If the user had existing settings (hooks, statusLine, model, theme, etc.) before install, verify they are still present.

```bash
python3 - <<'EOF'
import json, os

backup = os.path.expanduser("~/.claude/settings.json.bak")
current = os.path.expanduser("~/.claude/settings.json")

if not os.path.exists(backup):
    print("SKIP — no backup found (fresh install, nothing to compare)")
else:
    with open(backup) as f:
        old = json.load(f)
    with open(current) as f:
        new = json.load(f)

    non_perms_old = {k: v for k, v in old.items() if k != "permissions"}
    missing = [k for k in non_perms_old if k not in new]
    changed = [k for k in non_perms_old if k in new and new[k] != non_perms_old[k]]

    if missing:
        print("FAIL — keys from backup are missing in current settings:", missing)
    elif changed:
        print("FAIL — keys from backup have changed unexpectedly:", changed)
    else:
        print("PASS — all pre-existing non-permission settings preserved")
EOF
```

Expected: `PASS` or `SKIP`. If FAIL: a merge error dropped the user's existing settings — restore from backup (`cp ~/.claude/settings.json.bak ~/.claude/settings.json`) and rerun Step 5 of INSTALL.md carefully.

---

## Check 5 — deny does not overlap with allow

A deny entry in allow is still blocked (deny wins), but it signals a composition error worth flagging:

```bash
python3 - <<'EOF'
import json, os
with open(os.path.expanduser("~/.claude/settings.json")) as f:
    s = json.load(f)
perms = s.get("permissions", {})
allow_set = set(perms.get("allow", []))
deny_set = set(perms.get("deny", []))
overlap = allow_set & deny_set
if overlap:
    print("WARN — entries appear in both allow and deny (deny wins, but review intent):", overlap)
else:
    print("PASS — no overlap between allow and deny")
EOF
```

Expected: `PASS`. A `WARN` is not a hard failure (deny always wins), but review whether the overlapping entries should be removed from `allow` to avoid confusion.

---

## Summary

| Check | What it confirms |
|---|---|
| 1 | settings.json exists and is valid JSON |
| 2 | Destructive deny floor is in place |
| 3 | No bare-Bash wildcard in allow |
| 4 | Pre-existing non-permission settings survived |
| 5 | No confusing allow/deny overlap |

Checks 1–3 must PASS for the profile to be safe. Check 4 must PASS or SKIP (SKIP is correct for fresh installs). Check 5 WARN is acceptable but worth reviewing.
