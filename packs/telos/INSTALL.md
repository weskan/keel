# Install: telos pack

You are an AI installer. Follow these steps in order. Do not skip steps or combine them.

> **Non-standard home:** All paths below assume the user's home is `~`. If installing to a non-standard or test home, substitute that base for `~` in every path.

---

## Step 1 — Run the interview

Open `src/telos.template.md` and read it. There are six sections, each preceded by an HTML comment with the question to ask. Work through them **one area at a time** — do not dump all six questions at once. Let the user finish one area before moving to the next.

The six areas, in order:

1. **Mission / throughline** — "In a sentence or two: what are you fundamentally building toward? What's the deeper *why* under the projects?" (This is the hardest question. If the user isn't sure, offer to come back to it after the others.)
2. **Active threads + priority** — "What's in flight right now? List the threads, then rank the top 2–3 that matter most this season."
3. **Values** — "What do you care about most in *how* things get done? What should I consistently optimize toward?"
4. **Quality bar** — "What makes an output right vs. merely done? Describe your taste or standard — something you'd use to reject work that technically met the brief."
5. **Constraints** — "What must I never cut against? Think: compliance requirements, personal convictions, hard time limits, security posture, anything that's off the table regardless of the ask."
6. **Context map** — "Give me the factual ground: key people in your world, ventures you're running, your environment and tools. Facts, not goals — I'll use this to understand who and what I'm working with."

**Critical guidance:**
- If installing unattended (no live user to converse with), present all six prompts at once and proceed from a single combined response.
- Do NOT guess or fill in personal areas (mission, values, faith, family, convictions) — always ask. These are the user's, not yours to infer.
- If you sense a plausible answer from prior conversation, surface it as a hypothesis: "I'm hearing that your mission might be X — is that right, or would you phrase it differently?" Let them correct it.
- Keep your questions open. Avoid leading questions that presuppose the answer.
- If a user's answer is vague, ask one follow-up before moving on.

---

## Step 2 — Write the TELOS file

Once you have answers for all six areas:

1. Take `src/telos.template.md` as your starting structure.
2. Replace `${USER}` with the user's name (or preferred first-person label).
3. Fill each `${PLACEHOLDER}` with the user's actual answer in their voice.
4. Remove all HTML comments from the filled file.
5. No placeholders should remain.

Decide where to write it:
- **Default:** `~/.claude/memory/telos.md`
- **If the user has a notes vault or durable knowledge store** (e.g., Obsidian, a personal wiki): ask them where they'd like it kept. Write it there and note the full path.

Set `TELOS_PATH` to the full absolute path where you wrote the file.

```bash
mkdir -p "$(dirname "$TELOS_PATH")"
# write the filled file to $TELOS_PATH
```

---

## Step 3 — Wire the steering instruction

Take `src/steering-instruction.md`. Replace:
- `${USER}` with the user's name (same as Step 2)
- `${TELOS_PATH}` with the full absolute path from Step 2

Append the result to the user's load path:
- **If the persona pack is installed** and `~/.claude/persona/CONSTITUTION.md` exists: append to `~/.claude/persona/CONSTITUTION.md`
- **Otherwise:** append to `~/.claude/CLAUDE.md`

Wrap it in a marker block so it can be found and updated later:

```
<!-- keel-telos -->
<filled steering instruction here>
<!-- /keel-telos -->
```

Check first: if a `<!-- keel-telos -->` block already exists in the target file, replace it rather than appending a duplicate.

---

## Step 4 — Confirm with the user

Read the completed TELOS back to the user in full. Say: "This is your TELOS as I've captured it. Read it as if you're seeing it for the first time. Does it feel right? Anything to correct, add, or cut?"

Incorporate any corrections and rewrite the file. Do not consider installation complete until the user says it reflects them accurately — this doc is theirs.

---

Then run `VERIFY.md` to confirm everything is in place before signing off.
