#!/usr/bin/env psh
set -euo pipefail

PROJECT="${INPUT_PROJECT_PATH:-.}"
LOG="${INPUT_LOG_FILE:-pipery.jsonl}"

cd "$PROJECT"
pip install build -q 2>/dev/null || pip3 install build --break-system-packages -q 2>/dev/null || true
mkdir -p dist
python3 -m build --outdir dist/
printf '{"event":"package","status":"success","tool":"build"}\n' >> "$LOG"
