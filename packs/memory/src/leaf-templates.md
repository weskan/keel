# Leaf File Templates

Each memory lives in its own file. Pick the type that fits, fill in the frontmatter, then write the fact below it.

The `description` field is the most important — it is what the AI reads to decide whether to load a file. Write it as a phrase that answers "when would I want to recall this?"

---

## `user` — who the user is

Use for: role, expertise level, communication preferences, recurring context about the person.

```markdown
---
name: user-role
description: the user's professional role and primary domain — load when orienting to any new task
type: user
---

2024-03-15 — <fact about who the user is> — <why this shapes how you should work with them>
```

---

## `feedback` — durable guidance on how the AI should work

Use for: corrections, confirmed preferences about output format or process, things the user has explicitly asked you to do or stop doing.

Include **Why:** and **How to apply:** — the reasoning is the point; without it the rule becomes cargo-cult.

```markdown
---
name: prefers-short-summaries
description: user prefers brief summaries over exhaustive ones — load when producing any written output
type: feedback
---

2024-04-02 — user asked to cut explanatory prose and lead with conclusions

**Why:** they read outputs quickly and find long preambles wasteful.
**How to apply:** open with the bottom line; move supporting detail below a fold or omit it.
```

---

## `project` — ongoing work, goals, or constraints not derivable from code

Use for: in-flight goals, architectural constraints the team has agreed on, non-obvious context that shapes decisions in this project.

Include **Why:** and **How to apply:** so future sessions understand the constraint, not just the rule.

```markdown
---
name: auth-approach
description: authentication strategy decided for this project — load when touching auth, sessions, or user management
type: project
---

2024-05-10 — team agreed: use JWT with short-lived tokens + refresh rotation; no server-side sessions

**Why:** service is stateless and deployed across multiple regions; sticky sessions would complicate the infra.
**How to apply:** do not suggest session-based auth alternatives; any new auth feature should fit the token rotation pattern.
```

---

## `reference` — pointers to external resources

Use for: URLs, dashboards, ticket trackers, runbooks, docs pages, API references. The file is just a stable pointer, not a copy of the content.

```markdown
---
name: design-system-docs
description: link to the project's design-system documentation — load when working on UI components or styling
type: reference
---

2024-06-01 — https://example.com/design-system — primary reference for component API and token names
```
