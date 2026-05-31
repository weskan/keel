# Install: bounded-profile pack

You are an AI installing this pack for a user. Your job is to compose a narrow, accurate permission profile for their specific situation and merge it into their existing settings without clobbering anything.

Show the user what you plan to write before each write step. Do not write blindly.

> **Non-standard home:** All paths below assume the user's home is `~`. If installing to a non-standard or test home, substitute that base for `~` in every path.

---

## Step 1 — Assess the user's actual workflow

Before composing any profile, ask the following. Do not guess — wrong answers produce a profile that either locks the user out of their own tools or is too permissive to be useful.

**Ask:**

1. What languages and build tools do you use day-to-day? (e.g., Python/pip, Node/npm, Go, Rust/cargo, Ruby/bundle)
2. Which directories do you work in? (e.g., `~/code`, `~/projects/myapp`, a specific monorepo path — be as specific as possible)
3. Are there any commands you run constantly that you want auto-approved? (e.g., `pytest`, `npm test`, `make build`, `ruff check`)
4. Are there any operations specific to your environment that are especially dangerous? (e.g., `terraform destroy`, `kubectl delete`, database migrations, service restart commands)
5. Do you use any CI tools, container runtimes, or infra CLIs that the AI should be aware of?

Record their answers. You will use them in Step 2.

---

## Step 2 — Compose a narrow `allow` list

Use their answers to build an `allow` list that covers only what they actually need auto-approved.

**Rules for composing `allow`:**

- **Never add a bare `Bash` or `Bash(*)`** — that allows the AI to run any command without prompting. This defeats the model entirely.
- **Scope reads to their actual working directories**, not a blanket home-directory wildcard, if you can be tighter. If they only work in `~/code`, use `Read(//Users/username/code/**)` not `Read(//${HOME}/**)`.
- Include safe, non-mutating commands they run constantly: `ls`, `cat`, `grep`, `rg`, `git status`, `git diff`, `git log`, their test runner in read/report mode if applicable.
- Include build commands only if they are truly non-destructive (e.g., `npm run build` that writes to a local `dist/` is low-risk; a deploy command is not).
- Keep the list short. Fewer entries means easier auditing. Add more later if a specific need arises.

**Example for a Python developer working in `~/code`:**

```json
"allow": [
  "Read(//Users/username/code/**)",
  "Bash(ls:*)",
  "Bash(cat:*)",
  "Bash(rg:*)",
  "Bash(grep:*)",
  "Bash(git status:*)",
  "Bash(git diff:*)",
  "Bash(git log:*)",
  "Bash(python:*)",
  "Bash(pip list:*)",
  "Bash(pytest:*)",
  "Bash(ruff check:*)",
  "Bash(mypy:*)"
]
```

Do not include `pip install` in `allow` — that mutates the environment; put it in `ask`.

---

## Step 3 — Set the `deny` hard floor

Start with the minimum destructive set and extend it for their environment.

**Minimum floor (always include these):**

```json
"deny": [
  "Bash(rm -rf:*)",
  "Bash(rm -r:*)",
  "Bash(sudo:*)",
  "Bash(git push --force:*)"
]
```

**Extend based on their answers:**

- If they use Terraform: add `"Bash(terraform destroy:*)"` and `"Bash(terraform apply:*)"`
- If they use kubectl: add `"Bash(kubectl delete:*)"` and `"Bash(kubectl drain:*)"`
- If they have database CLI tools: add the destructive variants (DROP, truncate, reset)
- If they use a service control tool (systemctl, launchctl, docker stop): add the destructive forms

When in doubt, add it to `deny`. The user can always move something to `ask` if they need it.

---

## Step 4 — Set the `ask` list for state-changing operations

These operations are legitimate but warrant a one-click gate. Start with the base set and add their environment-specific mutations.

**Base `ask` set:**

```json
"ask": [
  "Bash(git commit:*)",
  "Bash(git push:*)",
  "Write(//Users/username/**)",
  "Edit(//Users/username/**)"
]
```

**Add based on their workflow:**

- Package installs: `"Bash(pip install:*)"`, `"Bash(npm install:*)"`, `"Bash(brew install:*)"`
- Environment-changing commands: `"Bash(pip uninstall:*)"`, `"Bash(npm uninstall:*)"`
- File-deleting single-item commands they use (not recursive, but still irreversible): `"Bash(rm:*)"`
- Any deploy or publish commands that aren't already in `deny`

---

## Step 5 — Back up and merge into existing settings

**5a. Back up first.**

```bash
cp ~/.claude/settings.json ~/.claude/settings.json.bak
```

If `~/.claude/settings.json` does not exist, skip the backup and create it fresh.

**5b. Read the existing file.**

If the file exists, read it. Identify any keys outside `permissions` — `hooks`, `statusLine`, `model`, `theme`, or any other settings. You must preserve all of these.

**5c. Merge, do not clobber.**

Compose the final `settings.json` by:
1. Keeping all existing non-`permissions` keys exactly as they are.
2. Setting `permissions.allow`, `permissions.deny`, and `permissions.ask` to the arrays you composed in Steps 2–4.

If there are existing entries in `permissions.allow` or `permissions.ask` that the user wants to keep, include them. If there are existing entries that conflict with the deny floor you are adding, flag the conflict to the user before writing — do not silently discard their existing allow rules.

**5d. Validate before writing.**

Run:

```bash
echo '<your composed JSON>' | python3 -m json.tool > /dev/null && echo VALID || echo INVALID
```

Do not write if this fails.

**5e. Write.**

Write the merged JSON to `~/.claude/settings.json`.

---

## Step 6 — Report what was installed

Tell the user:
- What was added to `allow` and why each entry is there.
- What is in `deny` and why.
- What is in `ask` and what that means for their workflow.
- That `~/.claude/settings.json.bak` contains the pre-install state if they need to roll back.

Recommend: "Start with this profile for a week. If you find yourself dismissing `ask` prompts without reading them because they're too frequent, that's fine — we can move specific entries to `allow`. If you want tighter scoping on the read paths, we can narrow further."

---

## Summary of files written

| Path | What it is |
|---|---|
| `~/.claude/settings.json` | Merged settings with the bounded permission profile |
| `~/.claude/settings.json.bak` | Backup of pre-install settings (if one existed) |
