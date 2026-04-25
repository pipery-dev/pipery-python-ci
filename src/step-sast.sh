#!/usr/bin/env bash
set -euo pipefail

LOG="${INPUT_LOG_FILE:-pipery.jsonl}"
PROJECT="${INPUT_PROJECT_PATH:-.}"

if command -v pipery-steps >/dev/null 2>&1; then
  pipery-steps sast --language python --project-path "${PROJECT}" --log-file "${LOG}"
elif command -v psh >/dev/null 2>&1 && command -v semgrep >/dev/null 2>&1; then
  echo "==> pipery-steps not found; running semgrep directly"
  psh -log-file "${LOG}" -fail-on-error -c "semgrep --config=auto ${PROJECT} --quiet"
else
  echo "==> SAST: no tool available (pipery-steps, semgrep); skipping gracefully"
  printf '{"event":"sast","status":"skipped","reason":"no_tool"}\n' >> "${LOG}"
fi
