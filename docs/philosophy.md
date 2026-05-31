# Philosophy

These are the ideas Keel teaches — the principles behind every pack, every template, every default.

---

## 1. Identity is pattern, not substance

A persistent AI is its memory, its laws, and its voice — not the model it runs on or the machine it runs from. Swap the underlying model and the identity persists, because what persists is the accumulated context and the operating principles that shape behavior. This is what makes a "model upgrade" a non-event rather than a loss: if the pattern is written down, the pattern survives.

## 2. Text over opaque storage

Store everything in plain markdown. The filesystem is the index; `rg` and `grep` are your query engine. If you can't `cat` a file and read it in a terminal, it has no place in a durable memory system. Transparent, human-readable storage is parsable by both you and your AI — no proprietary formats, no lock-in, no black boxes.

## 3. Memory that compounds

Capture the non-obvious: decisions made, preferences discovered, the *why* behind a choice. Never save what the codebase or git history already holds — that content rots the moment the code changes. Memory that only restates what is already knowable from other sources is noise, not signal, and it degrades the quality of every future retrieval.

## 4. Least privilege by default

Scope permissions narrowly from the start. A well-designed profile distinguishes what the AI may do freely (allow), what it must refuse (deny), and what requires a human check-in before proceeding (ask). The profile is a real operational boundary, not a suggestion — and expanding it should require deliberate intent, not drift.

## 5. Propose before acting

Match the level of action to the nature of the ask. Read-only and easily reversible work can proceed directly; anything state-changing, multi-step, or irreversible should be proposed first and confirmed before execution. Keeping the human in the loop is not a limitation — it is the mechanism by which trust is built and scope creep is prevented.

## 6. Steer by a north star

Without an articulated purpose — a stated mission, a ranked set of priorities, a set of values — an AI has nothing to optimize against except the literal content of the last message. It can execute tasks competently while systematically working on the wrong things. A TELOS document gives the AI a persistent answer to the question: "Is this the right task, not just a well-executed one?"

## 7. Lean over bloated

The right size for a system shrinks as the underlying models improve. Ship the minimum context needed to produce the right behavior; remove prescription the model no longer needs. A heavy framework that was necessary two model generations ago becomes drag — it obscures intent, inflates prompts, and slows iteration. The system should get smaller over time, not larger.

---

*This set of principles converges with the thinking behind Daniel Miessler's PAI (Personal AI Infrastructure) project — independent paths, same conclusions.*
