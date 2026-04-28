# <img src="https://raw.githubusercontent.com/feathericons/feather/master/icons/code.svg" width="28" align="center" /> Pipery Python CI

Reusable GitHub Action for a complete Python CI pipeline with structured logging via [Pipery](https://pipery.dev).

[![GitHub Marketplace](https://img.shields.io/badge/Marketplace-Pipery%20Python%20CI-blue?logo=github)](https://github.com/marketplace/actions/pipery-python-ci)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## Usage

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

## Pipeline steps

| Step | Tool | Skip input |
|---|---|---|
| SAST | Bandit | `skip_sast` |
| SCA | pip-audit / safety | `skip_sca` |
| Lint | Ruff | `skip_lint` |
| Build | python build / poetry build | `skip_build` |
| Test | pytest | `skip_test` |
| Version | Semantic version bump | `skip_versioning` |
| Package | `python -m build` | `skip_packaging` |
| Release | twine PyPI publish | `skip_release` |
| Reintegrate | Merge back to default branch | `skip_reintegration` |

## Inputs

| Name | Default | Description |
|---|---|---|
| `project_path` | `.` | Path to the project source tree. |
| `config_file` | `.github/pipery/config.yaml` | Path to Pipery config file. |
| `python_version` | `3.11` | Python version to use. |
| `package_manager` | `auto` | Package manager: `auto`, `setuptools`, `poetry`, or `uv`. |
| `tests_path` | `` | Path passed to pytest (directory, file, or node IDs). |
| `registry` | `pypi` | Registry target for release. |
| `version_bump` | `patch` | Version bump type: `patch`, `minor`, or `major`. |
| `pypi_token` | `` | PyPI API token for publishing. |
| `github_token` | `` | GitHub token for reintegration. |
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

## About Pipery

<img src="https://raw.githubusercontent.com/feathericons/feather/master/icons/zap.svg" width="18" align="center" /> [**Pipery**](https://pipery.dev) is an open-source CI/CD observability platform. Every step script runs under **psh** (Pipery Shell), which intercepts all commands and emits structured JSONL events — giving you full visibility into your pipeline without any manual instrumentation.

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
