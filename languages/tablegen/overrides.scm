;; ---------------------------------------------------------------------------
;; TableGen scope overrides
;;
;; Line comments use `@comment.inclusive` so the end-of-line position stays
;; inside the comment scope; block comments and strings have explicit closing
;; delimiters and use non-inclusive captures. `[{ ... }]` code literals are
;; intentionally not captured as `@string` (even though `highlights.scm`
;; maps `code_chunk` to `@string`) so quotes and brackets keep their normal
;; editing behavior inside C++ fragments, assembly formats, and descriptions.
;; ---------------------------------------------------------------------------

(line_comment) @comment.inclusive
(block_comment) @comment
(string_literal) @string
