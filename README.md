# zed-mlir

The MLIR extension for Zed editor. This extension provides support for MLIR (Multi-Level Intermediate Representation) files, including syntax highlighting and language server integration.

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

## Requirements

### MLIR Language Server
This extension requires an MLIR language server for advanced features like diagnostics, code completion, and navigation. You have several options:

1. **Build from LLVM source** (recommended for latest features):
   ```bash
   # Clone LLVM project
   git clone https://github.com/llvm/llvm-project.git
   cd llvm-project
   
   # Configure and build with mlir-lsp-server
   cmake -S llvm -B build -G Ninja \
     -DCMAKE_BUILD_TYPE=Release \
     -DLLVM_ENABLE_PROJECTS="mlir" \
     -DLLVM_BUILD_EXAMPLES=OFF \
     -DLLVM_TARGETS_TO_BUILD="host" \
     -DLLVM_ENABLE_ASSERTIONS=ON \
     -DLLVM_ENABLE_RTTI=ON
   
   cmake --build build --target mlir-lsp-server
   ```

2. **Install via package manager** (if available for your distribution):
   - Check your distribution's package repositories for `mlir-lsp-server` or similar packages

3. **Use pre-built binaries** (if available from your LLVM distribution)

Once installed, ensure `mlir-lsp-server` is in your `PATH` environment variable.

## Configuration

The extension automatically looks for `mlir-lsp-server` in your PATH. You can configure language server settings through Zed's settings:

1. Open Zed Settings (`Cmd+,` on macOS or `Ctrl+,` on Linux/Windows)
2. Navigate to the "Language Server" section
3. Look for "MLIR" settings

### Example settings:
```json
{
  "language_servers": {
    "mlir": {
      "settings": {
        "diagnostics": true,
        "hover": true,
        "completion": true
      }
    }
  }
}
```

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Zed](https://zed.dev/) team for the excellent editor and extension API
- [artagnon/tree-sitter-mlir](https://github.com/artagnon/tree-sitter-mlir) for the MLIR grammar
- [LLVM Project](https://llvm.org/) for the MLIR infrastructure

## Related Links

- [Zed Extensions Documentation](https://zed.dev/docs/extensions)
- [MLIR Documentation](https://mlir.llvm.org/)
- [LLVM Project](https://github.com/llvm/llvm-project)
