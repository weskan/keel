# Install: memory pack

You are an AI installing this pack for a user. Follow these steps in order. Show the user what you are about to do before each write step — do not write blindly.

> **Non-standard home:** All paths below assume the user's home is `~`. If installing to a non-standard or test home, substitute that base for `~` in every path.

---

## Step 1 — Create the global memory root

```bash
mkdir -p ~/.claude/memory
```

Confirm the directory exists after creating it.

---

## Step 2 — Initialize the global memory index

Copy `src/MEMORY.template.md` to `~/.claude/memory/MEMORY.md`.

If `~/.claude/memory/MEMORY.md` already exists, do not overwrite it — skip this step and tell the user their existing index was preserved.

---

## Step 3 — Append the memory snippet to CLAUDE.md

**3a. Back up first.**
If `~/.claude/CLAUDE.md` exists, copy it to `~/.claude/CLAUDE.md.bak` before touching it.

**3b. Check for an existing install.**
Search `~/.claude/CLAUDE.md` for the marker string `## Memory Management`. If found, the snippet is already present — skip to Step 4 and tell the user.

**3c. Append.**
Append the full contents of `src/CLAUDE-memory-snippet.md` to `~/.claude/CLAUDE.md`. If `~/.claude/CLAUDE.md` does not exist yet, create it with only that content.

---

## Step 4 — Tell the user about the project-local root

Explain that a second memory root can live inside each project. The two common patterns are:
- A `.memory/` directory at the project root (simple, co-located with the code).
- A harness-managed directory scoped by working path (used if their Claude harness supports it — check their setup).

Ask which pattern they prefer, or whether they want to decide per-project. Initialize a `MEMORY.md` in the project-local root using the same template if they want to set one up now.

---

## Step 5 — Offer to seed memory from existing notes

Ask: "Do you have any notes, documents, or previous AI conversations with context you'd like to import into your memory?" If yes, read what they share and distill it into appropriate leaf files using the four typed formats in `src/leaf-templates.md` (one atomic leaf file per durable fact, plus a one-line entry in the relevant `MEMORY.md` index). Add a pointer for each new leaf in the relevant `MEMORY.md` index.

No interview is required otherwise — the memory system is structural, not persona-based. The AI fills it over time as it learns things about the user.

---

## Summary of files written

After a complete install, these files should exist:

| Path | What it is |
|---|---|
| `~/.claude/memory/` | Global memory root directory |
| `~/.claude/memory/MEMORY.md` | Global memory index (from template) |
| `~/.claude/CLAUDE.md` | Now includes the memory management snippet |
| `~/.claude/CLAUDE.md.bak` | Backup of the pre-install CLAUDE.md (if one existed) |
