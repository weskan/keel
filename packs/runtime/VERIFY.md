# Verify: runtime pack

**You are an AI confirming this install worked.** Report PASS, FAIL, or SKIP per
check.

The theme: proving a job works *in your terminal* proves almost nothing about
whether it works *on the scheduler*. Checks 3 and 4 are the ones that count.

---

## Check 1 — Wrapper is installed and executable

```bash
test -x ~/.agent/bin/run-agent-job.sh && echo PASS || echo FAIL
```

---

## Check 2 — No unfilled placeholders

```bash
grep -n '\${[A-Z_]*}' ~/.agent/bin/run-agent-job.sh && echo "FAIL - placeholders remain" || echo PASS
```

A `${PLACEHOLDER}` that survives into a scheduled job becomes an empty string at
runtime, which usually means a path resolving to the wrong place rather than an
obvious error.

---

## Check 3 — The agent binary is an absolute path that exists

```bash
grep -E '^AGENT_BIN=' ~/.agent/bin/run-agent-job.sh
```

Extract the path and test it:

```bash
test -x "<the path>" && echo PASS || echo FAIL
```

FAIL, or a path that is a bare command name rather than an absolute path, is the
single most common cause of a job that works by hand and fails on schedule.

---

## Check 4 — It ran under the scheduler and exited clean

macOS:

```bash
launchctl print gui/$(id -u)/<label> 2>/dev/null | grep -E 'state|last exit code|runs'
```

- **PASS** — the job has run at least once and the last exit code is 0.
- **FAIL** — a non-zero last exit code, or no runs recorded at all.

If the last exit code is non-zero but the same command succeeds when you run it
in a terminal, **do not conclude the code is fine.** That exact pattern is the
signature of a missing OS permission grant. Go back to INSTALL Step 5.

---

## Check 5 — Failure is actually visible to a human

Break it on purpose and confirm someone would find out:

```bash
AGENT_BIN=/nonexistent/binary JOB_NAME=verify-test bash ~/.agent/bin/run-agent-job.sh
tail -5 ~/.agent/logs/verify-test.log
ls ~/.agent/logs/verify-test.FAILED
```

- **PASS** — the log records a FAILURE line, the marker file exists, and if a
  real notifier is configured, it fired.
- **FAIL** — nothing recorded. A job whose failures are invisible will fail
  invisibly, and the user will believe it is running for as long as it takes
  them to notice missing output.

Clean up:

```bash
rm -f ~/.agent/logs/verify-test.log ~/.agent/logs/verify-test.FAILED
rmdir ~/.agent/logs/verify-test.lock 2>/dev/null
```

---

## Check 6 — Overlapping runs are prevented

```bash
JOB_NAME=verify-lock bash -c 'mkdir -p ~/.agent/logs/verify-lock.lock; AGENT_BIN=/bin/echo JOB_NAME=verify-lock bash ~/.agent/bin/run-agent-job.sh; tail -1 ~/.agent/logs/verify-lock.log'
rmdir ~/.agent/logs/verify-lock.lock 2>/dev/null; rm -f ~/.agent/logs/verify-lock.log
```

- **PASS** — the log shows `SKIP: previous run still in progress`.
- **FAIL** — it ran anyway. On a job that sometimes runs longer than its
  interval, copies will stack until the machine is unusable.

---

## Summary

| Check | What it confirms |
|---|---|
| 1 | Wrapper installed and executable |
| 2 | No unfilled placeholders |
| 3 | Agent binary is absolute and exists |
| 4 | The scheduler actually ran it, and it exited clean |
| 5 | Failures reach a human instead of vanishing |
| 6 | Overlapping runs are prevented |

Checks 1–4 must PASS. Check 5 must PASS before the user relies on this job
unattended — an unattended job you cannot trust to report its own failure is
worse than a manual one, because it produces false confidence.
