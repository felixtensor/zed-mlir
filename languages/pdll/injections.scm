;; ---------------------------------------------------------------------------
;; PDLL language injections
;;
;; PDLL's native `[{ ... }]` blocks inside Constraint / Rewrite declarations
;; carry C++ source that mlir-pdll emits verbatim, so their highlighting is
;; delegated to the C++ grammar. Editors should provide tree-sitter-cpp as a
;; sibling parser.
;;
;; Non-native `[{ ... }]` string blocks (`#include`, `attr<...>`, `type<...>`,
;; attribute keys) emit `string_block` without `code_block_content`, and
;; double-quoted native bodies emit `string`, so neither is injected as C++.
;; ---------------------------------------------------------------------------

;; Inject only the inner `code_block_content` node so the `[{` and `}]`
;; delimiters stay under PDLL highlighting.
((code_block
  content: (code_block_content) @injection.content)
  (#set! injection.language "cpp"))
