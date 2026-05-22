#!/usr/bin/env psh
set -euo pipefail

PROJECT="${INPUT_PROJECT_PATH:-.}"
LOG="${INPUT_LOG_FILE:-pipery.jsonl}"

if command -v pipery-steps >/dev/null 2>&1; then
  NEW_VERSION=$(pipery-steps version --language python --project-path "$PROJECT" --bump "${INPUT_VERSION_BUMP:-patch}")
  echo "New version: $NEW_VERSION"
  [ -n "${GITHUB_OUTPUT:-}" ] && echo "version=$NEW_VERSION" >> "$GITHUB_OUTPUT"
  printf '{"event":"version","status":"success","version":"%s"}\n' "$NEW_VERSION" >> "$LOG"
else
  echo "==> Version: pipery-steps not available; skipping gracefully"
  printf '{"event":"version","status":"skipped","reason":"no_tool"}\n' >> "$LOG"
fi
