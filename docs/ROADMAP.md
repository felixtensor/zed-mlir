# Roadmap

This document tracks the planned direction of **MLIR Suite**. Items are grouped by priority, not by commitment — timing depends on upstream LLVM releases, user feedback, and available time. Nothing here is a promise.

## Shipped

### v0.5.0 — LSP foundation
- Three language servers wired up (`mlir-lsp-server`, `mlir-pdll-lsp-server`, `tblgen-lsp-server`) with per-server binary path override and argument passthrough via `settings.json`.
- Rebrand to `mlir-suite` with a feature-focused README and initial screenshots section.
- `extension.toml` cleaned up (`commit` fields, full `[language_servers.*]` tables).

### v0.4.0 — PDLL support
- Independent PDLL grammar, highlights, and symbol outline.
- TableGen grammar fixes (member access, let-item fields).
- MLIR grammar reaches 100% pass rate on 403 official test files.

## Near-term (v0.6.x)

- **Structured compilation-database settings.** Today users pass `--pdll-compilation-database=…` / `--tablegen-compilation-database=…` / `--*-extra-dir=…` as raw CLI arguments. Add a structured schema in `settings.json` and translate it into CLI flags automatically.
- **Auto-detect `build/*_compile_commands.yml`** in the workspace when no explicit database is configured.
- **Continued language highlight & editor-capability work.** A steady stream of small, focused improvements: query-level highlight refinements for PDLL and TableGen, new capability files (shell injection on `// RUN:` comments, `folds.scm` for block folding, `outline.scm` for TableGen), and incremental grammar fixes.
- **MLIR inside C++ raw strings (`R"mlir(…)mlir"`).** Zed's bundled C++ grammar already injects `raw_string_content` using the delimiter as `@injection.language`. Since this extension registers the `mlir` grammar, the injection may already work out of the box. Needs verification with a real `.cpp` file containing `R"mlir(...)mlir"`.

## Mid-term

- **Switch to [`felixtensor/tree-sitter-tablegen`](https://github.com/felixtensor/tree-sitter-tablegen) as the TableGen grammar.** The current upstream grammar was developed against a narrow corpus and frequently fails on real-world `.td` files outside MLIR. Replace the pin with our own maintained grammar, validated against four corpora and kept passing:
  - **MLIR TableGen** — dialect / op / pass definitions under `mlir/include/mlir/` and `mlir/test/`
  - **LLVM TableGen** — target backends under `llvm/lib/Target/*/` (heavy use of intrinsics, patterns, register classes)
  - **Clang TableGen** — `clang/include/clang/Basic/{Attr,Diagnostic,StmtNodes,…}.td`
  - **LLDB TableGen** — command option definitions under `lldb/source/Commands/Options.td` and related
  A CI harness must parse a curated subset of each and assert zero `ERROR` nodes before the grammar pin is bumped.
- **`.mlirbc` bytecode support.** Render MLIR bytecode as text via `mlir-lsp-server`. Zed's extension API does not currently expose a custom-editor surface; add support when the API is available.
- **Inlay hints** for SSA value types and block arguments, pending `mlir-lsp-server` support for the inlay-hint LSP request.

## Ideas (unscored)

- Code-lens links from a PDLL `Pattern` to the TableGen op definition it rewrites.
- Quick-fix for "missing `include`" in TableGen (auto-insert the canonical header path).
- Dialect-aware highlighting inside MLIR string attributes that embed recognized DSLs.
- **LSP settings-change behavior.** Zed's core already auto-restarts language servers when binary paths or initialization options change. The extension API does not expose hooks to intercept settings changes or present custom restart prompts, so finer-grained control (prompt / auto-restart / ignore) is not implementable by extensions today.

## How to propose changes

Open an issue at [felixtensor/zed-mlir](https://github.com/felixtensor/zed-mlir/issues) with:
- What problem you hit or what workflow you want,
- Any pointers to upstream LLVM docs or related issues.
