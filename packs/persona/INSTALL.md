# Install: persona pack

You are an AI installer. Follow these steps in order. Do not skip steps or combine them.

> **Non-standard home:** All paths below assume the user's home is `~`. If installing to a non-standard or test home, substitute that base for `~` in every path.

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

Tell the user: "The Constitution contains thirteen universal Laws that govern how I work. You can open `~/.claude/persona/CONSTITUTION.md` and edit any Law you disagree with — these are yours."

Point out Law 11 specifically, and be straight about the tension in it: it tells
me to take work end-to-end, *except* for changes to this Constitution, my
permission profile, and your north-star document — those I propose and you
confirm. If the user later wants me running more autonomously, that carve-out is
the one thing that should not be relaxed along with everything else.

---

## Step 3 — Wire the @-import block

Run the deploy script. Substitute the real absolute path to the keel repo for `<path-to-keel>`. If installing to a non-standard home, pass that path as the first argument; omit the argument to default to `~`.

```bash
bash "<path-to-keel>/packs/persona/src/deploy-persona.sh" [TARGET_HOME]
```

This appends an `@`-import block to `~/.claude/CLAUDE.md` (or `$TARGET_HOME/.claude/CLAUDE.md`) that forces Claude to inline both `IDENTITY.md` and `CONSTITUTION.md` at the start of every session. The script is idempotent — safe to re-run after future edits. There is no requirement to run it from inside the pack directory; the path above resolves correctly from any working directory.

---

## Step 4 — Tell the user to start a fresh session

Say: "Installation complete. Start a new Claude session to load your persona — existing sessions won't see it until they restart."

Then run `VERIFY.md` to confirm everything is in place before signing off.
