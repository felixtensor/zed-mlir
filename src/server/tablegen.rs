use super::LanguageServer;

/// Language-server integration for `tblgen-lsp-server`.
pub struct TablegenServer;

impl LanguageServer for TablegenServer {
    fn id(&self) -> &'static str {
        "tblgen-lsp-server"
    }

    fn default_binary(&self) -> &'static str {
        "tblgen-lsp-server"
    }

    fn compilation_db_flag(&self) -> Option<&'static str> {
        Some("--tablegen-compilation-database")
    }

    fn compilation_db_filename(&self) -> Option<&'static str> {
        Some("tablegen_compile_commands.yml")
    }

    fn extra_dir_flag(&self) -> Option<&'static str> {
        Some("--tablegen-extra-dir")
    }
}

