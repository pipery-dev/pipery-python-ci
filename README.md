# Pipery Python CI

CI pipeline for Python: SAST, SCA, lint, build, test, versioning, packaging, release, reintegration

## Status

- Owner: `pipery-dev`
- Repository: `pipery-python-ci`
- Marketplace category: `continuous-integration`
- Current version: `1.0.1`

## Usage

```yaml
name: Example
on: [push]

jobs:
  run-action:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pipery-dev/pipery-python-ci@v1
        with:
          project_path: .
          config_file: .pipery/config.yaml
          package_manager: auto
          python_version: 3.11
          skip_sast: false
          skip_sca: false
          skip_lint: false
          skip_build: false
          tests_path: 
          skip_test: false
          skip_versioning: false
          skip_packaging: false
          skip_release: false
          skip_reintegration: false
          version_bump: patch
          registry: pypi
          pypi_token: 
          github_token: 
          target_branch: main
          log_file: pipery.jsonl
```

## Inputs

| Name | Required | Default | Description |
| --- | --- | --- | --- |
| `project_path` | no | `.` | Path to the project source tree. |
| `config_file` | no | `.pipery/config.yaml` | Path to pipery config file. |
| `package_manager` | no | `auto` | Package manager: auto, setuptools, poetry, uv. |
| `python_version` | no | `3.11` | Python version to use. |
| `skip_sast` | no | `false` | Skip SAST scan. |
| `skip_sca` | no | `false` | Skip SCA scan. |
| `skip_lint` | no | `false` | Skip lint step. |
| `skip_build` | no | `false` | Skip build step. |
| `tests_path` | no | `` | Path passed to pytest (directory, file, or nodeids). Defaults to project_path. |
| `skip_test` | no | `false` | Skip test step. |
| `skip_versioning` | no | `false` | Skip versioning step. |
| `skip_packaging` | no | `false` | Skip packaging step. |
| `skip_release` | no | `false` | Skip release step. |
| `skip_reintegration` | no | `false` | Skip reintegration step. |
| `version_bump` | no | `patch` | Version bump kind: patch, minor, major. |
| `registry` | no | `pypi` | Registry target for release. |
| `pypi_token` | no | `` | PyPI API token for publishing. |
| `github_token` | no | `` | GitHub token for reintegration. |
| `target_branch` | no | `main` | Target branch for reintegration. |
| `log_file` | no | `pipery.jsonl` | Path to the JSONL log file. |

## Outputs

No outputs.

## Development

This repository is managed with `pipery-tooling`.

```bash
pipery-actions test --repo .
pipery-actions docs --repo .
pipery-actions release --repo . --dry-run
```

By default, `pipery-actions test --repo .` executes the action against `test-project` and validates `pipery.jsonl`.

## Marketplace Release Flow

1. Update the implementation and changelog.
2. Run `pipery-actions release --repo .`.
3. Push the created git tag and major tag alias.
4. Publish the GitHub release.
