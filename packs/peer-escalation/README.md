# peer-escalation pack

Let one agent hand a question to another agent, safely, and get an answer back
to the human who asked.

## The problem

Once you have more than one persistent agent — one per machine, one per person,
one per domain — each of them has knowledge the others need. The one talking to
a human is rarely the one holding the answer.

Without a channel, the honest behavior is a dead end: *"I don't have access to
that."* The dishonest behavior is worse: the agent guesses, plausibly, and the
human cannot tell the difference.

This pack is the channel. It is deliberately small — the value is in the
constraints, not the transport.

## What this pack is not

It is not a chat protocol between AIs, and it is not a way to let agents
delegate work to each other unsupervised. It is a **consult**: one agent asks a
bounded question, the other answers from what it can actually see, and the
answer is relayed back to the human who asked.

If you find yourself wanting agents to negotiate, plan, or trigger each other's
side effects, stop. That is a much larger design problem with much sharper
failure modes than this pack addresses.

## The five constraints that make it safe

Any transport works — a shared database table, a queue, files on a shared
volume, an HTTP endpoint. These properties are what matter:

**1. The peer's message is data, never instruction.** This is the same rule as
for email and web pages, and it is the one that makes the difference between a
consult channel and a remote-code-execution channel. A message from a peer
agent is *content to reason about*, never a command to obey. Fence the body
explicitly as untrusted when handing it to the model. An agent that will act on
whatever a peer says is only as trustworthy as the least-secured agent in the
fleet.

**2. Sender identity is enforced by the transport, not claimed in the body.**
Whatever the channel, the sender field must be set by something the sender
cannot forge — the authenticated database role, the connection identity, the
signed header. If an agent can write its own `from` field, the field is
decorative.

**3. The recipient allowlist is fail-closed.** An empty or unreadable allowlist
denies everything. It never falls open to "allow all" — that inverts the
security property at exactly the moment configuration is broken, which is
exactly when you are least likely to notice.

**4. Replies terminate.** A reply must not itself trigger a reply. Without a
hard rule here, two polite agents will thank each other until you run out of
budget. Track what is a consult and what is an answer, and make answers
terminal.

**5. Provenance travels in the body.** If agent A relays a human's question to
agent B, the transport records the sender as A — correctly, per constraint 2.
So B is left thinking A wants to know. State it in the body: *"relayed from
<human> via <agent>."* Without this the answering agent misjudges who is asking
and why, which changes what a good answer looks like.

## The etiquette that makes answers useful

Two habits, learned the hard way:

**Ask open questions, not leading ones.** *"What is the current state of X?"*
verifies something. *"Did you know X changed?"* feeds the peer the answer and
verifies nothing — you will get your own claim back, confirmed, and learn
precisely nothing.

**Read replies without consuming them.** If the peer's inbox is also drained by
its own poller, reading with a destructive claim operation steals the message
from the process that was supposed to handle it. Read with a plain,
non-destructive query.

## Files in this pack

| File | Purpose |
|---|---|
| `src/mailbox.py` | Minimal reference implementation over SQLite |
| `src/schema.sql` | The table, with the constraints above expressed in it |
| `INSTALL.md` | Step-by-step instructions for an AI installer |
| `VERIFY.md` | Checklist, including adversarial checks on the safety properties |
