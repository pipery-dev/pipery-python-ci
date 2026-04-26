#!/usr/bin/env bash
set -euo pipefail

# Resolve project path: prefer INPUT_PROJECT_PATH, then PIPERY_TEST_PROJECT_PATH, then cwd
export INPUT_PROJECT_PATH="${INPUT_PROJECT_PATH:-${PIPERY_TEST_PROJECT_PATH:-.}}"
export INPUT_LOG_FILE="${INPUT_LOG_FILE:-${PIPERY_LOG_PATH:-pipery.jsonl}}"
export INPUT_CONFIG_FILE="${INPUT_CONFIG_FILE:-.github/pipery/config.yaml}"
export INPUT_PACKAGE_MANAGER="${INPUT_PACKAGE_MANAGER:-auto}"
export INPUT_PYTHON_VERSION="${INPUT_PYTHON_VERSION:-3.11}"
export INPUT_SKIP_SAST="${INPUT_SKIP_SAST:-false}"
export INPUT_SKIP_SCA="${INPUT_SKIP_SCA:-false}"
export INPUT_SKIP_LINT="${INPUT_SKIP_LINT:-false}"
export INPUT_SKIP_BUILD="${INPUT_SKIP_BUILD:-false}"
export INPUT_SKIP_TEST="${INPUT_SKIP_TEST:-false}"
export INPUT_SKIP_VERSIONING="${INPUT_SKIP_VERSIONING:-false}"
export INPUT_SKIP_PACKAGING="${INPUT_SKIP_PACKAGING:-false}"
export INPUT_SKIP_RELEASE="${INPUT_SKIP_RELEASE:-false}"
export INPUT_SKIP_REINTEGRATION="${INPUT_SKIP_REINTEGRATION:-false}"
export INPUT_VERSION_BUMP="${INPUT_VERSION_BUMP:-patch}"
export INPUT_REGISTRY="${INPUT_REGISTRY:-pypi}"
export INPUT_PYPI_TOKEN="${INPUT_PYPI_TOKEN:-}"
export INPUT_GITHUB_TOKEN="${INPUT_GITHUB_TOKEN:-}"

SCRIPT_DIR="${GITHUB_ACTION_PATH:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
SRC_DIR="${SCRIPT_DIR}/src"

if [ ! -d "${INPUT_PROJECT_PATH}" ]; then
  echo "ERROR: project path does not exist: ${INPUT_PROJECT_PATH}" >&2
  exit 1
fi

echo "==> pipery-python-ci starting"
echo "    project_path=${INPUT_PROJECT_PATH}"
echo "    log_file=${INPUT_LOG_FILE}"

# Setup psh
"${SRC_DIR}/setup-psh.sh"

# Install pipery-tooling (skip if already installed)
if ! command -v pipery-steps >/dev/null 2>&1; then
  echo "==> Installing pipery-tooling..."
  pip install git+https://github.com/pipery-dev/pipery-tooling.git -q 2>/dev/null || \
    pip3 install git+https://github.com/pipery-dev/pipery-tooling.git -q 2>/dev/null || true
fi

# SAST
if [ "${INPUT_SKIP_SAST}" != "true" ]; then
  echo "==> SAST scan"
  "${SRC_DIR}/step-sast.sh" || { echo "SAST step failed" >&2; exit 1; }
fi

# SCA
if [ "${INPUT_SKIP_SCA}" != "true" ]; then
  echo "==> SCA scan"
  "${SRC_DIR}/step-sca.sh" || { echo "SCA step failed" >&2; exit 1; }
fi

# Lint
if [ "${INPUT_SKIP_LINT}" != "true" ]; then
  echo "==> Lint"
  "${SRC_DIR}/step-lint.sh" || { echo "Lint step failed" >&2; exit 1; }
fi

# Build
if [ "${INPUT_SKIP_BUILD}" != "true" ]; then
  echo "==> Build"
  "${SRC_DIR}/step-build.sh" || { echo "Build step failed" >&2; exit 1; }
fi

# Test
if [ "${INPUT_SKIP_TEST}" != "true" ]; then
  echo "==> Test"
  "${SRC_DIR}/step-test.sh" || { echo "Test step failed" >&2; exit 1; }
fi

# Version
if [ "${INPUT_SKIP_VERSIONING}" != "true" ]; then
  echo "==> Version"
  "${SRC_DIR}/step-version.sh" || { echo "Version step failed" >&2; exit 1; }
fi

# Package
if [ "${INPUT_SKIP_PACKAGING}" != "true" ]; then
  echo "==> Package"
  "${SRC_DIR}/step-package.sh" || { echo "Package step failed" >&2; exit 1; }
fi

# Release
if [ "${INPUT_SKIP_RELEASE}" != "true" ]; then
  echo "==> Release"
  "${SRC_DIR}/step-release.sh" || { echo "Release step failed" >&2; exit 1; }
fi

# Reintegrate
if [ "${INPUT_SKIP_REINTEGRATION}" != "true" ]; then
  echo "==> Reintegrate"
  "${SRC_DIR}/step-reintegrate.sh" || { echo "Reintegrate step failed" >&2; exit 1; }
fi

# Write final success log entry
printf '{"event":"build","status":"success","project":"python","mode":"ci"}\n' >> "${INPUT_LOG_FILE}"

echo "==> pipery-python-ci complete"
