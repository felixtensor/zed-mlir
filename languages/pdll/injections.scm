;; ---------------------------------------------------------------------------
;; PDLL language injections
;; ---------------------------------------------------------------------------
;;
;; PDLL's `[{ ... }]` blocks inside Constraint / Rewrite / native expressions
;; carry C++ source code that gets emitted verbatim by mlir-tblgen. Delegate
;; their highlighting to the C++ tree-sitter grammar.
;;
;; C++ code inside PDLL `[{ ... }]` blocks (Constraint / Rewrite bodies).
;; Inject only the `code_block_content` inner node so the `[{` / `}]`
;; delimiters remain under PDLL highlighting.

((code_block
  (code_block_content) @injection.content)
  (#set! injection.language "cpp"))
