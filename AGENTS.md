# AGENTS.md This file provides guidance to CodeBuddy when working with code in this repository.

## Project Overview

This is a **GitHub Action** (repo: `emptylight370/jq-action`) that wraps the `jq` command-line JSON processor. It accepts JSON data (either as a file path or inline JSON string) and a jq filter expression, then returns the processed result via `result` and `multiline` outputs.

## Development Commands

### Prerequisites

Install mise (https://mise.jdx.dev/getting-started.html) and run `mise install` to set up dependencies. This also installs lefthook git hooks via the `[deps.lefthook]` section of `mise.toml`.

### Common Commands

| Command              | Description                                                             |
| -------------------- | ----------------------------------------------------------------------- |
| `mise run changelog` | Generates changelog from conventional commits with `git cliff`, formats with prettier, then stages `changelog.md` via `git add` |
| `mise run tag`       | Creates a signed version tag (`v1.2.1` style), deletes and re-creates a moving major tag (`v1`), pushes both to remote (defined in `.mise/tasks/tag.ps1`) |
| `lefthook install`   | Install git hooks defined in `lefthook.yml`                             |

Note: mise tasks are **PowerShell scripts** (`.mise/tasks/*.ps1`, `#!/usr/bin/env pwsh`) — they work cross-platform but require PowerShell.

### Testing

- Tests are defined in `.github/workflows/test.yml` and run **only on GitHub Actions** — there is no local test runner
- Triggered on push to main (only when `action.yml` or the test workflow itself changes), manual `workflow_dispatch`, or monthly schedule (cron: `0 0 1 * *`)
- Tests execute on matrix: ubuntu-latest, macos-26, windows-latest (with `fail-fast: false`)
- 6 test steps: file input (`metadata.json`), inline JSON string, subfolder file path (`test/theme.json`), sorted output with options, multiline output (array iteration), null input with `--compact-output`

### Release Process

1. Update `version` in `metadata.json` (currently `1.2.1`)
2. Commit with conventional commit message (e.g., `feat: description`) — the pre-commit hook only regenerates `changelog.md` when `metadata.json`'s `version` changes
3. Run `mise run tag` to create and push version tag
4. GitHub Actions automatically triggers release workflow on tag push

## Architecture

This is a **GitHub Composite Action** (`runs.using: composite`), not a JavaScript or Docker action. All logic runs inline in the workflow's bash shell, which means there is no separate runtime, build step, or `node_modules` — the action is purely a YAML-defined wrapper around `jq`.

### Core File: `action.yml`

The entire action logic resides in this single YAML file:

1. Defines 4 inputs: `data` (required), `filter` (required), `raw` (default: `"true"`), `options` (optional)
2. Defines 2 outputs: `result` (jq output, as-is single or multiline), `multiline` (boolean flag)
3. Single `runjq` step with `shell: bash`; inputs are passed via `env` (`INPUT_DATA`, `INPUT_FILTER`, `INPUT_RAW`, `INPUT_OPTIONS`) rather than direct interpolation — this avoids shell injection/quoting issues
4. Inline script:
   - Validates input as either valid JSON string (`echo "$INPUT_DATA" | jq .`) or existing file path (`[ -f "$INPUT_DATA" ]`)
   - Constructs jq command with `-r` flag when `raw=true`, plus user `options`
   - Fails with `::error::` workflow annotations on invalid input or jq failure

### Configuration Files

- **`mise.toml`**: Defines tooling (bun, git-cliff, lefthook, prettier) and sets `npm.package_manager = "bun"`. Tasks are auto-discovered from `.mise/tasks/` directory
- **`lefthook.yml`**: Git pre-commit hook that only runs changelog generation when `metadata.json` version changes (checks for `version` diff in staged changes)
- **`cliff.toml`**: git-cliff configuration for conventional commit parsing, changelog output formatting with Tera templates, and commit group classification (features, fixes, docs, etc.)
- **`metadata.json`**: Package metadata including version number — used by both `mise run changelog` and `mise run tag`
- **`.github/dependabot.yml`**: Weekly GitHub Actions dependency updates

### Workflows

- **`test.yml`**: Runs comprehensive test matrix across 3 OSes with concurrency control (cancel-in-progress), exercises all action features via `uses: ./` to reference the local action
- **`release.yml`**: Triggered on `v*.*.*` tag push. Uses `jdx/mise-action` to install tools (git-cliff, prettier), generates release notes with `git cliff -l -o release.md` + prettier, then creates a GitHub release via `softprops/action-gh-release`

### Test Data

- `test/theme.json`: Sample JSON file used by test workflow for file path and nested key tests

## Key Patterns

### Multiline Output Handling

GitHub Actions cannot directly output multiline strings. When the jq result contains a newline, the action uses a heredoc-style delimiter strategy (actual implementation in `action.yml`):

```bash
DELIMITER="JQMULTILINE$$_${RANDOM}_$(date +%s)"
printf 'result<<%s\n' "$DELIMITER" >> $GITHUB_OUTPUT
printf '%s\n' "$RESULT" >> $GITHUB_OUTPUT
printf '%s\n' "$DELIMITER" >> $GITHUB_OUTPUT
echo "multiline=true" >> $GITHUB_OUTPUT
```

Single-line results use plain `result=$RESULT` output with `multiline=false`.

### Input Validation

Input is validated by attempting to parse as JSON with `jq .`. If that fails, checks if it's a file path with `[ -f "$INPUT_DATA" ]`; otherwise errors out.

### jq Options

- Raw mode (`-r`): Strips quotes from string output (enabled when `raw` input is `true`)
- Additional options passed via `options` input appended to jq command (e.g. `--indent 0 --sort-keys -c`)
- Per README tip: to use `--null-input`, set the `data` input to `'null'` instead of passing the option
