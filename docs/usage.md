# Using Pipery Python CI

CI pipeline for Python: SAST, SCA, lint, build, test, versioning, packaging, release, reintegration

## Recommended workflow

1. Pin the action to a major tag in production workflows.
2. Keep a representative test project in the repository and point `test_project_path` at it.
3. Emit a `pipery.jsonl` build log during the action run and keep `test_log_path` pointed at it.
4. Make the action consume that path via the configured test input.
5. Keep changelog entries under `## [Unreleased]` until you cut a release.
6. Regenerate docs before publishing a new version.

## Example

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
