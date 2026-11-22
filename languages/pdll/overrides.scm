;; ---------------------------------------------------------------------------
;; PDLL scope overrides
;;
;; Line comments use `@comment.inclusive` so the end-of-line position stays
;; inside the comment scope. Double-quoted strings use `@string` so typing
;; after the closing quote is outside the string scope. Native `[{ ... }]`
;; `code_block`s (injected as C++) and non-native `[{ ... }]` `string_block`s
;; (e.g. MLIR `attr<[{...}]>` / `type<[{...}]>` payloads that may contain
;; quotes) are intentionally not captured as `@string` so quotes and brackets
;; keep their normal editing behavior inside them.
;; ---------------------------------------------------------------------------

(comment) @comment.inclusive
(string) @string
