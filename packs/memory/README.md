# memory pack

Give your AI persistent, structured memory across sessions using plain markdown files.

---

## What it is

A two-tier system of text files:

- **Global root** (`~/.claude/memory/`) — facts useful across every project: who the user is, durable preferences, feedback on working style, domain knowledge, external references.
- **Project-local root** (`.memory/` in the project, or a harness-scoped directory) — this project's in-flight state, decisions, and constraints.

Each root has a `MEMORY.md` index (one pointer per entry) and a set of leaf files (one fact per file, with frontmatter the AI uses to decide relevance).

---

## Why text files instead of a vector database or RAG pipeline

**Transparent.** Every memory is a file you can open, read, edit, or delete with any text editor. No black box, no embedding layer to debug, no vendor lock-in.

**Greppable.** `rg "design system"` across `~/.claude/memory/` finds every relevant memory instantly. No index rebuild, no stale embedding.

**Reliable recall.** Semantic search has a failure mode: close-but-wrong results that silently mislead. A flat index of one-line hooks, loaded by the AI before each task, gives deterministic recall for the things that actually matter — with no false positives.

**Durable.** Plain files survive model upgrades, tool changes, and provider switches. The pattern persists because it is written down.

---

## When to use it

Use this pack if:
- You want your AI to remember decisions, preferences, or context between sessions.
- You work across multiple projects and want shared knowledge (your role, recurring preferences) available everywhere.
- You want to inspect or edit your AI's memory directly without a special interface.
- You are setting up a persistent AI for the first time and want a simple, auditable foundation.

You do not need this pack if every session is one-off and you have no recurring context to preserve.

---

## What gets memorized (and what doesn't)

**Save:** decisions made, preferences discovered, the *why* behind a choice, durable constraints, references to external resources.

**Don't save:** code structure, file paths, git history, architecture visible in the codebase, debugging recipes, ephemeral task state. These rot the moment the code changes and become noise that degrades recall quality.

---

## Files in this pack

| File | Purpose |
|---|---|
| `src/CLAUDE-memory-snippet.md` | The block you paste into `~/.claude/CLAUDE.md` to activate memory |
| `src/MEMORY.template.md` | Starter index file for each memory root |
| `src/leaf-templates.md` | Four frontmatter templates, one per memory type |
| `INSTALL.md` | Step-by-step install instructions (addressed to the installing AI) |
| `VERIFY.md` | Verification checklist (addressed to the installing AI) |
