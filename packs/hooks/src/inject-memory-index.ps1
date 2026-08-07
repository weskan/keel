# SessionStart hook (Windows) - inject the global memory index into every
# session, and announce its own health, loudly, in-context.
#
# See inject-memory-index.sh for the full rationale. The short version: the
# harness auto-injects only the project-local memory directory, so loading a
# global root is otherwise an instruction the model must remember - which fails
# silently. Every failure path below emits a VISIBLE warning; none exit quietly.
#
# No interpreter pinning is needed here: ConvertTo-Json is built into PowerShell
# and does the JSON escaping the Bash version needs Python for.

$MemDir = if ($env:KEEL_MEMORY_DIR) { $env:KEEL_MEMORY_DIR } else { "$env:USERPROFILE\.claude\memory" }
$Index  = Join-Path $MemDir "MEMORY.md"

function Emit($text) {
  @{ hookSpecificOutput = @{
       hookEventName     = "SessionStart"
       additionalContext = $text
  } } | ConvertTo-Json -Depth 5 -Compress
}

# --- Failure paths: loud, never silent ---------------------------------------
if (-not (Test-Path -LiteralPath $MemDir)) {
  Emit "WARNING: MEMORY SYSTEM BROKEN - the global memory root $MemDir does not exist.
This tier holds cross-project preferences, feedback, and domain knowledge. It is NOT
auto-injected by the harness, so its absence is otherwise invisible.
Tell the user before relying on recall this session."
  exit 0
}

if (-not (Test-Path -LiteralPath $Index) -or (Get-Item -LiteralPath $Index).Length -eq 0) {
  Emit "WARNING: MEMORY SYSTEM DEGRADED - the global index $Index is missing or empty,
though $MemDir exists. Leaf memories may still be present but are now unindexed and
effectively unreachable. Rebuild the index from the tree and tell the user."
  exit 0
}

# --- Success path: emit index + flag any rot ---------------------------------
$body = Get-Content -Raw -Encoding UTF8 -LiteralPath $Index

# An index entry naming a file that no longer exists is stale recall waiting to
# happen. Flag it rather than letting the agent cite a note that is gone.
$broken = @()
foreach ($m in [regex]::Matches($body, '\]\(([^)]+\.md)\)')) {
  $target = $m.Groups[1].Value
  if ($target -match '^(https?://|#)') { continue }
  if (-not (Test-Path -LiteralPath (Join-Path $MemDir $target))) { $broken += $target }
}

$header = @"
Contents of $Index (GLOBAL cross-project memory index - spans every project, not just
this working directory).

This is an INDEX, not content. Proactively open the leaf files whose one-line hooks match
the current task BEFORE starting work - the actionable detail lives in the leaves. Verify
any file or symbol a memory names still exists before acting on it. When you state a fact
that came from memory, cite the file it came from.


"@

if ($broken.Count -gt 0) {
  $header += "WARNING: MEMORY INDEX ROT - these indexed files no longer exist:`n"
  foreach ($b in $broken) { $header += "  - $b`n" }
  $header += "Do not cite them as sources. Surface this to the user and repair the index.`n`n"
}

Emit ($header + $body)
exit 0
