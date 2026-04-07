[English](README.md)
| **简体中文**

![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/emptylight370/jq-action/test.yml?style=plastic&label=test&link=https%3A%2F%2Fgithub.com%2Femptylight370%2Fjq-action%2Factions%2Fworkflows%2Ftest.yml)
![GitHub Release](https://img.shields.io/github/v/release/emptylight370/jq-action?style=plastic&link=https%3A%2F%2Fgithub.com%2Femptylight370%2Fjq-action)
![GitHub Repo stars](https://img.shields.io/github/stars/emptylight370/jq-action?link=https%3A%2F%2Fgithub.com%2Femptylight370%2Fjq-action)
![GitHub commits since latest release](https://img.shields.io/github/commits-since/emptylight370/jq-action/latest?style=plastic&link=https%3A%2F%2Fgithub.com%2Femptylight370%2Fjq-action)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/emptylight370/jq-action?style=plastic&link=https%3A%2F%2Fgithub.com%2Femptylight370%2Fjq-action)

在 GitHub Actions 中运行 jq 命令并返回处理结果。

---

## 输入参数

| 参数名    | 必需  | 类型    | 默认值 | 描述                                                                             |
| --------- | ----- | ------- | ------ | -------------------------------------------------------------------------------- |
| `data`    | ✅ 是 | string  | -      | 要处理的 JSON 文件路径或者 JSON 字符串                                           |
| `filter`  | ✅ 是 | string  | -      | jq 过滤器表达式，参考 [jq 文档](https://jqlang.org/manual/#basic-filters)        |
| `raw`     | ❌ 否 | boolean | `true` | 原始输出模式。设置为 `true` 时输出非 JSON 字符串（使用 `-r` 标志）               |
| `options` | ❌ 否 | string  | -      | 追加到 jq 命令的额外选项。参考 [jq 选项](https://jqlang.org/manual/#invoking-jq) |

> [!TIP]
> 在需要传入 `--null-input` 选项时，请将 `data` 参数设置为 `'null'`。此时不需要再传入 `--null-input` 选项。

## 输出参数

| 输出名      | 描述                                        | 类型           |
| ----------- | ------------------------------------------- | -------------- |
| `result`    | jq 命令的执行结果，按原样输出（单行或多行） | 字符串         |
| `multiline` | jq 命令的执行结果是否为多行                 | `true`/`false` |

## 使用示例

### 基本用法

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

### 复杂用法

见 [test.yml](.github/workflows/test.yml) 文件。相关输出见 [actions](https://github.com/emptylight370/jq-action/actions/workflows/test.yml)。
