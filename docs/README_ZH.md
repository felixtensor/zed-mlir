# zed-mlir-suite

[![EN](https://img.shields.io/badge/lang-EN-lightgrey?style=flat-square)](../README.md)
[![中文](https://img.shields.io/badge/lang-中文-red?style=flat-square)](README_ZH.md)

[![CI](https://img.shields.io/github/actions/workflow/status/felixtensor/zed-mlir-suite/ci.yml?style=flat-square&logo=githubactions&logoColor=white&label=CI)](https://github.com/felixtensor/zed-mlir-suite/actions/workflows/ci.yml)
[![Version](https://img.shields.io/github/v/tag/felixtensor/zed-mlir-suite?style=flat-square&logo=github&label=version)](https://github.com/felixtensor/zed-mlir-suite/tags)
[![License](https://img.shields.io/badge/license-Apache%202.0%20with%20LLVM%20Exceptions-blue?style=flat-square&logo=apache&logoColor=white)](../LICENSE)
[![Stars](https://img.shields.io/github/stars/felixtensor/zed-mlir-suite?style=flat-square&logo=github)](https://github.com/felixtensor/zed-mlir-suite/stargazers)

为 [Zed](https://zed.dev) 编辑器提供 [MLIR](https://mlir.llvm.org)、TableGen 和 PDLL 支持。

## 功能特性

- **Tree-sitter 语法高亮** — 覆盖 MLIR（`.mlir`）、TableGen（`.td`）和 PDLL（`.pdll`），在 403 个官方 MLIR 测试文件（涵盖 11 个核心 dialect）上实现 100% 通过率，几乎所有合法的 MLIR 语法都能正确高亮。
- **一流的自定义 dialect 支持** — 用户自定义或外部 `dialect.op` 形式均可正确识别和高亮，你的项目自有 dialect 开箱即用。
- **符号大纲** — 在大纲面板中导航 `func.func`、模块、块标签以及 PDLL 的 `Pattern` / `Constraint` / `Rewrite` 声明。
- **集成三种上游 LLVM Language Server**：
  - `mlir-lsp-server` 用于 `.mlir`
  - `mlir-pdll-lsp-server` 用于 `.pdll`
  - `tblgen-lsp-server` 用于 `.td`
- **编辑体验优化** — 括号匹配、自动补全配对符号，以及针对每种语言调优的缩进。

## 前置条件

- [Zed](https://zed.dev) 编辑器
- （可选）LLVM Language Server 用于 LSP 功能 — 详见 [Language Server 配置](#language-server-配置)。

## 安装

在 Zed 的扩展面板中安装（macOS 按 `Cmd+Shift+X`，Linux/Windows 按 `Ctrl+Shift+X`），搜索 "MLIR Suite" 即可。

本地安装为开发扩展（用于开发或测试）：

```bash
git clone https://github.com/felixtensor/zed-mlir-suite.git
```

在 Zed 中打开 **Extensions** → **Install Dev Extension** → 选择克隆的目录。

## Language Server 配置

### 编译服务器

三个 Language Server 位于 `llvm-project` 单体仓库的 `mlir/tools/` 目录下。按照 [MLIR 官方入门指南](https://mlir.llvm.org/getting_started/) 编译即可，典型的 Unix 编译流程如下：

```bash
git clone https://github.com/llvm/llvm-project.git
mkdir llvm-project/build && cd llvm-project/build

cmake -G Ninja ../llvm \
  -DLLVM_ENABLE_PROJECTS=mlir \
  -DLLVM_TARGETS_TO_BUILD="Native" \
  -DCMAKE_BUILD_TYPE=Release \
  -DLLVM_ENABLE_ASSERTIONS=ON

cmake --build . --target mlir-lsp-server mlir-pdll-lsp-server tblgen-lsp-server
```

编译成功后，二进制文件位于 `llvm-project/build/bin/`。将该目录加入 `$PATH`，或通过 `settings.json` 为每个服务器指定绝对路径（见下文）。

> 提示：如果在 `LLVM_ENABLE_PROJECTS` 中列出了 `mlir` 并编译默认的 `all` 目标，三个 LSP 服务器会随 MLIR 一起生成，无需单独构建。

### 配置

每个服务器在 Zed 的 `settings.json` 中通过 `lsp.<server-id>.settings` 进行配置。扩展会通过 `settings.path` 查找服务器二进制文件，若未设置则回退到 `$PATH`。

| 语言 | Server ID |
|---|---|
| MLIR | `mlir-lsp-server` |
| PDLL | `mlir-pdll-lsp-server` |
| TableGen | `tblgen-lsp-server` |

#### 可用配置项

| 字段 | 类型 | 适用 | 说明 |
|---|---|---|---|
| `path` | `string` | 全部 | 服务器二进制文件路径 |
| `compilation_database` | `string` | tblgen, pdll | 编译数据库 YAML 文件路径 |
| `extra_dirs` | `string[]` | tblgen, pdll | 额外 include 目录 |
| `log` | `string` | 全部 | 日志级别：`"error"`、`"info"` 或 `"verbose"` |
| `pretty` | `bool` | 全部 | 美化 JSON 输出 |

所有字段均为可选。扩展会自动检测工作区中的编译数据库文件；如果检测成功，无需手动配置。

#### 示例

```jsonc
{
  "lsp": {
    "mlir-lsp-server": {
      "settings": {
        "path": "/path/to/mlir-lsp-server",
        "log": "verbose"
      }
    },
    "tblgen-lsp-server": {
      "settings": {
        "path": "/path/to/tblgen-lsp-server",
        "compilation_database": "/path/to/build/tablegen_compile_commands.yml",
        "extra_dirs": [
          "/path/to/llvm-project/llvm/include",
          "/path/to/llvm-project/mlir/include"
        ]
      }
    },
    "mlir-pdll-lsp-server": {
      "settings": {
        "path": "/path/to/mlir-pdll-lsp-server",
        "compilation_database": "/path/to/build/pdll_compile_commands.yml",
        "extra_dirs": [
          "/path/to/llvm-project/mlir/include"
        ]
      }
    }
  }
}
```

> Zed 原生的 `binary.path` 和 `binary.arguments` 字段仍然有效，设置后会优先使用。

修改配置后，打开命令面板（macOS 按 `Cmd+Shift+P`，Linux/Windows 按 `Ctrl+Shift+P`）并执行 `zed: restart language server` 以应用更改。

## 截图

### 跳转到定义

![Go to Definition](https://github.com/user-attachments/assets/88ce2c21-1d4b-4ef3-921f-77edf6aea86a)

### 查找引用

![Find References](https://github.com/user-attachments/assets/98e8634a-569c-44eb-9f38-34a5cab7ee24)

### 悬停 / 签名

![Hover / Signature](https://github.com/user-attachments/assets/72278371-8e92-46dc-8aa8-82413c0da439)

### 补全

![Completion](https://github.com/user-attachments/assets/2bd1a63a-d512-4f25-88fa-3c4d58fe5b5c)

### 诊断

![Diagnostics](https://github.com/user-attachments/assets/13859477-98fa-49c1-bd4e-b766956db866)

### 符号大纲

![Symbol Outline](https://github.com/user-attachments/assets/d8c6bde8-e90f-4f03-8399-2ce9914e3c94)

## 致谢

本扩展基于以下项目构建：

- [MLIR](https://mlir.llvm.org) — LLVM 项目中的多层中间表示框架。
- [tree-sitter-mlir](https://github.com/felixtensor/tree-sitter-mlir) — MLIR 的 Tree-sitter 语法。
- [tree-sitter-tablegen](https://github.com/felixtensor/tree-sitter-tablegen) — TableGen 的 Tree-sitter 语法。
- [tree-sitter-pdll](https://github.com/felixtensor/tree-sitter-pdll) — PDLL 的 Tree-sitter 语法。
- 三个 LSP 服务器（`mlir-lsp-server`、`mlir-pdll-lsp-server`、`tblgen-lsp-server`）是 [LLVM 项目](https://github.com/llvm/llvm-project) 的一部分。

其他编辑器中的 MLIR 工具：

- [vscode-mlir](https://github.com/llvm/vscode-mlir) — 官方的 MLIR、PDLL 和 TableGen VS Code 扩展。
- [mlir-mode](https://github.com/llvm/llvm-project/tree/main/mlir/utils/emacs) — Emacs 主模式及 LSP 客户端，随 LLVM 单体仓库发布。

## 反馈与贡献

本扩展正在积极开发中。请参阅 [路线图](ROADMAP.md) 了解接下来的计划。欢迎各种形式的贡献 — 错误报告、功能请求和拉取请求：

- [提交 Issue](https://github.com/felixtensor/zed-mlir-suite/issues)
- 提交 Pull Request 包含你的改进

## 许可证

Apache License 2.0 with LLVM Exceptions。
