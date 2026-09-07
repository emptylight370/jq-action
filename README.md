**English**
| [简体中文](README.zh_CN.md)

![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/emptylight370/jq-action/test.yml?style=plastic&label=test&link=https%3A%2F%2Fgithub.com%2Femptylight370%2Fjq-action%2Factions%2Fworkflows%2Ftest.yml)
![GitHub Release](https://img.shields.io/github/v/release/emptylight370/jq-action?style=plastic&link=https%3A%2F%2Fgithub.com%2Femptylight370%2Fjq-action)
![GitHub Repo stars](https://img.shields.io/github/stars/emptylight370/jq-action?link=https%3A%2F%2Fgithub.com%2Femptylight370%2Fjq-action)
![GitHub commits since latest release](https://img.shields.io/github/commits-since/emptylight370/jq-action/latest?style=plastic&link=https%3A%2F%2Fgithub.com%2Femptylight370%2Fjq-action)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/emptylight370/jq-action?style=plastic&link=https%3A%2F%2Fgithub.com%2Femptylight370%2Fjq-action)

Run jq command in GitHub Actions and return process result.

---

## Inputs

| Name      | Required | Type    | Default | Description                                                                                                                                                   |
| --------- | -------- | ------- | ------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `data`    | ✅ Yes   | string  | -       | Processed as a JSON string first, then as a file path if not valid JSON                                                                                       |
| `filter`  | ✅ Yes   | string  | -       | jq filter expression, see [jq documentation](https://jqlang.org/manual/#basic-filters)                                                                        |
| `raw`     | ❌ No    | boolean | `true`  | Raw output mode. Set to `true` to return non-JSON string(with `-r` symbol)                                                                                    |
| `options` | ❌ No    | string  | -       | Extra options appended to the jq command. see [jq options](https://jqlang.org/manual/#invoking-jq)<br/>Note: the input is split by spaces, `"a b"->["a","b"]` |

> [!TIP]
> When you need to pass `--null-input` option, please set `data` parameter to `'null'/"null"`. Then you don't need to pass `--null-input` option.

## Outputs

| Name        | Description                                                      | Type           |
| ----------- | ---------------------------------------------------------------- | -------------- |
| `result`    | The result of jq command, output as-is(single line or multiline) | String         |
| `multiline` | Whether the result of jq command is multiline                    | `true`/`false` |

## Examples

### Basic usage

```yaml
name: Process JSON

on: [push]

jobs:
  process:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v7

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

## jq Version

This action uses the `jq` version **preinstalled on the GitHub Actions runner** — it does not install jq itself. For the specific jq version, see the README of the corresponding runner image repository (e.g., [actions/runner-images](https://github.com/actions/runner-images)).
