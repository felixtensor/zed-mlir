# Changelog

This document records shipped project history reconstructed from the local Git
tags. Dates are tag creation dates. The earliest tagged release, v0.2.0,
contains the initial project setup up to that tag.

For future plans, see [docs/ROADMAP.md](docs/ROADMAP.md).

## [v0.5.2] - 2026-05-07

### Added

- Switched TableGen support to the maintained
  [`felixtensor/tree-sitter-tablegen`](https://github.com/felixtensor/tree-sitter-tablegen)
  grammar.
- Added TableGen C++ injection for ODS code-carrying fields, with injection
  restricted to known code fields instead of arbitrary descriptions or strings.
- Added TableGen string escape highlighting.

### Changed

- Render TableGen `[{ ... }]` code literals as string-like source regions
  instead of generic embedded content.
- Highlight TableGen `$name` uniformly as `@variable.special`.

### Fixed

- Removed an invalid anonymous-node match from the TableGen queries.

## [v0.5.1] - 2026-04-24

### Added

- Added structured LSP settings and extra include directory support for
  TableGen and PDLL language servers.
- Added auto-detection for `tablegen_compile_commands.yml` and
  `pdll_compile_commands.yml` in common build directories.
- Added GitHub Actions CI for build verification.
- Added C++ injection inside PDLL native `[{ ... }]` code blocks.

### Changed

- Refactored language-server integration into dedicated server modules.
- Unified server configuration handling across MLIR, PDLL, and TableGen.
- Renamed the repository to `zed-mlir-suite` and updated extension metadata.
- Reorganized README onboarding and configuration documentation.
- Replaced manually played README videos with optimized auto-playing GIFs.

### Improved

- Refined MLIR highlighting for dictionary attribute keys, composite builtin
  type nodes, affine keywords/operators, and indentation behavior.
- Added comments documenting Zed's last-match-wins query behavior where it
  affects MLIR highlighting rules.

## [v0.5.0] - 2026-04-21

### Added

- Wired up all three upstream LLVM language servers:
  `mlir-lsp-server`, `mlir-pdll-lsp-server`, and `tblgen-lsp-server`.
- Added per-server binary path resolution and argument passthrough through
  Zed LSP settings.
- Added LSP setup documentation, screenshots, and the first roadmap document.

### Changed

- Rebranded the extension from `MLIR` to `MLIR Suite`.
- Changed the extension id to `mlir-suite`.
- Cleaned up `extension.toml` grammar and language-server metadata.
- Hosted demo media through GitHub user attachments.

### Fixed

- Rewrote TableGen indentation using generic bracket-pair matching.

## [v0.4.0] - 2026-04-20

### Added

- Added initial PDLL language support, including grammar registration,
  highlights, indentation, bracket matching, and symbol outline.
- Added README feedback and contribution guidance.

### Improved

- Ordered PDLL highlights for Zed's last-match-wins query semantics.
- Improved PDLL builtin type constraint highlighting.
- Improved TableGen highlighting for member access and `let` item fields.

### Fixed

- Reordered MLIR `dense_resource` bare id highlighting to preserve the intended
  fallback behavior.

## [v0.3.1] - 2026-04-16

### Added

- Added MLIR highlighting support for `public` visibility.
- Added MLIR module `attributes` highlighting.

### Changed

- Updated README content to reflect current features and dev-install workflow.
- Aligned MLIR module highlighting with the latest grammar/query behavior.

## [v0.3.0] - 2026-04-13

### Added

- Added TableGen (`.td`) language support.
- Added TableGen grammar registration, language configuration, highlighting,
  indentation, and bracket matching.

### Fixed

- Fixed the TableGen `block_comment` configuration.

## [v0.2.1] - 2026-04-02

### Added

- Added MLIR indentation support.
- Added MLIR symbol outline support.

### Improved

- Expanded and refined MLIR syntax highlighting to better match the intended
  TextMate-style scopes.
- Improved `dense_resource` highlighting and bumped the MLIR grammar revision.

### Fixed

- Fixed an issue that prevented the MLIR language from loading.

## [v0.2.0] - 2026-03-31

### Added

- Added the initial Rust-based Zed extension structure.
- Added MLIR language registration, grammar metadata, syntax highlighting, and
  bracket matching.
- Added the initial README, license, Cargo manifest, and extension metadata.

### Fixed

- Fixed early installation failures and version metadata issues before the
  first tagged release.

[v0.5.2]: https://github.com/felixtensor/zed-mlir-suite/compare/v0.5.1...v0.5.2
[v0.5.1]: https://github.com/felixtensor/zed-mlir-suite/compare/v0.5.0...v0.5.1
[v0.5.0]: https://github.com/felixtensor/zed-mlir-suite/compare/v0.4.0...v0.5.0
[v0.4.0]: https://github.com/felixtensor/zed-mlir-suite/compare/v0.3.1...v0.4.0
[v0.3.1]: https://github.com/felixtensor/zed-mlir-suite/compare/v0.3.0...v0.3.1
[v0.3.0]: https://github.com/felixtensor/zed-mlir-suite/compare/v0.2.1...v0.3.0
[v0.2.1]: https://github.com/felixtensor/zed-mlir-suite/compare/v0.2.0...v0.2.1
[v0.2.0]: https://github.com/felixtensor/zed-mlir-suite/releases/tag/v0.2.0
