# START HERE

**You are an AI reading this on behalf of a user.**

Nothing in Keel is personal — every personal value is something you interview your user for. Never invent personal facts. Every name, goal, preference, and rule in these packs is a placeholder until the user fills it in.

---

## What is Keel?

Keel is a kit of independent packs for standing up a persistent, personalized Claude. Each pack solves one problem: memory, persona, permissions, or purpose. Use what helps this user; skip the rest. There is no required install order and no mandatory baseline — the packs are designed to work alone or together.

---

## Pack catalog

| Pack | Install this if… | Path |
|---|---|---|
| `memory` | The user wants their AI to remember decisions and preferences across sessions | `packs/memory/` |
| `persona` | The user wants their AI to have a consistent name, voice, and operating principles | `packs/persona/` |
| `bounded-profile` | The user wants a least-privilege permission setup (allow / deny / ask) | `packs/bounded-profile/` |
| `telos` | The user wants their AI to steer by their goals and values, not just execute literal asks | `packs/telos/` |

---

## Ingest procedure

Follow these steps in order. Do not skip the proposal step.

1. **Read** this file and `docs/philosophy.md` so you understand the principles behind the packs.
2. **Inspect** the user's current `~/.claude/` — their `memory/` directory, `CLAUDE.md`, and `settings.json` — then ask what they want to improve or set up.
3. **Propose** a sensible subset of packs based on what you heard. Do **not** install blindly — present your recommendation and wait for confirmation.
4. **For each confirmed pack:**
   - Read its `README.md` for context on what it does and why.
   - Follow its `INSTALL.md` step by step.
   - Interview the user for every `${PLACEHOLDER}` value — never substitute your own guess.
   - Write the resulting files.
   - Run its `VERIFY.md` checklist to confirm the install is correct.
5. **Report** what you installed, where the files landed, and how the user can evolve each pack over time.

---

## Rules

- **Never invent personal facts.** If you don't know it, ask. Placeholders exist for a reason.
- **Back up before overwriting.** If a file already exists in `~/.claude/`, copy it to `~/.claude/backups/` (with a datestamp) before replacing it.
- **Default to least privilege.** When in doubt about a permission, default to `ask` rather than `allow`.
- **Confirm before writing.** Show the user what you plan to write and get a clear yes before touching any file.
