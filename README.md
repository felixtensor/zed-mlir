# zed-mlir

The MLIR extension for Zed editor. This extension provides support for MLIR (Multi-Level Intermediate Representation) files, including syntax highlighting and language server integration(WIP).

## Features

- **Syntax highlighting** for MLIR files (`.mlir`)
- **Tree-sitter grammar** for accurate parsing
- **Language server support** via mlir-lsp-server
- **Basic code navigation** and diagnostics

## Installation

### Option 1: Install from pre-built extension (when available)
1. Open Zed editor
2. Press `Cmd+Shift+P` (macOS) or `Ctrl+Shift+P` (Linux/Windows) to open the command palette
3. Type "Install Extension" and select it
4. Search for "mlir" and install the extension

### Option 2: Build from source
1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/zed-mlir.git
   cd zed-mlir
   ```

2. Build the extension:
   ```bash
   cargo build --release
   ```

3. The built extension will be at `target/release/libzed_mlir.so` (Linux), `target/release/libzed_mlir.dylib` (macOS), or `target/release/zed_mlir.dll` (Windows)

4. Copy the built library to Zed's extensions directory:
   - **macOS**: `~/Library/Application Support/Zed/extensions/`
   - **Linux**: `~/.local/share/zed/extensions/`
   - **Windows**: `%APPDATA%\Zed\extensions\`

5. Restart Zed
