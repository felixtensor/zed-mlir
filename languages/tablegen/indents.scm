;; ---------------------------------------------------------------------------
;; TableGen indentation rules
;; ---------------------------------------------------------------------------
;;
;; TableGen's block-like constructs (class / multiclass / def / defset / let /
;; foreach / if bodies) all put the `{ ... }` inside helper nodes such as
;; `body`, `multiclass_body`, `block`, or `statement`. Matching generically on
;; the bracket pair is more robust than enumerating every node shape.

(_ "{" "}" @end) @indent
(_ "[" "]" @end) @indent
(_ "(" ")" @end) @indent
(_ "<" ">" @end) @indent
