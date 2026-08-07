# Vault conventions

House rules for this knowledge base. Place this file in the vault root; an AI
working inside the vault should read it before writing.

## Structure

```
raw/        my inbox - unprocessed capture. THE AI NEVER WRITES HERE.
wiki/       distilled, durable knowledge
  projects/   one note per project
  people/     one note per person
  concepts/   one note per idea or piece of domain knowledge
  index.md    one line per note, with a one-line hook
journal/    dated entries
content/    drafts headed somewhere else
```

Flow: capture into `raw/` → distill into `wiki/` → publish from `content/`.

## Page conventions

- **Filenames:** lowercase, hyphenated, descriptive (`project-name-rollout.md`).
- **Links:** `[[note-name]]`. Prefer relative. A link to a note that does not
  exist yet is a feature — it marks something worth writing later.
- **Atomicity:** one concept, project, or person per note. Split a note that is
  trying to be two things. Past roughly 80 lines, consider promoting a note to
  its own folder.
- **Frontmatter:** minimal — `created`, `tags`, `status`, `description`. Do not
  add fields nothing consumes.
- **Index:** `wiki/index.md` gets one line per note. Update it when adding a
  significant note. The index is pointers only, never content.

## Style

- **Voice:** first person, direct, terse. Skip throat-clearing.
- **Length:** the shortest version that is still useful. A one-screen note is
  usually right.
- **Structure:** lead with the point. Headings for navigation, not decoration.
- **Dates:** ISO (`YYYY-MM-DD`), never relative.

## What belongs here, and what does not

**Write down:** decisions and the reasoning behind them, options considered and
rejected, constraints, domain knowledge, the state of a project and its open
questions.

**Do not write down** what the code, the docs, or the version history already
say. Derivable content rots fastest and adds the most noise. The reason a choice
was made exists nowhere else — that is what this is for.

## For an AI working in here

- `raw/` is read-only for you. Always. Distill instead of editing.
- Verify before asserting: a note naming a file, tool, or version is a claim
  about the past. Confirm it still holds before acting on it, and fix the note
  when it does not.
- Cite the note when you answer from one. Say "I don't have that recorded" when
  you searched and found nothing.
- Prune confidently. A wrong note is worse than a missing one, because it will
  be believed.
