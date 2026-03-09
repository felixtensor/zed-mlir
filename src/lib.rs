use zed_extension_api::{self as zed, LanguageServerId, Result};

struct MlirExtension {
    cached_binary_path: Option<String>,
}

impl zed::Extension for MlirExtension {
    fn new() -> Self {
        Self {
            cached_binary_path: None,
        }
    }

    fn language_server_command(
        &mut self,
        _language_server_id: &LanguageServerId,
        worktree: &zed::Worktree,
    ) -> Result<zed::Command> {
        let path = if let Some(path) = &self.cached_binary_path {
            path.clone()
        } else {
            let path = worktree
                .which("mlir-lsp-server")
                .ok_or_else(|| "mlir-lsp-server must be installed and in your PATH".to_string())?;
            self.cached_binary_path = Some(path.clone());
            path
        };

        Ok(zed::Command {
            command: path,
            args: vec![],
            env: Default::default(),
        })
    }
}

zed::register_extension!(MlirExtension);
