;; ---------------------------------------------------------------------------
;; PDLL scope overrides
;;
;; Line comments use `@comment.inclusive` so the end-of-line position stays
;; inside the comment scope. Strings use `@string` so typing after the
;; closing quote is outside the string scope. Native `[{ ... }]` code blocks
;; are injected as C++ and are not treated as strings.
;; ---------------------------------------------------------------------------

(comment) @comment.inclusive
(string) @string
