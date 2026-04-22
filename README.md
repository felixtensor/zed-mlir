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

The extension looks for each server binary first in `lsp.<server-id>.binary.path` (Zed `settings.json`), then on `$PATH`.

| Language | Server id |
|---|---|
| MLIR | `mlir-lsp-server` |
| PDLL | `mlir-pdll-lsp-server` |
| TableGen | `tblgen-lsp-server` |

**Override a binary path** (server installed outside `$PATH`):

```json
{
  "lsp": {
    "mlir-lsp-server": {
      "binary": {
        "path": "/path/to/llvm-project/build/bin/mlir-lsp-server"
      }
    }
  }
}
```

#### Compilation database & include paths

Both `tblgen-lsp-server` and `mlir-pdll-lsp-server` need a compilation database or include paths to resolve cross-file references. Without them, go-to-definition and completion will silently fail on most symbols.

**Auto-detection:** The extension attempts to locate compilation-database files in your workspace automatically. If detection succeeds, no manual configuration is needed.

**Structured settings** (when the database or includes live elsewhere):

```json
{
  "lsp": {
    "tblgen-lsp-server": {
      "settings": {
        "compilation_database": "/path/to/build/tablegen_compile_commands.yml",
        "extra_dirs": [
          "/path/to/llvm-project/llvm/include",
          "/path/to/llvm-project/mlir/include"
        ]
      }
    },
    "mlir-pdll-lsp-server": {
      "settings": {
        "compilation_database": "/path/to/build/pdll_compile_commands.yml",
        "extra_dirs": [
          "/path/to/llvm-project/mlir/include"
        ]
      }
    }
  }
}
```

> If `binary.arguments` contains the same flag, it takes precedence over `settings` and auto-detection.

<details>
<summary><strong>Advanced: verbose logging</strong></summary>

All three servers accept `--log={error|info|verbose}`:

```json
{
  "lsp": {
    "mlir-lsp-server": {
      "binary": {
        "arguments": ["--log=verbose"]
      }
    }
  }
}
```

</details>

After changing settings, open the command palette (`Cmd+Shift+P` on macOS, `Ctrl+Shift+P` on Linux/Windows) and run `zed: restart language server` to apply them.

## Screenshots

### Go to Definition

https://github.com/user-attachments/assets/97f13623-d392-4c7a-9c26-de4f7484af50

### Find References

https://github.com/user-attachments/assets/6dcd6cf9-8b9d-4d0c-8555-749d6da5ed56

### Hover / Signature

https://github.com/user-attachments/assets/96413a29-765b-4790-8f6d-8ffabd862f05

### Completion

https://github.com/user-attachments/assets/e3c57915-7c78-4105-8b0f-1a0e81fb802f

### Diagnostics

https://github.com/user-attachments/assets/da49abbb-9c66-422c-9b1d-dc6b6e66fc62

### Symbol Outline

https://github.com/user-attachments/assets/84bedf58-82f9-466c-a163-dba9d0fb8412

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
