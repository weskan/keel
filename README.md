# Keel

**A persistent, personalized AI you own — your Claude installs it for you.**

Point your Claude at this repo and say *"read START-HERE.md and set up what helps me."* Claude reads the packs, proposes what fits your situation, and installs them — interviewing you for anything personal. You end up with a Claude that remembers you across sessions, speaks in your register, operates within boundaries you set, and stays oriented toward what you actually care about.

---

## What this is

Keel is a collection of AI-installable **packs** — structured files your Claude can read, understand, and apply to configure itself for you. Each pack covers one dimension of a personalized AI:

| Pack | What it gives you |
|---|---|
| **memory** | A durable memory system across sessions — facts, preferences, decisions, domain knowledge. |
| **persona** | A voice and interaction style calibrated to how you think and communicate. |
| **bounded-profile** | A permission profile that keeps your Claude in its lane — what it can do autonomously vs. what needs your sign-off. |
| **telos** | A north-star document (TELOS) — your values, priorities, and long-term intentions, so Claude can reason in your direction. |

Nothing here is pre-filled with anyone's personal data. The packs are scaffolds. Claude interviews you, populates them for your situation, and installs them.

---

## How to use it

1. Clone or point Claude at this repo.
2. Say: *"Read `START-HERE.md` and set up what helps me."*
3. Claude reads the packs, asks you what it needs to know, and proposes an installation plan.
4. Approve, adjust, and let it run.

You can install all four packs or just the ones that make sense for you. Each is independent.

---

## What's inside

```
packs/
  memory/          # Memory system scaffold and install instructions
  persona/         # Persona and voice calibration scaffold
  bounded-profile/ # Permission profile scaffold
  telos/           # North-star / values document scaffold
tools/
  sanitize-check.sh  # Gate: fails if any personal data appears in the repo
docs/
  philosophy.md    # Design principles behind Keel
START-HERE.md      # Entry point — Claude reads this first
```

> Note: `START-HERE.md`, the pack directories, and `docs/philosophy.md` are created in subsequent tasks. The scaffold above shows the intended structure.

---

## Principles

Keel is built on the premise that your AI configuration is yours — portable, inspectable, and free of lock-in. See [`docs/philosophy.md`](docs/philosophy.md) for the full design rationale.

---

## Credits

Inspired by the "Packs" model in Daniel Miessler's [PAI (Personal AI Infrastructure)](https://danielmiessler.com/p/pai-personal-ai-infrastructure-what-it-is-and-how-to-build-one/).

---

## License

MIT — see [LICENSE](LICENSE).
