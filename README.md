# zed-mlir

[MLIR](https://mlir.llvm.org), TableGen, and PDLL support for the [Zed](https://zed.dev) editor.

## Features

- **Tree-sitter grammars** for MLIR (`.mlir`), TableGen (`.td`), and PDLL (`.pdll`) — 100% pass rate on 403 official MLIR test files across 11 core dialects, meaning virtually all valid MLIR syntax is highlighted correctly out of the box.
- **First-class custom dialect support** — user-defined or out-of-tree `dialect.op` forms are recognized and highlighted correctly, so your project's own dialects just work.
- **Symbol outline** — navigate `func.func`, modules, block labels, and PDLL `Pattern` / `Constraint` / `Rewrite` declarations from the outline panel.
- **Language Server integration** for all three upstream LLVM servers:
  - `mlir-lsp-server` for `.mlir`
  - `mlir-pdll-lsp-server` for `.pdll`
  - `tblgen-lsp-server` for `.td`
- **Editing ergonomics** — bracket matching, auto-close pairs, and indentation tuned for each language.

## Prerequisites

- [Zed](https://zed.dev) editor
- (Optional) LLVM language servers for LSP features — see [Language Server Setup](#language-server-setup).

## Installation

Install from Zed's Extensions panel (`Cmd+Shift+X` on macOS, `Ctrl+Shift+X` on Linux/Windows) and search for "MLIR Suite".

To install locally as a dev extension (for development or testing):

```bash
git clone https://github.com/felixtensor/zed-mlir.git
```

In Zed, open **Extensions** → **Install Dev Extension** → select the cloned directory.

## Language Server Setup

### Building the servers

The three servers live in the `llvm-project` monorepo under `mlir/tools/`. Follow the [official MLIR Getting Started guide](https://mlir.llvm.org/getting_started/) to build them; a typical Unix-like flow is:

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

After a successful build, the binaries land in `llvm-project/build/bin/`. Either add that directory to your `$PATH`, or point each server at its absolute path via `settings.json` (see below).

> Tip: if `mlir` is listed in `LLVM_ENABLE_PROJECTS` and you build the default `all` target, the three LSP servers are produced along with the rest of MLIR — no separate invocation needed.

### Configuration

Each server is configured under `lsp.<server-id>.settings` in Zed's `settings.json`. The extension looks for the server binary via `settings.path`, then falls back to `$PATH`.

| Language | Server id |
|---|---|
| MLIR | `mlir-lsp-server` |
| PDLL | `mlir-pdll-lsp-server` |
| TableGen | `tblgen-lsp-server` |

#### Available settings

| Field | Type | Applies to | Description |
|---|---|---|---|
| `path` | `string` | all | Path to the server binary |
| `compilation_database` | `string` | tblgen, pdll | Path to the compilation-database YAML |
| `extra_dirs` | `string[]` | tblgen, pdll | Extra include directories |
| `log` | `string` | all | Log verbosity: `"error"`, `"info"`, or `"verbose"` |
| `pretty` | `bool` | all | Pretty-print JSON output |

All fields are optional. The extension auto-detects compilation-database files in your workspace; if detection succeeds, no manual configuration is needed.

#### Example

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

> Zed's native `binary.path` and `binary.arguments` fields still work and take precedence when set.

After changing settings, open the command palette (`Cmd+Shift+P` on macOS, `Ctrl+Shift+P` on Linux/Windows) and run `zed: restart language server` to apply them.

## Screenshots

### Go to Definition

![Go to Definition](https://github.com/user-attachments/assets/88ce2c21-1d4b-4ef3-921f-77edf6aea86a)

### Find References

![Find References](https://github.com/user-attachments/assets/98e8634a-569c-44eb-9f38-34a5cab7ee24)

### Hover / Signature

![Hover / Signature](https://github.com/user-attachments/assets/72278371-8e92-46dc-8aa8-82413c0da439)

### Completion

![Completion](https://github.com/user-attachments/assets/2bd1a63a-d512-4f25-88fa-3c4d58fe5b5c)

### Diagnostics

![Diagnostics](https://github.com/user-attachments/assets/13859477-98fa-49c1-bd4e-b766956db866)

### Symbol Outline

![Symbol Outline](https://github.com/user-attachments/assets/d8c6bde8-e90f-4f03-8399-2ce9914e3c94)

## Acknowledgements

This extension builds on:

- [MLIR](https://mlir.llvm.org) — the multi-level intermediate representation framework from the LLVM project.
- [tree-sitter-mlir](https://github.com/felixtensor/tree-sitter-mlir) — Tree-sitter grammar for MLIR.
- [tree-sitter-tablegen](https://github.com/tree-sitter-grammars/tree-sitter-tablegen) — Tree-sitter grammar for TableGen.
- [tree-sitter-pdll](https://github.com/felixtensor/tree-sitter-pdll) — Tree-sitter grammar for PDLL.
- The three LSP servers (`mlir-lsp-server`, `mlir-pdll-lsp-server`, `tblgen-lsp-server`) are part of the [LLVM project](https://github.com/llvm/llvm-project).

For MLIR tooling in other editors, see:

- [vscode-mlir](https://github.com/llvm/vscode-mlir) — official VS Code extension for MLIR, PDLL, and TableGen.
- [mlir-mode](https://github.com/llvm/llvm-project/tree/main/mlir/utils/emacs) — Emacs major mode and LSP client, shipped in the LLVM monorepo.

## Feedback & Contributions

This extension is actively developed. See the [roadmap](docs/ROADMAP.md) for what's planned next. Contributions of all sizes are welcome — bug reports, feature requests, and pull requests:

- [Open an issue](https://github.com/felixtensor/zed-mlir/issues)
- Submit a pull request with your improvements

## License

Apache License 2.0 with LLVM Exceptions.
