# zed-mlir

MLIR and TableGen extension for the [Zed](https://zed.dev) editor.

## Features

- **Syntax highlighting** for MLIR (`.mlir`) and TableGen (`.td`) files
- **Tree-sitter grammar** — 100% pass rate on 403 official MLIR test files across 11 core dialects
- **Symbol outline** — navigate functions (`func.func`), modules, and block labels
- **Language server support** via `mlir-lsp-server` (must be in `$PATH`)
- **Bracket matching, auto-close, and indentation**

## Installation

### Option 1: Install from pre-built extension (when available)
1. Open Zed editor
2. Press `Cmd+Shift+P` (macOS) or `Ctrl+Shift+P` (Linux/Windows) to open the command palette
3. Type "Install Extension" and select it
4. Search for "mlir" and install the extension

### Option 2: Install as dev extension
1. Clone this repository:
   ```bash
   git clone https://github.com/felixtensor/zed-mlir.git
   ```

2. In Zed, open **Extensions** (`Cmd+Shift+X` on macOS), click **Install Dev Extension**, and select the cloned `zed-mlir` directory.

   Zed will build the extension automatically. Any local changes are picked up on rebuild.
