#!/usr/bin/env bash
set -euo pipefail

CONFIG_FILE="${INPUT_CONFIG_FILE:-.github/pipery/config.yaml}"

if [ ! -f "${CONFIG_FILE}" ]; then
  echo "Config file not found: ${CONFIG_FILE} — skipping"
  exit 0
fi

echo "==> Reading config from ${CONFIG_FILE}"
python3 -c "
import yaml, sys, os

with open('${CONFIG_FILE}') as f:
    config = yaml.safe_load(f) or {}

for key, value in config.items():
    env_key = 'INPUT_' + key.upper().replace('-', '_')
    if env_key not in os.environ:
        print(f'export {env_key}={value!r}')
" 2>/dev/null || true
