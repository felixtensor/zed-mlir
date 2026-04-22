use std::collections::HashMap;

use zed_extension_api::{self as zed, settings::LspSettings, Result, Worktree};

mod mlir;
mod pdll;
mod tablegen;

pub use mlir::MlirServer;
pub use pdll::PdllServer;
pub use tablegen::TablegenServer;

/// Trait defining the interface for a language server integration.
///
/// The default implementation of [`resolve_command`](LanguageServer::resolve_command)
/// handles the common boilerplate:
/// - reading per-worktree `LspSettings` from Zed's `settings.json`
/// - resolving the server binary from a user-provided path, cache, or `$PATH`
/// - assembling the final `zed::Command` with arguments and environment variables.
///
/// Individual servers can override `resolve_command` when they need to inject
/// auto-detected flags (e.g. `--tablegen-compilation-database`) or perform
/// custom argument assembly.
pub trait LanguageServer {
    /// The language-server ID used in `extension.toml` and `settings.json`.
    fn id(&self) -> &'static str;

    /// The default binary name looked up on `$PATH`.
    fn default_binary(&self) -> &'static str;

    /// Resolve the full command used to start this language server.
    fn resolve_command(
        &self,
        worktree: &Worktree,
        path_cache: &mut HashMap<&'static str, String>,
    ) -> Result<zed::Command> {
        let user_binary = LspSettings::for_worktree(self.id(), worktree)
            .ok()
            .and_then(|s| s.binary);

        let command = match user_binary.as_ref().and_then(|b| b.path.clone()) {
            Some(path) => path,
            None => self.resolve_from_path(worktree, path_cache)?,
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

    /// Look up the server binary on `$PATH`, with caching.
    fn resolve_from_path(
        &self,
        worktree: &Worktree,
        path_cache: &mut HashMap<&'static str, String>,
    ) -> Result<String> {
        if let Some(path) = path_cache.get(self.id()) {
            return Ok(path.clone());
        }

        let path = worktree.which(self.default_binary()).ok_or_else(|| {
            format!(
                "`{}` not found. Install it from the LLVM project \
                 (`cmake --build . --target {}`) and either add it to \
                 your $PATH or set `lsp.{}.binary.path` in settings.json.",
                self.default_binary(),
                self.default_binary(),
                self.id()
            )
        })?;

        path_cache.insert(self.id(), path.clone());
        Ok(path)
    }
}

/// Create a boxed [`LanguageServer`] from its Zed language-server ID.
pub fn from_id(id: &str) -> Result<Box<dyn LanguageServer>> {
    match id {
        "mlir-lsp-server" => Ok(Box::new(MlirServer)),
        "mlir-pdll-lsp-server" => Ok(Box::new(PdllServer)),
        "tblgen-lsp-server" => Ok(Box::new(TablegenServer)),
        other => Err(format!("unknown language server id: {other}")),
    }
}
