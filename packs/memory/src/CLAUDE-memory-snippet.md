## Memory Management

Two-tier memory system. Cross-project knowledge lives in a global tree; project-specific knowledge lives in a per-project directory scoped to the working directory.

### Roots

- **Global (cross-project): `~/.claude/memory/`**
  Anything useful in *any* project: who the user is, durable preferences, feedback on how to work together, domain knowledge, tool configs, external references.

- **Project-local (per-project):**
  Either a `.memory/` directory inside the project root, or a harness-managed directory scoped by working path. Contents: this project's state, decisions, in-flight initiatives, constraints not derivable from code.

**Routing rule when saving:** ask "would this still be useful in a *different* project?" → Global. Else → Project-local.

### Structure

- `MEMORY.md` — index file at each root. One line per entry: `- [Title](file.md) — one-line hook for relevance matching`. Loaded at session start. Never put memory content directly in the index; only pointers.
- Leaf files — one fact (or tightly related cluster) per file, with frontmatter. See leaf-templates for the four types.

### Rules

1. **Save immediately** when you learn something durable. Convert relative dates ("Thursday") to absolute (`YYYY-MM-DD`) before writing.
2. **Don't save what's derivable** — code structure, file paths, architecture decisions visible in the code, git history, debugging recipes, ephemeral task state. These rot fast and become noise.
3. **Index-only in `MEMORY.md`.** Never put the memory content itself in the index — only the pointer and the one-line hook.
4. **At session start**, read both `MEMORY.md` files (global + project-local). Load individual leaf files lazily when their description matches the current task.
5. **Verify before recommending from memory.** A memory naming a file, function, or flag is a claim about the past. Before acting on it, confirm the file exists or the symbol is still present. Trust current observation over stale memory; update or delete the stale entry.
6. **Update in place** — search both roots for an existing entry before creating a new one. No duplicates. Delete entries that turn out to be wrong rather than leaving them to mislead.
