use std::collections::HashMap;

use zed_extension_api::{self as zed, settings::LspSettings, LanguageServerId, Result};

struct MlirSuiteExtension {
    path_cache: HashMap<String, String>,
}

impl MlirSuiteExtension {
    fn resolve_from_path(
        &mut self,
        server_id: &str,
        default_binary: &str,
        worktree: &zed::Worktree,
    ) -> Result<String> {
        if let Some(path) = self.path_cache.get(server_id) {
            return Ok(path.clone());
        }
        let path = worktree.which(default_binary).ok_or_else(|| {
            format!(
                "`{default_binary}` not found. Install it from the LLVM project \
                 (`cmake --build . --target {default_binary}`) and either add it to \
                 your $PATH or set `lsp.{server_id}.binary.path` in settings.json."
            )
        })?;
        self.path_cache
            .insert(server_id.to_string(), path.clone());
        Ok(path)
    }
}

impl zed::Extension for MlirSuiteExtension {
    fn new() -> Self {
        Self {
            path_cache: HashMap::new(),
        }
    }

    fn language_server_command(
        &mut self,
        id: &LanguageServerId,
        worktree: &zed::Worktree,
    ) -> Result<zed::Command> {
        let default_binary: &str = match id.as_ref() {
            "mlir-lsp-server" => "mlir-lsp-server",
            "mlir-pdll-lsp-server" => "mlir-pdll-lsp-server",
            "tblgen-lsp-server" => "tblgen-lsp-server",
            other => return Err(format!("unknown language server id: {other}")),
        };
        let server_id = default_binary;

        let user_binary = LspSettings::for_worktree(server_id, worktree)
            .ok()
            .and_then(|s| s.binary);

        let command = match user_binary.as_ref().and_then(|b| b.path.clone()) {
            Some(path) => path,
            None => self.resolve_from_path(server_id, default_binary, worktree)?,
        };

        let args = user_binary
            .as_ref()
            .and_then(|b| b.arguments.clone())
            .unwrap_or_default();

        let env = user_binary
            .and_then(|b| b.env)
            .map(|m| m.into_iter().collect::<Vec<(String, String)>>())
            .unwrap_or_default();

        Ok(zed::Command { command, args, env })
    }
}

zed::register_extension!(MlirSuiteExtension);
