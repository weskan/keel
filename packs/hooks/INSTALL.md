# Install: hooks pack

**You are an AI installing this for your user.** Follow these steps in order.
Show the user what you plan to write and get a clear yes before touching any
file.

This pack assumes the `memory` pack is installed, or is being installed in the
same session. If the user has no global memory root, install `memory` first —
otherwise this hook will correctly report that the root is missing on every
session, which is accurate but not useful.

---

## Step 1 — Determine the platform and the shell

Ask, or detect:

```bash
uname -s 2>/dev/null || echo "Windows"
```

- `Darwin` or `Linux` → use `src/inject-memory-index.sh`.
- Windows → decide which shell will run the hook, and be explicit about it.

**Do not skip the Windows shell question.** A hook's `command` string is passed
to a shell: `sh -c` on macOS and Linux, **Git Bash on Windows — or PowerShell if
Git Bash is not installed**. That means the Bash script works unchanged on a
Windows machine with Git for Windows, and on a machine without it the identical
config silently hands a Bash script to PowerShell.

Check:

```bash
where git 2>NUL
```

Recommend the PowerShell script on Windows unless the user already depends on
Git Bash. Not depending on Git Bash is the more durable choice on a machine the
user does not administer.

---

## Step 2 — Create the hooks directory and copy the script

```bash
mkdir -p ~/.claude/hooks
```

Copy the script for the user's platform from this pack's `src/` into
`~/.claude/hooks/`, then make the shell version executable:

```bash
chmod +x ~/.claude/hooks/inject-memory-index.sh
```

If the user's global memory root is somewhere other than `~/.claude/memory`,
do not edit the script — it reads `KEEL_MEMORY_DIR` if set. Note this for the
user rather than forking the file.

---

## Step 3 — Test the script standalone, before wiring it up

This is not optional. A hook that fails only inside a session is painful to
diagnose, and the whole point of this pack is to avoid silent failure.

macOS / Linux:

```bash
bash ~/.claude/hooks/inject-memory-index.sh | head -c 400
```

Windows:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$env:USERPROFILE\.claude\hooks\inject-memory-index.ps1"
```

You want a single line of JSON whose `additionalContext` contains the top of the
user's memory index.

**If anything appears before the opening `{`, the hook is broken.** A stray
`echo`, a shell profile banner, or a warning from a version manager will corrupt
the payload. Fix that before continuing.

If the output is one of the `WARNING:` messages instead, that is the script
working correctly and telling you the memory root or index is missing. Resolve
that first.

---

## Step 4 — Merge the hooks block into settings.json

**4a. Back up first.**

```bash
cp ~/.claude/settings.json ~/.claude/settings.json.bak
```

If the file does not exist, skip the backup and create it fresh.

**4b. Read the existing file.** Identify every key outside `hooks` —
`permissions`, `model`, `statusLine`, `theme`, anything else. You must preserve
all of them. If a `hooks` key already exists, you are **adding an entry to the
existing `SessionStart` array**, not replacing it. Clobbering a user's existing
hooks is the worst outcome of this install.

**4c. Compose the merged JSON** using `src/settings.hooks.template.json` as the
shape. Delete the platform entry that does not apply, and strip every
`_comment` key — they are documentation, not configuration.

For the Windows entry, substitute a **literal absolute path**. In exec form
(when `args` is present) there is no shell, so `~` and `%USERPROFILE%` are
passed through verbatim and will not resolve.

**4d. Validate before writing.**

```bash
python3 -m json.tool < /tmp/keel-settings-candidate.json > /dev/null && echo VALID || echo INVALID
```

Do not write if this fails.

**4e. Write** the merged JSON to `~/.claude/settings.json`.

---

## Step 5 — Optional: the protected-path guard

Only if the user wants a directory mechanically protected from writes.

Copy `src/guard-protected-path.sh` into `~/.claude/hooks/`, `chmod +x` it, and
keep the `PreToolUse` block from the template. Ask the user which path segment
to protect and set `KEEL_PROTECTED_SEGMENT` accordingly — the default is `/raw/`.

Tell the user plainly that this guard depends on `jq` or `/usr/bin/python3`
being present, and that it blocks with an explanation if neither is.

---

## Step 6 — Confirm it fires in a real session

Tell the user to **start a fresh session** — `SessionStart` does not re-fire in
the current one — and ask their AI:

> What global memory index do you have?

If it cannot quote the index back, the hook is not firing. Run `VERIFY.md`.

---

## Summary of files written

| Path | What it is |
|---|---|
| `~/.claude/hooks/inject-memory-index.sh` or `.ps1` | The SessionStart injector |
| `~/.claude/hooks/guard-protected-path.sh` | Optional PreToolUse write guard |
| `~/.claude/settings.json` | Merged, with the previous version at `.bak` |
