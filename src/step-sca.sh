#!/usr/bin/env bash
set -euo pipefail

LOG="${INPUT_LOG_FILE:-pipery.jsonl}"
PROJECT="${INPUT_PROJECT_PATH:-.}"

if command -v pipery-steps >/dev/null 2>&1; then
  pipery-steps sca --language python --project-path "${PROJECT}" --log-file "${LOG}"
elif command -v psh >/dev/null 2>&1 && command -v safety >/dev/null 2>&1; then
  echo "==> pipery-steps not found; running safety directly"
  psh -log-file "${LOG}" -fail-on-error -c "safety check --full-report"
else
  echo "==> SCA: no tool available (pipery-steps, safety); skipping gracefully"
  printf '{"event":"sca","status":"skipped","reason":"no_tool"}\n' >> "${LOG}"
fi
