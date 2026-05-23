#!/usr/bin/env psh
set -euo pipefail

LOG="${INPUT_LOG_FILE:-pipery.jsonl}"
PROJECT="${INPUT_PROJECT_PATH:-.}"

if ! command -v ruff >/dev/null 2>&1; then
  echo "==> Installing ruff..."
  pip install ruff -q 2>/dev/null || pip3 install ruff -q 2>/dev/null || pip3 install ruff --break-system-packages -q 2>/dev/null || true
fi

if command -v ruff >/dev/null 2>&1; then
  ruff check "${PROJECT}"
  printf '{"event":"lint","status":"success","tool":"ruff"}\n' >> "${LOG}"
else
  echo "==> Lint: ruff not available; skipping gracefully"
  printf '{"event":"lint","status":"skipped","reason":"no_tool"}\n' >> "${LOG}"
fi
