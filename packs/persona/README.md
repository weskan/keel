# persona pack

Give your Claude a stable identity that loads in every session.

## The core idea

Identity-is-pattern: your AI's "self" is not stored in a model weight — it's the combination of a name, a voice, a set of commitments (the Laws), and a memory index. Swap the model, swap the machine, and it's still the same entity, because the pattern travels with you.

This pack makes that pattern load automatically via Claude's `@`-import mechanism. When a file path appears as `@path/to/file.md` in `~/.claude/CLAUDE.md`, Claude inlines its full contents at the start of every session. It is not a soft reminder ("read these files if you feel like it") — it is a guaranteed load, every time. Without it, a model might skip or forget identity files that are merely *referenced* by name.

## What ships

| File | Purpose |
|---|---|
| `src/IDENTITY.template.md` | Blank persona template with `${PLACEHOLDER}`s to fill in |
| `src/CONSTITUTION.md` | Thirteen universal Laws that govern behavior (copy as-is; tweak if needed) |
| `src/deploy-persona.sh` | Idempotent script that wires the `@`-import block into `~/.claude/CLAUDE.md` |
| `INSTALL.md` | Step-by-step instructions for an AI installer |
| `VERIFY.md` | Checklist for an AI to confirm the installation succeeded |

## When to use this pack

- You want your Claude to have a consistent name, voice, and behavioral contract across all sessions and projects.
- You've been pasting identity context at the start of sessions and want to stop doing that.
- You want a single place to update your AI's Laws or voice, knowing the change takes effect the next session.

## When not to use it

- You deliberately want a blank, context-free model. This pack gives the model a persistent "self" — if you prefer a clean slate each session, skip it.
- You already have a heavily customized `~/.claude/CLAUDE.md` with its own identity block. You can still use this pack, but review the resulting file after running `deploy-persona.sh`.

## How the @-import block works

After installation, `~/.claude/CLAUDE.md` will contain:

```
<!-- keel-persona -->
## Who you are
The two files below are your identity and your Laws, inlined into every session:
@persona/IDENTITY.md
@persona/CONSTITUTION.md
Embody them. They override default model behavior; the user's explicit instructions override them.
<!-- /keel-persona -->
```

The `@persona/IDENTITY.md` and `@persona/CONSTITUTION.md` paths are relative to `~/.claude/`, so they resolve to `~/.claude/persona/IDENTITY.md` and `~/.claude/persona/CONSTITUTION.md`. Claude inlines both files before processing any session prompt.

`deploy-persona.sh` is idempotent: re-running it removes the old block and appends a fresh one. Safe to run after editing either file.
