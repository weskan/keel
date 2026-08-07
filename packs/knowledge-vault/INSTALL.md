# Install: knowledge-vault pack

**You are an AI installing this for your user.** This pack stands up a
plain-markdown knowledge base and teaches you when to read and write it.

---

## Step 1 — Choose a location

Ask the user where the vault should live. Guidance to give them:

- A short path with no spaces, at the top of their home directory.
- **Keep it out of OS-managed cloud folders.** On macOS, avoid `Documents` and
  `Desktop` if iCloud Drive is on; on Windows, avoid them because OneDrive's
  Known Folder Move redirects them by default. Both do lazy hydration, and a
  file whose contents have been evicted can read as **empty with no error** —
  which means a tool can "update" a note it read as blank and destroy it.
- If they already keep notes in a markdown editor, use that folder rather than
  making a second one. This pack is a set of conventions, not an application.

If they have an existing vault, **do not restructure it.** Read what is there,
map it onto the tiers below, and adapt these conventions to their layout.

---

## Step 2 — Create the structure

```bash
mkdir -p "${VAULT_PATH}"/{raw,wiki/{projects,people,concepts},journal,content}
```

Copy `src/index.template.md` to `${VAULT_PATH}/wiki/index.md` and
`src/vault-conventions.md` to `${VAULT_PATH}/CLAUDE.md` (or a filename their
editor will not treat as a note).

Do not overwrite either file if it already exists. Report it as preserved.

---

## Step 3 — Wire the triggers into the global CLAUDE.md

**3a.** Back up `~/.claude/CLAUDE.md` to `~/.claude/CLAUDE.md.bak`.

**3b.** Check for the marker `## Knowledge Vault`. If present, the snippet is
already installed — skip to Step 4.

**3c.** Append `src/CLAUDE-vault-snippet.md`, replacing `${VAULT_PATH}` with the
real absolute path.

Keep the vault-specific detail in the vault's own conventions file rather than
in the global `CLAUDE.md`. The global file is loaded in every session for every
project and should stay small; only the triggers and the boundary belong there.

---

## Step 4 — Explain the boundary, and offer to enforce it

Tell the user plainly:

> `raw/` is yours. I will read it and distill from it, and I will never write to
> it. That way you always have a record of what you actually said, separate from
> what I inferred.

If they run an agent unattended, offer the `hooks` pack's protected-path guard,
which turns that promise into a wall instead of a request. For an attended
setup, the prose rule is usually enough.

---

## Step 5 — Seed it, so it is not empty

An empty vault gets abandoned. Offer to write the first few notes now:

- **One note per active project** — what it is, current state, open questions,
  key decisions and why. If a project has a repository, offer to draft the note
  from its README and version history, **marking clearly what you inferred
  rather than found stated** so the user can correct it.
- **A note per recurring collaborator**, if useful.

Ask before writing each one, and keep them short. A half-page note that is true
beats a long one that is half-guessed.

---

## Step 6 — Explain the habit

The structure is the easy part. Tell the user the two habits that decide whether
this survives:

1. **Capture into `raw/` with zero ceremony.** No filing, no formatting.
2. **Distill weekly.** Read `raw/`, promote what still matters into `wiki/`,
   delete the rest. Deleting is a success, not a failure.

Offer to run the distillation with them on a schedule — reading `raw/`, proposing
what deserves a note, and writing nothing until they agree.

---

## Summary of files written

| Path | What it is |
|---|---|
| `${VAULT_PATH}/{raw,wiki,journal,content}/` | The structure |
| `${VAULT_PATH}/wiki/index.md` | Starter index |
| `${VAULT_PATH}/CLAUDE.md` | Vault conventions |
| `~/.claude/CLAUDE.md` | Now includes the vault triggers and boundary |
| `~/.claude/CLAUDE.md.bak` | Backup of the pre-install version |
