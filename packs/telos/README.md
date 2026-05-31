# telos pack

Give your AI a north star to steer by, not just tasks to execute.

## The core idea

Without an articulated TELOS, an AI optimizes for the literal ask — it does tasks well but has no way to judge whether those tasks are the *right* ones. It can't weigh a request against where you're heading, can't flag when an ask cuts against your priorities, and can't distinguish "done" from "done in a way that serves you."

The TELOS doc fixes that. It's a single file that answers: What am I fundamentally building toward? What's in flight and what matters most right now? What do I value in *how* things get done? What's my quality bar? What can't be compromised? Who and what are the key facts?

Once wired in, your AI loads the TELOS at session start and steers by it — serving where you're going, not just the literal surface of your request.

## What the TELOS captures

| Section | What it holds |
|---|---|
| **Mission** | Your throughline — the deeper why under the projects |
| **Active threads + priority** | What's in flight; which 2–3 matter most this season |
| **Values** | What to optimize toward in *how* work gets done |
| **What "good" looks like** | Your quality bar and taste — right vs. merely done |
| **Constraints** | What the AI must never cut against |
| **Context map** | Key people, ventures, environment — facts, not goals |

## It's a living doc

The TELOS isn't a mission statement carved in stone. Priorities shift. Threads close. New ones open. Revisit it when something significant changes — a project wraps, a season turns, a value gets stress-tested. The AI will propose edits; you confirm them.

## What ships

| File | Purpose |
|---|---|
| `src/telos.template.md` | Blank north-star template with `${PLACEHOLDER}`s and interview questions |
| `src/steering-instruction.md` | Snippet that wires the TELOS into the AI's load path |
| `INSTALL.md` | Step-by-step instructions for an AI installer |
| `VERIFY.md` | Checklist for an AI to confirm the installation succeeded |

## When to use this pack

- Your AI does tasks fine but doesn't know what game you're actually playing.
- You've had to re-explain your priorities in session after session.
- You want the AI to push back (or lean in) based on your real goals, not just comply with whatever you typed.

## When not to use it

- You want a blank-slate assistant with no persistent context. This pack gives the AI a steering frame — skip it if you prefer every session to start cold.
