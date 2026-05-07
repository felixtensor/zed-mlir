;; Inject tree-sitter-cpp into TableGen code blocks.
;; Editors should provide tree-sitter-cpp as a sibling parser.

((code_chunk) @injection.content
  (#set! injection.language "cpp")
  (#set! injection.combined))
