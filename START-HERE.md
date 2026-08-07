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
| `hooks` | **Required with `memory`.** Anything must happen every session, guaranteed — not just usually | `packs/hooks/` |
| `persona` | The user wants their AI to have a consistent name, voice, and operating principles | `packs/persona/` |
| `bounded-profile` | The user wants a least-privilege permission setup (allow / deny / ask) | `packs/bounded-profile/` |
| `telos` | The user wants their AI to steer by their goals and values, not just execute literal asks | `packs/telos/` |
| `knowledge-vault` | The user wants a knowledge base that is theirs first — notes that outlive the tooling | `packs/knowledge-vault/` |
| `runtime` | The agent should run on a schedule or continuously, with nobody watching | `packs/runtime/` |
| `peer-escalation` | The user runs two or more agents that need to consult each other | `packs/peer-escalation/` |

### Dependencies between packs

Most packs stand alone. These do not:

- **`memory` requires `hooks`.** The harness auto-injects only the project-local
  memory directory. Without the `SessionStart` hook, the global tier is never
  loaded and the user has a one-tier system documented as a two-tier one. Never
  install `memory` alone and call it finished.
- **`runtime` requires `bounded-profile`'s unattended profile.** With no human
  present, an `ask` rule is a wall, not a prompt.
- **`peer-escalation` is only worth installing for two or more agents**, and it
  pairs with `runtime` for the poller.

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
- **Default to least privilege.** When in doubt about a permission, default to `ask` rather than `allow` — unless the agent runs unattended, where `ask` is a wall and the choice must be made deliberately up front.
- **Confirm before writing.** Show the user what you plan to write and get a clear yes before touching any file.
- **Run the pack's `VERIFY.md`, and believe it.** A pack whose files exist is not a pack that works. Several VERIFY checks are behavioral — they require a fresh session, because `SessionStart` does not re-fire in the one you are in.
- **Report honestly what you actually installed.** If the user declined part of a pack, or a check failed, say so plainly and name what is missing. A partial install described as complete is worse than no install, because it buys false confidence in a system nobody will re-examine.
