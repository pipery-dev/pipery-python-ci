# Pipery Python CI Component

Reusable GitLab CI/CD component for complete Python CI pipeline with structured logging.

## Overview

This component provides a complete CI/CD pipeline for Python projects:
- SAST scanning
- SCA (dependency scanning)
- Linting
- Build
- Test
- Versioning & tagging
- Release/publish
- Reintegration

## Quick Start

In your `.gitlab-ci.yml`:

```yaml
include:
  - component: $CI_SERVER_FQDN/pipery-dev/pipery-python-ci/catalog-resources/pipery-python-ci@main

variables:
  PROJECT_PATH: "."
  # Add your configuration variables here
```

## Configuration Variables

## Configuration

### Variables

| Variable | Default | Description |
| --- | --- | --- |
| PROJECT_PATH | . | Path to project source |
| PYTHON_VERSION | 3.11 | Python runtime version |
| PACKAGE_MANAGER | auto | Package manager |
| VERSION_BUMP | patch | Semantic version increment |
| REGISTRY | | Package registry |
| TESTS_PATH | | Path to test files |
| CONFIG_FILE | .pipery/config.yaml | Pipery configuration file |
| TARGET_BRANCH | main | Target branch for release |

### Authentication

| Variable | Description |
| --- | --- |
| NPM_TOKEN | npm registry authentication token |
| PYPI_TOKEN | PyPI registry authentication token |
| GITHUB_TOKEN | GitHub API access token |

### Skip Controls

Disable any pipeline stage by setting to `true`:
- `SKIP_SAST` - Skip static application security testing
- `SKIP_SCA` - Skip software composition analysis
- `SKIP_LINT` - Skip code linting
- `SKIP_BUILD` - Skip build step
- `SKIP_TEST` - Skip test execution
- `SKIP_VERSIONING` - Skip version bumping
- `SKIP_PACKAGING` - Skip package creation
- `SKIP_RELEASE` - Skip release/publish
- `SKIP_REINTEGRATION` - Skip reintegration

## Outputs

- `pipery.jsonl` - Structured JSONL log file with all pipeline events
- `artifacts/dashboard_link.env` - Pipery Dashboard link environment file

## Pipeline Stages

The pipeline executes the following stages in order:

- `checkout`
- `setup`
- `sast`
- `sca`
- `lint`
- `build`
- `test`
- `versioning`
- `packaging`
- `release`
- `reintegration`
- `logs`


## Advanced Usage

### Custom Configuration File

Override the default configuration file location:

```yaml
variables:
  CONFIG_FILE: "path/to/custom/config.yaml"
```

### Conditional Execution

Use GitLab CI rules to control when this component runs:

```yaml
include:
  - component: $CI_SERVER_FQDN/pipery-dev/pipery-python-ci/catalog-resources/pipery-python-ci@main
    rules:
      - if: '$CI_COMMIT_BRANCH == "main"'
```

## Monitoring & Debugging

### View Pipeline Logs

Check the `pipery.jsonl` artifact for detailed event logs:

```bash
cat pipery.jsonl | jq '.'
```

### Dashboard Link

After pipeline completion, the `artifacts/dashboard_link.env` file contains the Pipery Dashboard URL:

```bash
source artifacts/dashboard_link.env
echo $DASHBOARD_URL
```

## About Pipery

Pipery provides unified CI/CD pipelines across multiple languages and deployment targets. For more information, visit [pipery.dev](https://pipery.dev).

## Support

For issues or questions, please refer to the [Pipery documentation](https://docs.pipery.dev) or open an issue on [GitHub](https://github.com/pipery-dev).
