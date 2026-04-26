# Pipery Python CI

CI pipeline for Python: SAST, SCA, lint, build, test, versioning, packaging, release, reintegration

## Status

- Owner: `pipery-dev`
- Repository: `pipery-python-ci`
- Marketplace category: `continuous-integration`
- Current version: `0.1.0`

## Usage

```yaml
name: Example
on: [push]

jobs:
  run-action:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pipery-dev/pipery-python-ci@v0
        with:
          project_path: .
```

## Inputs

### Core

| Name | Default | Description |
|---|---|---|
| `project_path` | `.` | Path to the project source tree. |
| `config_file` | `.github/pipery/config.yaml` | Path to pipery config file. |
| `log_file` | `pipery.jsonl` | Path to the JSONL log file. |
| `python_version` | `3.11` | Python version to use. |
| `package_manager` | `auto` | Package manager: `auto`, `setuptools`, `poetry`, or `uv`. |

### Registry / publish credentials

| Name | Default | Description |
|---|---|---|
| `registry` | `pypi` | Registry target for release. |
| `pypi_token` | `` | PyPI API token for publishing. |
| `github_token` | `` | GitHub token for reintegration. |

### Pipeline controls (skip flags)

| Name | Default | Description |
|---|---|---|
| `skip_sast` | `false` | Skip SAST scan. |
| `skip_sca` | `false` | Skip SCA scan. |
| `skip_lint` | `false` | Skip lint step. |
| `skip_build` | `false` | Skip build step. |
| `skip_test` | `false` | Skip test step. |
| `skip_versioning` | `false` | Skip versioning step. |
| `skip_packaging` | `false` | Skip packaging step. |
| `skip_release` | `false` | Skip release step. |
| `skip_reintegration` | `false` | Skip reintegration step. |

### Versioning & release

| Name | Default | Description |
|---|---|---|
| `version_bump` | `patch` | Version bump kind: `patch`, `minor`, or `major`. |
| `target_branch` | `main` | Target branch for reintegration. |

### Testing

| Name | Default | Description |
|---|---|---|
| `tests_path` | `` | Path passed to pytest (directory, file, or nodeids). Defaults to `project_path`. |

## Outputs

| Name | Description |
|---|---|
| `version` | The new version string after the versioning step. |

## Steps

| Step | Skip flag | What it does |
|---|---|---|
| SAST | `skip_sast` | Static analysis via pipery-steps |
| SCA | `skip_sca` | Dependency vulnerability scan |
| Lint | `skip_lint` | Linting via ruff |
| Build | `skip_build` | Build Python wheel via detected package manager |
| Test | `skip_test` | Run pytest against `tests_path` (defaults to `project_path`) |
| Versioning | `skip_versioning` | Bump version, write to `GITHUB_OUTPUT` |
| Packaging | `skip_packaging` | `python build` to create wheel and sdist artifacts |
| Release | `skip_release` | `twine upload` to PyPI; short SHA recorded in the log |
| Reintegration | `skip_reintegration` | Merge release branch back to `target_branch` |

## Development

This repository is managed with `pipery-tooling`.

```bash
pipery-actions test --repo .
pipery-actions release --repo . --dry-run
```
