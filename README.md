**English**
| [简体中文](README_zh_CN.md)

![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/emptylight370/jq-action/test.yml?style=plastic&label=test&link=https%3A%2F%2Fgithub.com%2Femptylight370%2Fjq-action%2Factions%2Fworkflows%2Ftest.yml)
![GitHub Release](https://img.shields.io/github/v/release/emptylight370/jq-action?style=plastic&link=https%3A%2F%2Fgithub.com%2Femptylight370%2Fjq-action)
![GitHub Repo stars](https://img.shields.io/github/stars/emptylight370/jq-action?link=https%3A%2F%2Fgithub.com%2Femptylight370%2Fjq-action)
![GitHub commits since latest release](https://img.shields.io/github/commits-since/emptylight370/jq-action/latest?style=plastic&link=https%3A%2F%2Fgithub.com%2Femptylight370%2Fjq-action)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/emptylight370/jq-action?style=plastic&link=https%3A%2F%2Fgithub.com%2Femptylight370%2Fjq-action)

Run jq command in GitHub Actions and return process result.

---

## Inputs

| Name      | Required | Default | Description                                                                            |
| --------- | -------- | ------- | -------------------------------------------------------------------------------------- |
| `data`    | ✅ Yes   | -       | The JSON file path or JSON string to be processed                                      |
| `filter`  | ✅ Yes   | -       | jq filter expression, see [jq documentation](https://jqlang.org/manual/#basic-filters) |
| `raw`     | ❌ No    | `true`  | Raw output mode. Set to `true` to return non-JSON string(with `-r` symbol).            |
| `options` | ❌ No    | -       | The options to jq command. see [jq options](https://jqlang.org/manual/#invoking-jq)    |

## Outputs

| Name     | Description              |
| -------- | ------------------------ |
| `result` | The result of jq command |

## Examples

### Basic usage

```yaml
name: Process JSON

on: [push]

jobs:
  process:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v6

      - name: Run jq
        uses: emptylight370/jq-action@v1
        id: version
        with:
          data: "package.json"
          filter: ".version"

      - name: Output
        run: echo "Version is ${{ steps.version.outputs.result }}"
```

### Complex usage

See [test.yml](.github/workflows/test.yml) file. The outputs are in [actions](https://github.com/emptylight370/jq-action/actions/workflows/test.yml).
