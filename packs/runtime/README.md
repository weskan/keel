# runtime pack

Take an agent that works when you run it by hand, and make it run on its own —
on a schedule, or continuously, with nobody watching.

## What changes when nobody is watching

An interactive agent and a scheduled one are not the same program with a
different trigger. Four things break in the transition, and they break quietly:

**1. Nobody answers a prompt.** Any permission that resolves to "ask" becomes a
wall. Install the `bounded-profile` pack's unattended profile first — this pack
assumes it.

**2. The environment is not your shell.** A scheduled job starts from a minimal
environment: not your interactive `PATH`, not your shell profile, not your
version-manager shims, often not even your `HOME` the way you expect. The
classic symptom is a command that works perfectly when you type it and is "not
found" on schedule. **Use absolute paths to every binary**, and set what you
need explicitly in the job definition rather than assuming it is inherited.

**3. Failure has no audience.** When you run something by hand you see the
error. A scheduled job's failure goes to a log file nobody opens. Every job in
this pack writes to a log *and* has an explicit path for surfacing failure to a
human — see the notification section in `INSTALL.md`.

**4. The operating system may refuse things it allows you.** This is the one
that costs people the most time; it gets its own section.

## The permission trap: "works by hand, fails on schedule"

On macOS, access to protected resources — the local network, your Documents
folder, external volumes, the camera, and others — is granted per-binary by the
OS privacy system, and grants are typically issued in response to a prompt in a
graphical session.

A background job has no graphical session, so it cannot prompt. It is simply
denied. The failure surfaces as a generic permission error, a hang, or an empty
result — almost never as "you are missing an OS privacy grant," which is what it
actually is.

**The rule: if a job works when you run it in a terminal and fails when the
scheduler runs it, suspect an OS permission grant before you suspect your
code.** Grant it to the *binary that actually executes* (the interpreter, not
your script), and be aware that an unsigned interpreter can lose its grant when
it is upgraded, while a signed application binary usually keeps it.

Linux has a milder version of the same class of problem (a service running as a
different user, a restrictive systemd sandbox, SELinux). Windows has its own
(a scheduled task's "run whether user is logged on or not" mode has no access to
mapped drives or the user's credential store). The lesson generalizes: **the
scheduler runs your job as a different principal than your terminal does.**

## Scope of this pack

This pack covers the **macOS** path in detail, with a working launch-agent
template, because that is the platform where the permission trap is sharpest. It
sketches the Linux and Windows equivalents rather than shipping templates for
them — the concepts transfer directly, the file formats do not.

## Files in this pack

| File | Purpose |
|---|---|
| `src/agent-job.plist.template` | macOS launch-agent definition (schedule or keep-alive) |
| `src/run-agent-job.sh` | Wrapper: absolute paths, logging, loud failure |
| `INSTALL.md` | Step-by-step instructions for an AI installer |
| `VERIFY.md` | Checklist, including the works-by-hand-fails-on-schedule test |
