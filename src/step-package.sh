#!/usr/bin/env bash
set -euo pipefail
PROJECT="${INPUT_PROJECT_PATH:-.}"
LOG="${INPUT_LOG_FILE:-pipery.jsonl}"
cd "$PROJECT"
pip install build -q 2>/dev/null || pip3 install build --break-system-packages -q 2>/dev/null || true
mkdir -p dist
if command -v psh >/dev/null 2>&1 && psh --version >/dev/null 2>&1; then
  psh -log-file "$LOG" -c "python3 -m build --outdir dist/"
else
  python3 -m build --outdir dist/
  printf '{"event":"package","status":"success","tool":"build"}\n' >> "$LOG"
fi
