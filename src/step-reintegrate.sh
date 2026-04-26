#!/usr/bin/env bash
set -euo pipefail
PROJECT="${INPUT_PROJECT_PATH:-.}"
LOG="${INPUT_LOG_FILE:-pipery.jsonl}"
if [ -z "${GITHUB_TOKEN:-}${INPUT_GITHUB_TOKEN:-}" ]; then
  echo "No GITHUB_TOKEN, skipping reintegration."
  exit 0
fi
export GITHUB_TOKEN="${INPUT_GITHUB_TOKEN:-$GITHUB_TOKEN}"
if command -v pipery-steps >/dev/null 2>&1; then
  pipery-steps reintegrate \
    --project-path "$PROJECT" \
    --source-branch "${GITHUB_REF_NAME:-main}" \
    --target-branch "${INPUT_TARGET_BRANCH:-main}" \
    --log-file "$LOG"
else
  echo "==> Reintegrate: pipery-steps not available; skipping gracefully"
  printf '{"event":"reintegrate","status":"skipped","reason":"no_tool"}\n' >> "$LOG"
fi
