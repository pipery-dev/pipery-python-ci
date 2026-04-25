#!/usr/bin/env bash
set -euo pipefail

if command -v psh >/dev/null 2>&1; then
  echo "psh already installed: $(command -v psh)"
  exit 0
fi

echo "==> Installing psh from GitHub releases..."
curl -fsSL https://github.com/pipery-dev/pipery/releases/download/v0.1.0/psh-0.1.0-linux-amd64.tar.gz \
  -o /tmp/psh.tar.gz
mkdir -p /tmp/psh-bin
tar -xzf /tmp/psh.tar.gz -C /tmp/psh-bin/
find /tmp/psh-bin -name psh -type f -exec install -m755 {} /usr/local/bin/psh \;

if command -v psh >/dev/null 2>&1; then
  echo "psh installed: $(command -v psh)"
else
  echo "WARNING: psh installation failed; continuing without it" >&2
fi
