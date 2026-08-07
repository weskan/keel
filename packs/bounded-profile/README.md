# bounded-profile pack

A least-privilege permission profile for Claude Code. Start locked down; justify every grant.

---

## The permission model

Claude Code's `~/.claude/settings.json` accepts a `permissions` object with three arrays:

| Array | Effect |
|---|---|
| `allow` | Auto-approved, no prompt |
| `deny` | Hard-blocked — **deny overrides allow, always** |
| `ask` | Prompts you for a one-click confirm each use |

**deny beats allow with no exceptions.** If a rule appears in both `allow` and `deny`, it is blocked. This is intentional: the deny floor is your circuit breaker.

---

## The three tiers and their purpose

### deny — the hard floor

These are operations that are destructive or irreversible: recursive deletes, forced git pushes, privilege escalation. They should never happen without you initiating them yourself. Putting them in `deny` means even a runaway or confused AI cannot trigger them, regardless of what is in `allow`.

The hard floor is not negotiable. Every profile should have at minimum:
- `Bash(rm -rf:*)` — recursive forced deletion
- `Bash(rm -r:*)` — recursive deletion
- `Bash(sudo:*)` — privilege escalation
- `Bash(git push --force:*)` — history-rewriting push

Add to this list anything specific to your environment that is irreversible — `terraform destroy`, service teardowns, credential resets.

### ask — the human gate

These are state-changing operations that are legitimate but warrant a one-second deliberate confirmation from you: committing code, pushing to a remote, writing files. You want the AI to be able to do these things, but you want to see each one before it happens.

`ask` is the right tier for anything where "oops, I didn't mean to" has real cost, but where blocking outright would make the AI useless.

### allow — trusted commands

These are operations so routine and low-risk that stopping to prompt every time creates friction without safety benefit: reading files, running `ls`, running `git status`, grepping. Reads are almost always safe. Non-mutating git commands are safe.

**The principle: be as narrow as possible.** A blanket `Bash(*)` in `allow` defeats the entire model — it allows the AI to run anything without prompting. Instead of allowing all of `~/**`, narrow to the directories you actually work in. Instead of allowing all bash commands, enumerate the ones you actually use.

---

## Why a narrow profile beats a broad one

**Blast-radius containment.** If the AI makes a mistake — misreads intent, acts on bad context, or is manipulated by malicious input in a file it reads — a narrow profile limits what that mistake can touch. A broad `allow` gives the AI a large attack surface; a narrow one limits damage to a small, well-understood set of operations.

**Auditability.** A short `allow` list is readable. You can look at it and verify it makes sense for your situation. A long, permissive list is opaque.

**Principle of least privilege.** Grant the minimum access needed to do the work. Expand only when a specific need arises and you understand the risk.

---

## Two profiles, because `ask` means different things

Before composing anything, establish **whether a human is present when this
agent runs.** The answer changes the shape of the profile, not just its
contents.

**Interactive agent** — a human is at the keyboard. `ask` works as designed: a
one-click confirm on state-changing operations. This is the default, and
`src/settings.template.json` is its starting point.

**Unattended agent** — a scheduled job, a poller, a background worker. Here
**`ask` is not a prompt, it is a wall.** There is nobody to click. The turn
stops, and it stops in a way that reads like the agent failing at the task
rather than waiting for consent — so the failure is easy to misdiagnose for a
long time. Use `src/settings.unattended.template.json`, which has a deliberately
empty `ask` array.

That empty array is the point, not an oversight. With no middle tier, every
capability has to be sorted into allowed or denied *in advance, in writing, by a
human*. The decision gets made deliberately instead of discovered at 3am.

**The trap to avoid:** an unattended agent gets stuck, someone traces it to a
permission wall, and widens `allow` until the wall disappears. That is how a
least-privilege profile quietly becomes a broad one. Widen a profile because you
decided the agent should have that capability — never to silence a prompt.

## Files in this pack

| File | Purpose |
|---|---|
| `src/settings.template.json` | Starter profile for an **interactive** agent (replace `${HOME}` before use) |
| `src/settings.unattended.template.json` | Starter profile for an **unattended** agent — empty `ask` by design |
| `INSTALL.md` | Step-by-step install instructions for an installing AI |
| `VERIFY.md` | Verification checklist for an installing AI |
