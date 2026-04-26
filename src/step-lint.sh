#!/usr/bin/env bash
set -euo pipefail

LOG="${INPUT_LOG_FILE:-pipery.jsonl}"
PROJECT="${INPUT_PROJECT_PATH:-.}"

# Install ruff if missing
if ! command -v ruff >/dev/null 2>&1; then
  echo "==> Installing ruff..."
  pip install ruff -q 2>/dev/null || pip3 install ruff -q 2>/dev/null || pip3 install ruff --break-system-packages -q 2>/dev/null || true
fi

if command -v ruff >/dev/null 2>&1; then
  if command -v psh >/dev/null 2>&1 && psh --version >/dev/null 2>&1; then
    psh -log-file "${LOG}" -fail-on-error -c "ruff check ${PROJECT}"
  else
    ruff check "${PROJECT}"
    printf '{"event":"lint","status":"success","tool":"ruff"}\n' >> "${LOG}"
  fi
else
  echo "==> Lint: ruff not available; skipping gracefully"
  printf '{"event":"lint","status":"skipped","reason":"no_tool"}\n' >> "${LOG}"
fi
