# <img src="https://raw.githubusercontent.com/pipery-dev/pipery-python-ci/main/assets/icon.png" alt="Pipery Python CI" width="28" align="center" /> Pipery Python CI

Reusable GitHub Action for a complete Python CI pipeline with structured logging via [Pipery](https://pipery.dev).

[![GitHub Marketplace](https://img.shields.io/badge/Marketplace-Pipery%20Python%20CI-blue?logo=github)](https://github.com/marketplace/actions/pipery-python-ci)
[![Version](https://img.shields.io/badge/version-1.0.0-blue)](CHANGELOG.md)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## Table of Contents

- [Quick Start](#quick-start)
- [Pipeline Overview](#pipeline-overview)
- [Configuration Options](#configuration-options)
- [Usage Examples](#usage-examples)
- [GitLab CI](#gitlab-ci)
- [Bitbucket Pipelines](#bitbucket-pipelines)
- [About Pipery](#about-pipery)
- [Development](#development)

## Quick Start

```yaml
name: CI
on: [push, pull_request]

jobs:
  ci:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pipery-dev/pipery-python-ci@v1
        with:
          project_path: .
          pypi_token: ${{ secrets.PYPI_TOKEN }}
          github_token: ${{ secrets.GITHUB_TOKEN }}
```

## Pipeline Overview

| Step | Tool | Skip Input | Description |
| --- | --- | --- | --- |
| SAST | Bandit | `skip_sast` | Detects common Python security issues |
| SCA | pip-audit / safety | `skip_sca` | Identifies vulnerable dependencies |
| Lint | Ruff | `skip_lint` | Enforces code style and quality |
| Build | python build / poetry build | `skip_build` | Prepares distribution package |
| Test | pytest | `skip_test` | Runs unit and integration tests |
| Version | Semantic versioning | `skip_versioning` | Bumps version and creates git tag |
| Package | `python -m build` | `skip_packaging` | Creates wheel and sdist |
| Release | twine PyPI publish | `skip_release` | Publishes to PyPI |
| Reintegrate | Git merge | `skip_reintegration` | Merges back to default branch |

## Configuration Options

| Name | Default | Description |
| --- | --- | --- |
| `project_path` | `.` | Path to the project source tree. |
| `config_file` | `.pipery/config.yaml` | Path to Pipery config file. |
| `python_version` | `3.11` | Python version to use (e.g., `3.9`, `3.11`, `3.12`). |
| `package_manager` | `auto` | Package manager: `auto`, `setuptools`, `poetry`, or `uv`. |
| `tests_path` | `` | Path passed to pytest (directory, file, or node IDs). |
| `registry` | `pypi` | Registry target for release. |
| `version_bump` | `patch` | Version bump type: `patch`, `minor`, or `major`. |
| `pypi_token` | `` | PyPI API token for publishing. |
| `github_token` | `` | GitHub token for reintegration. |
| `target_branch` | `main` | Target branch for reintegration. |
| `log_file` | `pipery.jsonl` | Path to the JSONL structured log file. |
| `skip_sast` | `false` | Skip the SAST step. |
| `skip_sca` | `false` | Skip the SCA step. |
| `skip_lint` | `false` | Skip the lint step. |
| `skip_build` | `false` | Skip the build step. |
| `skip_test` | `false` | Skip the test step. |
| `skip_versioning` | `false` | Skip the versioning step. |
| `skip_packaging` | `false` | Skip the packaging step. |
| `skip_release` | `false` | Skip the release step. |
| `skip_reintegration` | `false` | Skip the reintegration step. |

## Usage Examples

### Example 1: Standard setuptools project

```yaml
name: CI
on: [push, pull_request]

jobs:
  ci:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pipery-dev/pipery-python-ci@v1
        with:
          project_path: .
          python_version: "3.11"
          pypi_token: ${{ secrets.PYPI_TOKEN }}
          github_token: ${{ secrets.GITHUB_TOKEN }}
```

### Example 2: Poetry-based project

```yaml
- uses: pipery-dev/pipery-python-ci@v1
  with:
    project_path: .
    package_manager: poetry
    pypi_token: ${{ secrets.PYPI_TOKEN }}
    github_token: ${{ secrets.GITHUB_TOKEN }}
```

### Example 3: Run specific test modules

```yaml
- uses: pipery-dev/pipery-python-ci@v1
  with:
    project_path: .
    tests_path: tests/unit tests/integration
    pypi_token: ${{ secrets.PYPI_TOKEN }}
    github_token: ${{ secrets.GITHUB_TOKEN }}
```

### Example 4: Skip security checks for quick CI

```yaml
- uses: pipery-dev/pipery-python-ci@v1
  with:
    project_path: .
    skip_sast: true
    skip_sca: true
    skip_release: true
```

### Example 5: Python 3.9 with uv package manager

```yaml
- uses: pipery-dev/pipery-python-ci@v1
  with:
    project_path: .
    python_version: "3.9"
    package_manager: uv
    pypi_token: ${{ secrets.PYPI_TOKEN }}
    github_token: ${{ secrets.GITHUB_TOKEN }}
```

### Example 6: Minor version bump

```yaml
- uses: pipery-dev/pipery-python-ci@v1
  with:
    project_path: .
    version_bump: minor
    pypi_token: ${{ secrets.PYPI_TOKEN }}
    github_token: ${{ secrets.GITHUB_TOKEN }}
```

## GitLab CI

This repository includes a GitLab CI equivalent at `.gitlab-ci.yml`. Copy it into a GitLab project or use it as a reference implementation for running the same Pipery pipeline outside GitHub Actions.

The GitLab pipeline maps action inputs to CI/CD variables, publishes `pipery.jsonl` as an artifact, and maintains the same skip controls. Store credentials as protected GitLab CI/CD variables.

```yaml
include:
  - remote: https://raw.githubusercontent.com/pipery-dev/pipery-python-ci/v1/.gitlab-ci.yml
```

### GitLab CI Variables

Configure these protected variables in **Settings > CI/CD > Variables**:

- `PYPI_TOKEN` - PyPI authentication token
- `GITHUB_TOKEN` - GitHub API access for reintegration
- `PYTHON_VERSION` - Python version (default: 3.11)
- `PACKAGE_MANAGER` - auto/setuptools/poetry/uv (default: auto)
- `VERSION_BUMP` - patch/minor/major (default: patch)

## Bitbucket Pipelines

Bitbucket Cloud pipelines provide an alternative to GitHub Actions. The equivalent pipeline configuration is in `bitbucket-pipelines.yml`.

### Getting Started

1. Copy `bitbucket-pipelines.yml` to your Bitbucket repository root
2. Configure Protected Variables in **Repository Settings > Pipelines > Repository Variables**:
   - `PYPI_TOKEN` - PyPI authentication token
   - `GITHUB_TOKEN` - GitHub API access (for reintegration)
   - `PYTHON_VERSION` - Python version (default: 3.11)
3. Commit and push to trigger the pipeline

### Pipeline Stages

The Bitbucket equivalent follows the same structure:

checkout → setup → SAST (Bandit, parallel) → SCA (pip-audit, parallel) → lint (Ruff) → build → test → versioning → packaging → release → reintegration → logs

### Skip Flags

Disable any stage using environment variables:

- `SKIP_SAST`, `SKIP_SCA`, `SKIP_LINT`, `SKIP_BUILD`, `SKIP_TEST`, `SKIP_VERSIONING`, `SKIP_PACKAGING`, `SKIP_RELEASE`, `SKIP_REINTEGRATION`

Example: Set `SKIP_LINT=true` to skip linting.

### Features

- Same security scanning tools (Bandit, pip-audit, safety)
- Parallel SAST and SCA stages
- Support for setuptools, Poetry, and uv
- Automatic versioning and tagging
- PyPI publish with token authentication
- JSONL-based pipeline logging
- 30-90 day artifact retention

## About Pipery

<img src="https://avatars.githubusercontent.com/u/270923927?s=32" alt="Pipery" width="22" align="center" /> [**Pipery**](https://pipery.dev) is an open-source CI/CD observability platform. Every step script runs under **psh** (Pipery Shell), which intercepts all commands and emits structured JSONL events — giving you full visibility into your pipeline without any manual instrumentation.

- Browse logs in the [Pipery Dashboard](https://github.com/pipery-dev/pipery-dashboard)
- Find all Pipery actions on [GitHub Marketplace](https://github.com/marketplace?q=pipery&type=actions)
- Source code: [pipery-dev](https://github.com/pipery-dev)

## Development

```bash
# Run the action locally against test-project/
pipery-actions test --repo .

# Regenerate docs
pipery-actions docs --repo .

# Dry-run release
pipery-actions release --repo . --dry-run
```
