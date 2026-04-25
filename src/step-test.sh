#!/usr/bin/env bash
set -euo pipefail
PROJECT="${INPUT_PROJECT_PATH:-.}"
LOG="${INPUT_LOG_FILE:-pipery.jsonl}"
pip install pytest -q 2>/dev/null || pip3 install pytest --break-system-packages -q 2>/dev/null || true
if command -v psh >/dev/null 2>&1 && psh --version >/dev/null 2>&1; then
  psh -log-file "$LOG" -c "python3 -m pytest $PROJECT -q --tb=short"
else
  python3 -m pytest "$PROJECT" -q --tb=short
  printf '{"event":"test","status":"success","tool":"pytest"}\n' >> "$LOG"
fi
