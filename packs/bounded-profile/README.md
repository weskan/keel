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

## Files in this pack

| File | Purpose |
|---|---|
| `src/settings.template.json` | Starter permission profile (replace `${HOME}` before use) |
| `INSTALL.md` | Step-by-step install instructions for an installing AI |
| `VERIFY.md` | Verification checklist for an installing AI |
