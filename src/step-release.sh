#!/usr/bin/env psh
set -euo pipefail

LOG="${INPUT_LOG_FILE:-pipery.jsonl}"
SHORT_SHA="${GITHUB_SHA:-}"
SHORT_SHA="${SHORT_SHA:0:7}"

if [ -z "${INPUT_PYPI_TOKEN:-}" ]; then
  echo "No PYPI_TOKEN provided, skipping release."
  exit 0
fi

pip install twine -q 2>/dev/null || pip3 install twine --break-system-packages -q 2>/dev/null || true
export TWINE_USERNAME="__token__"
export TWINE_PASSWORD="$INPUT_PYPI_TOKEN"
twine upload dist/*
printf '{"event":"release","status":"success","tool":"twine","sha":"%s"}\n' "$SHORT_SHA" >> "$LOG"
echo "==> Released to PyPI (commit sha-${SHORT_SHA})"
