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
}
