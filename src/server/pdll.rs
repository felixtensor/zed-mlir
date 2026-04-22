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
}
