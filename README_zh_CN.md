[English](README.md)
| **简体中文**

在 GitHub Actions 中运行 jq 命令并返回处理结果。

## 输入参数

| 参数名    | 必需  | 默认值 | 描述                                                                             |
| --------- | ----- | ------ | -------------------------------------------------------------------------------- |
| `data`    | ✅ 是 | -      | 要处理的 JSON 文件路径或者 JSON 字符串                                           |
| `filter`  | ✅ 是 | -      | jq 过滤器表达式，参考 [jq 文档](https://jqlang.org/manual/#basic-filters)        |
| `raw`     | ❌ 否 | `true` | 原始输出模式。设置为 `true` 时输出非 JSON 字符串（使用 `-r` 标志）。             |
| `options` | ❌ 否 | -      | 追加到 jq 命令的额外选项。参考 [jq 选项](https://jqlang.org/manual/#invoking-jq) |

## 输出参数

| 输出名   | 描述              |
| -------- | ----------------- |
| `result` | jq 命令的执行结果 |

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
