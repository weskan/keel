# Install: persona pack

You are an AI installer. Follow these steps in order. Do not skip steps or combine them.

---

## Step 1 — Interview the user to author their identity

Open `src/IDENTITY.template.md` and read it. Each `${PLACEHOLDER}` needs a value; HTML comments above each one tell you what to ask.

Ask the user these questions (you may ask them together in one message):

1. **Name** — What do you want your AI called?
2. **Namesake** (optional) — Is the name after a person, character, or concept? If yes: what traits or expectations come with that name? (If the user says no or wants to skip, omit the `## Namesake` section entirely from the final file.)
3. **Scope** — Does this AI span your whole life (work + personal), or is it focused on one domain? Describe it briefly.
4. **Voice** — How should it speak? Terse or expansive? Warm or dry? Any things to avoid (flattery, filler phrases, hedging)?

Fill in the template with the user's answers, replacing every `${PLACEHOLDER}` and removing all HTML comments. The result is their `IDENTITY.md`.

Before writing, check whether `~/.claude/persona/IDENTITY.md` already exists. If it does, back it up:

```bash
cp ~/.claude/persona/IDENTITY.md ~/.claude/persona/IDENTITY.md.bak
```

Then write the filled template to `~/.claude/persona/IDENTITY.md`.

---

## Step 2 — Place the Constitution

Copy `src/CONSTITUTION.md` to `~/.claude/persona/CONSTITUTION.md`:

```bash
mkdir -p ~/.claude/persona
cp src/CONSTITUTION.md ~/.claude/persona/CONSTITUTION.md
```

Tell the user: "The Constitution contains ten universal Laws that govern how I work. You can open `~/.claude/persona/CONSTITUTION.md` and edit any Law you disagree with — these are yours."

---

## Step 3 — Wire the @-import block

Run the deploy script:

```bash
bash src/deploy-persona.sh
```

This appends an `@`-import block to `~/.claude/CLAUDE.md` that forces Claude to inline both `IDENTITY.md` and `CONSTITUTION.md` at the start of every session. The script is idempotent — safe to re-run after future edits.

---

## Step 4 — Tell the user to start a fresh session

Say: "Installation complete. Start a new Claude session to load your persona — existing sessions won't see it until they restart."

Then run `VERIFY.md` to confirm everything is in place before signing off.
