# Install: runtime pack

**You are an AI installing this for your user.** This pack turns a working
agent into a scheduled or always-on one.

**Prerequisite:** install the `bounded-profile` pack's **unattended** profile
first (`src/settings.unattended.template.json`). An unattended agent with `ask`
rules will wall on its first state-changing action, with nobody to answer. Do
not proceed until that is done.

---

## Step 1 — Establish what actually runs

Ask the user, and write the answers down before touching any file:

1. **What command runs the agent?** You need the full command line.
2. **Where is its binary?** Get the absolute path — `command -v <name>`. A bare
   name is not good enough; a scheduled job does not inherit the user's `PATH`.
3. **Schedule or continuous?** Every N seconds / at a fixed time, versus running
   forever and restarting on exit.
4. **What does it touch?** Network, the local network specifically, files
   outside its own directory, external volumes, other machines. This drives
   Step 5, and getting it wrong is the most expensive mistake in this pack.
5. **Where should failures go?** A channel the user actually reads.

---

## Step 2 — Prove it works by hand first

```bash
<the full command from Step 1>
```

Do not schedule a job that has never run successfully. If it fails here, fix
that before continuing — debugging a broken command through a scheduler is
dramatically harder than debugging it directly.

---

## Step 3 — Install the wrapper

```bash
mkdir -p ~/.agent/bin ~/.agent/logs
```

Copy `src/run-agent-job.sh` to `~/.agent/bin/run-agent-job.sh` and `chmod +x`
it. Fill in every `${PLACEHOLDER}`:

- `AGENT_BIN_PATH` — the absolute path from Step 1.
- `AGENT_ARGS` — the arguments, or empty.
- `JOB_NAME` — a short slug used for log filenames.
- `NOTIFY_COMMAND` — the user's real failure channel. If they do not have one
  yet, leave the marker-file default and **tell them explicitly** that failures
  will be silent apart from a file in the log directory.

---

## Step 4 — Install the scheduler definition

**macOS.** Copy `src/agent-job.plist.template` to
`~/Library/LaunchAgents/<label>.plist`, substituting `${JOB_LABEL}`,
`${JOB_NAME}`, `${AGENT_BIN_PATH}`, and either `${INTERVAL_SECONDS}` or the
`KeepAlive` block. Use reverse-DNS for the label. Then load it:

```bash
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/<label>.plist
launchctl print gui/$(id -u)/<label> | head -20
```

Look for a running or scheduled state and, critically, for a **non-zero exit
code from a previous run** — that is the fastest signal that something is wrong.

**Linux.** Use a systemd user unit plus a timer (`systemctl --user`). The same
principles apply: set `Environment=` explicitly, use absolute paths, and enable
lingering if the job must run while the user is logged out.

**Windows.** Use Task Scheduler. Note that "run whether user is logged on or
not" runs in a session with no access to mapped network drives or the user's
credential store — the direct analogue of the macOS trap in Step 5.

---

## Step 5 — Grant OS permissions, deliberately

Look at the answers to Step 1.4. If the job touches the local network, the
user's documents, external volumes, or any other protected resource, it needs an
OS privacy grant — and **a background job cannot prompt for one**, because it
has no graphical session.

On macOS the grant attaches to the **binary that actually executes**, which is
the interpreter, not your shell script. Tell the user plainly:

- Which binary needs the grant.
- Which permission (Local Network, Full Disk Access, Files and Folders).
- That they must grant it themselves through System Settings — you cannot, and
  no amount of retrying will make the job succeed without it.
- That an unsigned interpreter may **lose** the grant when it is upgraded, so a
  job that has run for months can start failing after an unrelated update.

Do not skip this conversation because the job appears to work. It may be working
only because you last ran it by hand.

---

## Step 6 — Confirm it runs on the scheduler, not just in your terminal

Trigger a real scheduled run and read the log:

```bash
launchctl kickstart -k gui/$(id -u)/<label>
tail -20 ~/.agent/logs/<job-name>.log
```

The distinction that matters: **it ran under the scheduler**, not that the same
command works in your shell. Those are different environments and Step 2 already
proved the second one.

---

## Summary of files written

| Path | What it is |
|---|---|
| `~/.agent/bin/run-agent-job.sh` | The wrapper: absolute paths, locking, loud failure |
| `~/.agent/logs/` | Log directory |
| `~/Library/LaunchAgents/<label>.plist` | macOS scheduler definition |
