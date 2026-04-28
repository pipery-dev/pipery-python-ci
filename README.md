# Pipery Python CI

CI pipeline for Python: SAST, SCA, lint, build, test, versioning, packaging, release, reintegration

## Status

- Owner: `pipery-dev`
- Repository: `pipery-python-ci`
- Marketplace category: `continuous-integration`
- Current version: `1.0.0`

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
```

## Inputs

| Name | Required | Default | Description |
| --- | --- | --- | --- |
| `project_path` | no | `.` | Path to the project source tree the action should operate on. |

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
