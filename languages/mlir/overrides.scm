;; ---------------------------------------------------------------------------
;; MLIR scope overrides
;;
;; Line comments use `@comment.inclusive` so the end-of-line position stays
;; inside the comment scope. Strings use `@string` so typing after the
;; closing quote is outside the string scope.
;; ---------------------------------------------------------------------------

(comment) @comment.inclusive
(string_literal) @string
