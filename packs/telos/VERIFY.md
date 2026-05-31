# Verify: telos pack

You are an AI verifier. Run each check below. Report PASS or FAIL for each, then a final summary line: "All checks PASS" or "N check(s) FAILED — see above."

---

## Check 1 — telos.md exists

Replace `$TELOS_PATH` with the actual path used during installation (default: `~/.claude/memory/telos.md`).

```bash
test -f "$TELOS_PATH" && echo PASS || echo FAIL
```

Expected: `PASS`

---

## Check 2 — All six sections are present

```bash
for section in "## Mission" "## Active threads" "## Values" "## What good looks like" "## Constraints" "## Context map"; do
  grep -qF "$section" "$TELOS_PATH" && echo "PASS: $section" || echo "FAIL: $section missing"
done
```

Expected: `PASS` for all six lines.

---

## Check 3 — No unfilled placeholders remain

```bash
grep -q '\${' "$TELOS_PATH" && echo FAIL || echo PASS
```

Expected: `PASS` (no `${...}` remaining in the file)

---

## Check 4 — No HTML comments remain

```bash
grep -q '<!--' "$TELOS_PATH" && echo FAIL || echo PASS
```

Expected: `PASS` (interview-question comments were removed when filling the template)

---

## Check 5 — Steering instruction is wired in

Check whichever file was used as the target (CONSTITUTION.md if persona pack is installed, otherwise CLAUDE.md):

```bash
# If persona pack is installed:
grep -q 'keel-telos' ~/.claude/persona/CONSTITUTION.md && echo PASS || echo FAIL

# If persona pack is not installed:
grep -q 'keel-telos' ~/.claude/CLAUDE.md && echo PASS || echo FAIL
```

Expected: `PASS` in whichever file applies.

---

## Check 6 — Steering instruction references the correct telos path

```bash
grep -A5 'keel-telos' ~/.claude/persona/CONSTITUTION.md 2>/dev/null || \
grep -A5 'keel-telos' ~/.claude/CLAUDE.md 2>/dev/null | grep -q "$TELOS_PATH" && echo PASS || echo FAIL
```

Expected: `PASS` (the wired instruction points to the same path as the written telos file)

---

## If any check fails

- **Check 1 fails**: Return to INSTALL.md Step 2 and write the TELOS file.
- **Check 2 fails**: Open the TELOS file and ensure all six section headers are present.
- **Check 3 fails**: Open the TELOS file, find any remaining `${PLACEHOLDER}` values, and fill them.
- **Check 4 fails**: Open the TELOS file and remove any HTML comment lines.
- **Check 5 fails**: Return to INSTALL.md Step 3 and append the steering instruction to the correct target file.
- **Check 6 fails**: Open the `<!-- keel-telos -->` block in the target file and correct the path to match where `telos.md` was written.
