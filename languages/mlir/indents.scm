;; ---------------------------------------------------------------------------
;; MLIR indentation rules
;; ---------------------------------------------------------------------------

;; Regions are the primary indentation construct in MLIR (function bodies,
;; control-flow bodies, module bodies, etc.)
(region "}" @end) @indent

;; Parenthesised and bracketed groups
(_ "(" ")" @end) @indent
(_ "[" "]" @end) @indent
