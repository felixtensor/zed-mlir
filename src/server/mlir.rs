use super::LanguageServer;

/// Language-server integration for `mlir-lsp-server`.
pub struct MlirServer;

impl LanguageServer for MlirServer {
    fn id(&self) -> &'static str {
        "mlir-lsp-server"
    }

    fn default_binary(&self) -> &'static str {
        "mlir-lsp-server"
    }
}
