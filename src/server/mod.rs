use std::collections::HashMap;

use zed_extension_api::{self as zed, settings::LspSettings, Result, Worktree};

mod mlir;
mod pdll;
mod tablegen;

pub use mlir::MlirServer;
pub use pdll::PdllServer;
pub use tablegen::TablegenServer;

/// Candidate paths to probe for compilation-database files, relative to the
/// worktree root. Listed from most-specific to least-specific.
const BUILD_DIR_CANDIDATES: &[&str] = &["build"];

/// Trait defining the interface for a language server integration.
///
/// The default implementation of [`resolve_command`](LanguageServer::resolve_command)
/// handles the common boilerplate:
/// - reading per-worktree `LspSettings` from Zed's `settings.json`
/// - resolving the server binary from a user-provided path, cache, or `$PATH`
/// - assembling the final `zed::Command` with arguments and environment variables
/// - auto-detecting compilation-database files when the server declares candidates.
pub trait LanguageServer {
    /// The language-server ID used in `extension.toml` and `settings.json`.
    fn id(&self) -> &'static str;

    /// The default binary name looked up on `$PATH`.
    fn default_binary(&self) -> &'static str;

    /// The CLI flag prefix for the compilation database, *without* the `=`.
    ///
    /// Return `None` (the default) if this server does not support a
    /// compilation database flag.
    fn compilation_db_flag(&self) -> Option<&'static str> {
        None
    }

    /// The filename of the compilation-database file this server expects
    /// (e.g. `"tablegen_compile_commands.yml"`).
    ///
    /// The default `resolve_command` will probe
    /// `<build_dir>/<filename>` for each directory in
    /// [`BUILD_DIR_CANDIDATES`].
    fn compilation_db_filename(&self) -> Option<&'static str> {
        None
    }

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

        let mut args = user_binary
            .as_ref()
            .and_then(|b| b.arguments.clone())
            .unwrap_or_default();

        // Auto-detect compilation database if the server supports it and the
        // user hasn't already supplied the flag.
        if let (Some(flag), Some(filename)) =
            (self.compilation_db_flag(), self.compilation_db_filename())
        {
            let already_set = args.iter().any(|a| a.starts_with(flag));
            if !already_set {
                if let Some(db_path) = detect_compilation_db(worktree, filename) {
                    args.push(format!("{flag}={db_path}"));
                }
            }
        }

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

/// Probe [`BUILD_DIR_CANDIDATES`] for a compilation-database file and return
/// its absolute path if found.
fn detect_compilation_db(worktree: &Worktree, filename: &str) -> Option<String> {
    let root = worktree.root_path();
    for dir in BUILD_DIR_CANDIDATES {
        let relative = format!("{dir}/{filename}");
        // `read_text_file` succeeds only when the file exists and is readable.
        if worktree.read_text_file(&relative).is_ok() {
            return Some(format!("{root}/{relative}"));
        }
    }
    None
}
