# Verify: memory pack

You are an AI verifying that the memory pack installed correctly. Run each check in order and report PASS or FAIL with a brief note.

---

## Check 1 — Global memory root exists

```bash
test -d ~/.claude/memory && echo PASS || echo FAIL
```

Expected: `PASS`. If FAIL: the directory was not created — rerun Step 1 of INSTALL.md.

---

## Check 2 — Memory index exists

```bash
test -f ~/.claude/memory/MEMORY.md && echo PASS || echo FAIL
```

Expected: `PASS`. If FAIL: the template was not copied — rerun Step 2 of INSTALL.md.

---

## Check 3 — Memory snippet is present in CLAUDE.md

```bash
grep -q "## Memory Management" ~/.claude/CLAUDE.md && echo PASS || echo FAIL
```

Expected: `PASS`. If FAIL: the snippet was not appended — rerun Step 3 of INSTALL.md.

---

## Check 4 — Leaf file round-trip

This confirms the AI can write a leaf file and register it in the index, then clean it up.

**4a.** Create a test leaf file:

```bash
cat > ~/.claude/memory/verify-test.md << 'EOF'
---
name: verify-test
description: temporary file created during memory pack verification — safe to delete
type: reference
---

verification test — delete this file after VERIFY.md completes
EOF
```

**4b.** Confirm it exists:

```bash
test -f ~/.claude/memory/verify-test.md && echo PASS || echo FAIL
```

**4c.** Add a pointer to `~/.claude/memory/MEMORY.md`:

Append this line to `MEMORY.md`:
```
- [Verify Test](verify-test.md) — temporary verification entry; delete after check
```

Confirm the line appears:

```bash
grep -q "verify-test" ~/.claude/memory/MEMORY.md && echo PASS || echo FAIL
```

**4d.** Clean up — remove the test file and the index entry:

```bash
rm ~/.claude/memory/verify-test.md
```

Then remove the verify-test line from `~/.claude/memory/MEMORY.md`.

Confirm cleanup:

```bash
test ! -f ~/.claude/memory/verify-test.md && echo PASS || echo FAIL
grep -q "verify-test" ~/.claude/memory/MEMORY.md && echo "FAIL (line still present)" || echo PASS
```

---

## Check 5 — The global tier actually reaches a session

Checks 1–4 prove the files exist. They do **not** prove the global memory is
ever loaded, and on a default setup it is not: the harness auto-injects only the
project-local directory.

**5a. Is the loader wired at all?**

```bash
grep -q "inject-memory-index" ~/.claude/settings.json && echo PASS || echo FAIL
```

FAIL → the `hooks` pack was not installed. Go do INSTALL.md Step 5. Until then
this is a one-tier memory system.

**5b. Does it reach a real session?**

Ask the user to open a **fresh** session and ask their AI:

> Quote the first three lines of the global memory index you were given.

- **PASS** — it quotes lines matching `~/.claude/memory/MEMORY.md`.
- **FAIL** — it has no index, or it describes going and reading the file rather
  than being handed it. The global tier is not loading.

Do not report the memory pack as installed on a 5b FAIL. Report it as
project-local memory only, and say what is missing.

---

## Summary

| Check | What it confirms |
|---|---|
| 1 | Global memory root directory exists |
| 2 | Memory index file is initialized |
| 3 | Memory snippet is active in CLAUDE.md |
| 4 | AI can create, register, and remove a leaf file |
| 5 | The global tier is actually loaded into a live session |

Checks 1–4 PASS → the files are in place.
Check 5 PASS → the memory system is genuinely two-tier. Without it, only the
project-local tier is live, however complete the rest looks.
