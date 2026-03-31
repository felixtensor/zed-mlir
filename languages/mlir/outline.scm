;; ---------------------------------------------------------------------------
;; MLIR outline (symbol navigation)
;; ---------------------------------------------------------------------------

;; Functions: func.func @my_func(...)
(func_operation
  name: _ @context
  sym_name: (symbol_ref_id) @name) @item

;; Named modules: module @my_module { ... }
(module_operation
  name: _ @context
  sym_name: (symbol_ref_id) @name) @item

;; Unnamed modules: module attributes { ... }
(module_operation
  name: _ @name
  !sym_name) @item

;; Block labels: ^bb0(%arg0: i64):
(block
  (block_label
    (caret_id) @name)) @item
