use super::LanguageServer;

/// Language-server integration for `mlir-pdll-lsp-server`.
pub struct PdllServer;

impl LanguageServer for PdllServer {
    fn id(&self) -> &'static str {
        "mlir-pdll-lsp-server"
    }

    fn default_binary(&self) -> &'static str {
        "mlir-pdll-lsp-server"
    }

    fn compilation_db_flag(&self) -> Option<&'static str> {
        Some("--pdll-compilation-database")
    }

    fn compilation_db_filename(&self) -> Option<&'static str> {
        Some("pdll_compile_commands.yml")
    }

    fn extra_dir_flag(&self) -> Option<&'static str> {
        Some("--pdll-extra-dir")
    }
}

