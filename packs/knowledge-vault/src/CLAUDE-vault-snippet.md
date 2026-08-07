## Knowledge Vault (`${VAULT_PATH}`)

Substantive knowledge lives here. This is the **third tier** above the two memory
roots, and it is **authoritative** for anything substantive — projects, people,
concepts, domain expertise, decisions and their reasons. The memory roots hold
agent-internal state; the vault holds knowledge. When the two disagree on
something substantive, the vault wins and the memory entry gets corrected.

### Read/write boundary (strict)

- **`raw/` is the user's inbox — read-only for me.** Never edit, rename, or
  delete anything in `raw/`. It is their unfiltered input; if I can rewrite it,
  they lose the ability to tell what they said from what I inferred. To act on
  something in `raw/`, distill it into a new `wiki/` note.
- **`wiki/`, `journal/`, and `content/` are writable.**

### Read triggers — check the vault proactively when

- The conversation touches a domain the vault tracks — look for a matching note
  in `wiki/projects/` or `wiki/concepts/` **before** answering.
- A specific person, project, or concept is named — check
  `wiki/{people,projects,concepts}/{slug}.md`.
- The user asks what they know or decided about something — vault first, web
  second.
- **Before recommending an approach, tool, or framing** in one of these domains
  — check for prior thinking, so I do not re-propose something already rejected.

### Write triggers — capture into the vault when

- The user states something substantive that is not yet in `wiki/`.
- A session produces a durable decision, design, or lesson. Record the **why**,
  including the options rejected — that is the part nobody writes down and
  everybody re-argues later.
- Significant distillations get a dated line in `journal/`.

### Conventions

- Filenames: `lowercase-hyphenated.md`.
- Links: `[[note-name]]`. Link generously; a link to a note that does not exist
  yet is fine — it marks something worth writing.
- Dates: ISO (`YYYY-MM-DD`). Never relative — "last Thursday" is meaningless the
  moment it is written.
- One concept per note. Split a note that is trying to be two things.
- Voice: first person, terse, direct. No throat-clearing.
- Frontmatter: minimal (`created`, `tags`, `status`, `description`) or none.

### Honesty about sourcing

When I state something that came from the vault rather than from what I observed
this session, name the note it came from. If I searched the vault and found
nothing, say "I don't have that recorded" rather than filling the gap with
something plausible. A note is a claim about the past: if it names a file, tool,
or decision, verify that is still true before acting on it, and fix the note when
it is not.
