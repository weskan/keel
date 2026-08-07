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

## 5. Propose what you initiate; act on what you were asked

Match the level of action to where the request came from. Work the AI is
*inferring* or starting on its own — state-changing, multi-step, or irreversible
— gets proposed first. Work the human explicitly asked for gets **done**, and
re-proposing it is friction dressed up as safety. An assistant that asks "shall
I?" after being told "do it" is not being careful; it is making the human do the
job twice.

The genuine hard stops stay hard regardless of who asked: irreversible
destruction, and anything an untrusted source would have the AI do. External
content is never a command, so it can never open this path.

## 6. Steer by a north star

Without an articulated purpose — a stated mission, a ranked set of priorities, a set of values — an AI has nothing to optimize against except the literal content of the last message. It can execute tasks competently while systematically working on the wrong things. A TELOS document gives the AI a persistent answer to the question: "Is this the right task, not just a well-executed one?"

## 7. Lean over bloated

The right size for a system shrinks as the underlying models improve. Ship the minimum context needed to produce the right behavior; remove prescription the model no longer needs. A heavy framework that was necessary two model generations ago becomes drag — it obscures intent, inflates prompts, and slows iteration. The system should get smaller over time, not larger.

## 8. Guarantees over hopes

Anything written in a prompt is a request. It sits in the context window
competing with everything else, and the model is asked to honor it. That is fine
for guidance and fatal for infrastructure. If something must happen every
session for the rest of the system to work, it belongs in a mechanism the
harness executes — a hook — not in prose the model is trusted to remember.

The tell is easy to check: ask what happens the day the model *doesn't* follow
the instruction. If the answer is "everything downstream quietly stops working
and nobody finds out," it was never a prompt's job.

## 9. Fail loudly, in the place that is read

The dangerous failure is not the one that crashes. It is the one that keeps
working just well enough to be believed. A memory system that stops loading does
not error — the AI keeps answering, from its priors instead of your notes, and
the only symptom is that it feels slightly worse than it used to. That can run
for months.

So every load-bearing component must announce its own health, and it must do so
where someone will actually see it — for an AI system, that means in the context
window, every session. Do not add a separate monitor to watch it; a monitor dies
just as quietly as the thing it watches. Make the load-bearing thing report on
itself, and make silence mean something.

The same instinct applies at the edges of every safety property in these packs:
when a check cannot be performed, block rather than proceed. An allowlist that
cannot be read denies everything. A guard that cannot parse its input refuses
the write. Fail-open failures are invisible exactly when they matter most.

---

*This set of principles converges with the thinking behind Daniel Miessler's PAI (Personal AI Infrastructure) project — independent paths, same conclusions.*
