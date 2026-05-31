#!/usr/bin/env bash
# Fails (exit 1) if any personal/private marker appears anywhere in the repo.
# Run before every commit/publish. Allowlist generic example tokens explicitly.
set -uo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
PATTERNS='wes@|weskan|kennedy|kzws|mika|mikasa|ardell|jessica|192\.168\.|ai\.kzws|resend|@icloud|cadence|homestead|jfrog|concerta'
hits="$(rg -in --glob '!tools/sanitize-check.sh' --glob '!LICENSE' --glob '!.git' "$PATTERNS" . || true)"
if [[ -n "$hits" ]]; then
  echo "SANITIZE FAIL — personal markers found:"
  echo "$hits"
  exit 1
fi
echo "SANITIZE OK — no personal markers"
