#!/usr/bin/env bash
set -euo pipefail
PROJECT="${INPUT_PROJECT_PATH:-.}"
LOG="${INPUT_LOG_FILE:-pipery.jsonl}"

_psh_run() {
  local cmd="$1"
  if command -v psh >/dev/null 2>&1 && psh --version >/dev/null 2>&1; then
    psh -log-file "$LOG" -c "$cmd"
  else
    eval "$cmd"
    printf '{"event":"build","status":"success","tool":"build"}\n' >> "$LOG"
  fi
}

cd "$PROJECT"
if [ -f pyproject.toml ] && grep -q '\[tool\.poetry\]' pyproject.toml; then
  pip install poetry -q 2>/dev/null || pip3 install poetry --break-system-packages -q 2>/dev/null || true
  _psh_run "poetry build"
elif [ -f pyproject.toml ] || [ -f setup.cfg ]; then
  pip install build -q 2>/dev/null || pip3 install build --break-system-packages -q 2>/dev/null || true
  _psh_run "python3 -m build"
elif [ -f setup.py ]; then
  pip install build -q 2>/dev/null || pip3 install build --break-system-packages -q 2>/dev/null || true
  _psh_run "python3 -m build"
else
  echo "No build system detected, skipping build."
  printf '{"event":"build","status":"skipped","reason":"no_build_system"}\n' >> "$LOG"
fi
