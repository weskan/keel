# knowledge-vault pack

A third tier above the two memory roots: a plain-markdown knowledge base that is
yours first and your AI's second.

## Why memory is not enough

The `memory` pack is **agent-internal state** — how to work with you, what this
project's constraints are, what was decided last Tuesday. It is written by the
agent, for the agent. It is short, indexed, and disposable.

That is the wrong container for the things you actually know. Your thinking
about a domain, the design of a project, the history with a person, the reasons
behind a decision — those are *yours*. They should be readable, editable, and
useful to you even if every AI tool you use disappears tomorrow.

So:

| Tier | Holds | Written by |
|---|---|---|
| Project-local memory | this project's in-flight state | the agent |
| Global memory | how to work with you, cross-project facts | the agent |
| **Knowledge vault** | **what you know and have decided** | **you, and the agent on your behalf** |

The vault is authoritative. When memory and the vault disagree about something
substantive, the vault wins and the memory entry gets fixed.

## Why this beats putting it all in memory

**It survives the tooling.** Plain markdown in a folder outlives harnesses,
model versions, and vendors. Memory formats are an implementation detail of
whatever agent you are running this month.

**It is legible to you.** You can open it, read it, and edit it in any editor,
or in a notes application that renders the links. Agent memory is optimized for
retrieval, not for reading; a knowledge base you cannot enjoy reading is one you
will stop maintaining.

**It separates capture from knowledge.** The single most useful structural idea
in this pack is that raw capture and distilled knowledge have different quality
bars and must not share a folder. Mixing them is how a knowledge base becomes a
junk drawer.

## The structure

Organize by **processing state**, not by topic:

```
vault/
  raw/        your inbox - unprocessed capture, zero quality bar
  wiki/       distilled, durable knowledge
    projects/   one note per project
    people/     one note per person
    concepts/   one note per idea or piece of domain knowledge
    index.md    one line per note
  journal/    dated entries - what happened, what you decided
  content/    drafts headed somewhere else
```

Topic taxonomies rot, because what you work on changes. Processing state does
not: something is either unprocessed, distilled, dated, or outbound. That
distinction stays true for as long as you keep notes.

## The read/write boundary

**`raw/` is yours. The agent never writes there.**

This is the load-bearing rule of the pack. `raw/` is your unfiltered input; if
the agent can rewrite it, you lose the ability to tell what you said from what
it inferred. Keeping one directory strictly yours means there is always a ground
truth to fall back on when something in `wiki/` turns out to be wrong.

Enforce it with prose in `CLAUDE.md`, and — if the agent runs unattended — with
the `hooks` pack's protected-path guard, which makes it a wall rather than a
request.

## Habits that keep it alive

**Capture with zero friction.** Anything that crosses your mind goes to `raw/`
unformatted and unfiled. Friction at capture time is why note systems get
abandoned.

**Distill on a schedule.** Weekly, read `raw/` and promote what still matters
into `wiki/`. Most of it will not matter — deleting it is a success. This step
is the entire difference between a knowledge base and a pile.

**Write the *why*.** "Chose X" is nearly useless in six months. "Chose X over Y
because Y needed an approval we cannot get" is the note you will thank yourself
for. Rejected options are what nobody records and everybody re-litigates.

**Prune wrong notes aggressively.** A note that is wrong is a liability, not an
asset — more so once an agent reads them and acts on them. Wrong is worse than
missing.

## Files in this pack

| File | Purpose |
|---|---|
| `src/CLAUDE-vault-snippet.md` | The block to add to `CLAUDE.md` — triggers and boundary |
| `src/vault-conventions.md` | House rules to drop in the vault root |
| `src/index.template.md` | Starter index |
| `INSTALL.md` | Step-by-step instructions for an AI installer |
| `VERIFY.md` | Checklist for an AI to confirm the install |
