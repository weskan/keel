# hooks pack

Turn instructions your AI is *asked* to follow into behavior the harness *guarantees*.

## The problem this solves

Everything you write in `CLAUDE.md` is a request. It sits in the context window
alongside everything else, and the model is asked to honor it. That works well —
until a session runs long, context gets tight, or the instruction is one of
forty. Then it quietly doesn't happen.

The failure is silent. There is no error, no warning, no missing output. The
session just behaves as though the instruction were never written, and the
answers get slightly worse in ways nobody notices for weeks.

A **hook** is different in kind. It is a shell command the harness executes at a
fixed point in the session lifecycle. It runs whether or not the model
remembers, because the model is not involved in the decision.

> Prose is a request. A hook is a guarantee.

Anything load-bearing — the thing that must happen every session for the rest of
your setup to work — belongs in a hook, not in prose.

## The canonical case: memory that never loads

The `memory` pack installs two roots: a global one for cross-project facts and a
project-local one. Claude Code auto-loads the project-local root. **It does not
know your global root exists.** Without a hook, loading it depends on the model
choosing to go read it, every session, forever.

That is exactly the kind of instruction that degrades silently. The agent keeps
answering — just from its priors instead of from your accumulated facts — and
the only symptom is that it feels a little dumber than it used to.

This pack ships that injector. If you installed the `memory` pack, you want this
one too.

## When to use this pack

Install it if any of the following is true:

- You installed the `memory` pack (the global tier will not load without it).
- You have a rule that must hold every session, not most sessions.
- You want a directory or file protected from writes by mechanism, not by
  request.
- You run an agent unattended, where "the model usually remembers" is not good
  enough because no human is watching.

Skip it if your setup is a single project with no global state and you are
present for every session.

## The lifecycle events

| Event | Fires | Typical use |
|---|---|---|
| `SessionStart` | once, when a session opens | inject an index, a status line, a warning |
| `UserPromptSubmit` | on every message you send | just-in-time context injection |
| `PreToolUse` | before a tool call runs | block writes to a protected path |
| `PostToolUse` | after a tool call returns | log, format, run tests |
| `Stop` | when the agent finishes a turn | nudge an unfinished habit |

`SessionStart` is the highest-value one and the only one this pack installs by
default. The others are offered as patterns.

## The design rule: fail loudly, in context

This is the part most people get wrong, so the scripts in this pack are written
to demonstrate it.

A hook that is supposed to load your memory, and silently doesn't, is **worse
than no hook at all** — because you will keep trusting a system that stopped
working. Every failure path in these scripts emits a visible warning into the
session: missing interpreter, missing directory, empty index, an index that
points at files which no longer exist.

Do not solve this by adding a separate monitor to watch the hook. A monitor can
die just as quietly as the thing it watches. Instead, make the load-bearing
component announce its own health in the one place that is read every single
session — the context window.

## Files in this pack

| File | Purpose |
|---|---|
| `src/inject-memory-index.sh` | `SessionStart` injector for macOS and Linux |
| `src/inject-memory-index.ps1` | The same injector for Windows PowerShell |
| `src/guard-protected-path.sh` | `PreToolUse` example: block writes to a path |
| `src/settings.hooks.template.json` | The `hooks` block to merge into `settings.json` |
| `INSTALL.md` | Step-by-step instructions for an AI installer |
| `VERIFY.md` | Checklist to confirm the install actually fires |
