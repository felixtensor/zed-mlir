mod server;

use std::collections::HashMap;

use zed_extension_api::{self as zed, LanguageServerId, Result, Worktree};

struct MlirSuiteExtension {
    path_cache: HashMap<&'static str, String>,
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
        worktree: &Worktree,
    ) -> Result<zed::Command> {
        let server = server::from_id(id.as_ref())?;
        server.resolve_command(worktree, &mut self.path_cache)
    }
}

zed::register_extension!(MlirSuiteExtension);
