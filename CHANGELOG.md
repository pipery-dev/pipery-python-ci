# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

- _Nothing yet._

## [1.0.0]

## [1.0.1] - 2026-04-27

### Added
- GitHub Marketplace branding icon updated to match action technology (Feather icon set)
- Added `simple_icon` field to `pipery-action.toml` for technology icon reference (Simple Icons slug)
- `tests_path` input: configures the pytest path (directory, file, or nodeids); defaults to `project_path`
- Short git hash (`sha-<7chars>`) included in every release alongside semver tags

### Changed
- All step scripts use `#!/usr/bin/env psh` as the shebang — psh intercepts and logs every command automatically
- `setup-psh.sh` detects runner architecture dynamically (amd64 and arm64)
- `config_file` is now loaded via a dedicated step at the start of the composite action
- `target_branch` input added for configurable reintegration target

## [0.1.0] - Initial scaffold
