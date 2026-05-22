#!/usr/bin/env psh
set -euo pipefail

PROJECT="${INPUT_PROJECT_PATH:-.}"
LOG="${INPUT_LOG_FILE:-pipery.jsonl}"

cd "$PROJECT"
BUILD_TOOL=""
if [ -f pyproject.toml ] && grep -q '\[tool\.poetry\]' pyproject.toml; then
  pip install poetry -q 2>/dev/null || pip3 install poetry --break-system-packages -q 2>/dev/null || true
  poetry build
  BUILD_TOOL="poetry"
elif [ -f pyproject.toml ] || [ -f setup.cfg ]; then
  pip install build -q 2>/dev/null || pip3 install build --break-system-packages -q 2>/dev/null || true
  python3 -m build
  BUILD_TOOL="python-build"
elif [ -f setup.py ]; then
  pip install build -q 2>/dev/null || pip3 install build --break-system-packages -q 2>/dev/null || true
  python3 -m build
  BUILD_TOOL="python-build"
else
  echo "No build system detected, skipping build."
  printf '{"event":"build","status":"skipped","reason":"no_build_system"}\n' >> "$LOG"
fi

if [ -n "$BUILD_TOOL" ]; then
  printf '{"event":"build","status":"success","tool":"%s"}\n' "$BUILD_TOOL" >> "$LOG"
fi
