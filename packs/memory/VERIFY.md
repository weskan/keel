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

## Summary

| Check | What it confirms |
|---|---|
| 1 | Global memory root directory exists |
| 2 | Memory index file is initialized |
| 3 | Memory snippet is active in CLAUDE.md |
| 4 | AI can create, register, and remove a leaf file |

All four checks PASS → the memory pack is correctly installed.
