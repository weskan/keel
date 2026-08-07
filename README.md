# Keel

**A persistent, personalized AI you own — your Claude installs it for you.**

Point your Claude at this repo and say *"read START-HERE.md and set up what helps me."* Claude reads the packs, proposes what fits your situation, and installs them — interviewing you for anything personal. You end up with a Claude that remembers you across sessions, speaks in your register, operates within boundaries you set, and stays oriented toward what you actually care about.

---

## What this is

Keel is a collection of AI-installable **packs** — structured files your Claude can read, understand, and apply to configure itself for you. Each pack covers one dimension of a personalized AI:

| Pack | What it gives you |
|---|---|
| **memory** | A durable memory system across sessions — facts, preferences, decisions, domain knowledge. |
| **hooks** | Turns load-bearing instructions into things the harness *guarantees*, instead of things the model is asked to remember. Required alongside `memory`. |
| **persona** | A voice and interaction style calibrated to how you think and communicate. |
| **bounded-profile** | A permission profile that keeps your Claude in its lane — what it can do autonomously vs. what needs your sign-off. |
| **telos** | A north-star document (TELOS) — your values, priorities, and long-term intentions, so Claude can reason in your direction. |
| **knowledge-vault** | A plain-markdown knowledge base that is yours first — notes that outlive the tooling, and that Claude reads and writes on your behalf. |
| **runtime** | Everything needed to run an agent on a schedule or continuously, including the failure modes that only appear once nobody is watching. |
| **peer-escalation** | A safe consult channel between two or more agents, so the one talking to you can reach the one that knows. |

Nothing here is pre-filled with anyone's personal data. The packs are scaffolds. Claude interviews you, populates them for your situation, and installs them.

---

## How to use it

1. Clone or point Claude at this repo.
2. Say: *"Read `START-HERE.md` and set up what helps me."*
3. Claude reads the packs, asks you what it needs to know, and proposes an installation plan.
4. Approve, adjust, and let it run.

Install every pack or just the ones that fit. Start with `memory` + `hooks` if
you are not sure — that pairing is the foundation the rest builds on.

---

## What's inside

```
packs/
  memory/          # Memory system scaffold and install instructions
  hooks/           # SessionStart / PreToolUse hooks — guarantees, not requests
  persona/         # Persona and voice calibration scaffold
  bounded-profile/ # Permission profile scaffold (attended + unattended)
  telos/           # North-star / values document scaffold
  knowledge-vault/ # Plain-markdown knowledge base above the memory tiers
  runtime/         # Scheduled / always-on agent operation
  peer-escalation/ # Agent-to-agent consult channel
tools/
  sanitize-check.sh  # Gate: fails if any personal data appears in the repo
docs/
  philosophy.md    # Design principles behind Keel
START-HERE.md      # Entry point — Claude reads this first
```

Every pack has the same anatomy: `README.md` (why, for a human), `INSTALL.md`
(how, addressed to the installing AI), `VERIFY.md` (proof it worked), and `src/`
(templates with `${PLACEHOLDER}`s).

Most packs are independent. Two dependencies matter: **`memory` requires
`hooks`** (without it the global tier never loads), and **`runtime` requires the
unattended profile from `bounded-profile`** (with no human present, `ask` is a
wall rather than a prompt).

---

## Principles

Keel is built on the premise that your AI configuration is yours — portable, inspectable, and free of lock-in. See [`docs/philosophy.md`](docs/philosophy.md) for the full design rationale.

---

## Credits

Inspired by the "Packs" model in Daniel Miessler's [PAI (Personal AI Infrastructure)](https://danielmiessler.com/p/pai-personal-ai-infrastructure-what-it-is-and-how-to-build-one/).

---

## License

MIT — see [LICENSE](LICENSE).
