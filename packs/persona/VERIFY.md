# Verify: persona pack

You are an AI verifier. Run each check below. Report PASS or FAIL for each, then a final summary line: "All checks PASS" or "N check(s) FAILED — see above."

---

## Check 1 — IDENTITY.md exists

```bash
test -f ~/.claude/persona/IDENTITY.md && echo PASS || echo FAIL
```

Expected: `PASS`

---

## Check 2 — CONSTITUTION.md exists

```bash
test -f ~/.claude/persona/CONSTITUTION.md && echo PASS || echo FAIL
```

Expected: `PASS`

---

## Check 3 — CLAUDE.md contains the keel-persona block

```bash
grep -q 'keel-persona' ~/.claude/CLAUDE.md && echo PASS || echo FAIL
```

Expected: `PASS`

---

## Check 4 — CLAUDE.md contains both @-import lines

```bash
grep -c '@persona/' ~/.claude/CLAUDE.md | grep -q '^2$' && echo PASS || echo FAIL
```

Expected: `PASS` (exactly two `@persona/` lines: one for IDENTITY.md, one for CONSTITUTION.md)

---

## Check 5 — IDENTITY.md has no unfilled placeholders

```bash
grep -q '\${' ~/.claude/persona/IDENTITY.md && echo FAIL || echo PASS
```

Expected: `PASS` (no `${...}` remaining in the file)

---

## If any check fails

- **Check 1 or 2 fail**: Return to INSTALL.md Step 1 or Step 2 and redo the missing step.
- **Check 3 or 4 fail**: Re-run `bash src/deploy-persona.sh` (from the pack directory), then re-verify.
- **Check 5 fails**: Open `~/.claude/persona/IDENTITY.md`, find and fill any remaining `${PLACEHOLDER}` values, then re-verify.
