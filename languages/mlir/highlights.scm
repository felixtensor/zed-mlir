;; ---------------------------------------------------------------------------
;; Dialect-agnostic MLIR syntax highlighting
;; ---------------------------------------------------------------------------

;; Comments
(comment) @comment

;; Keywords and Operation names
(func_operation name: _ @function.builtin)
(func_operation ["private" "public"] @attribute)
(func_operation "attributes" @attribute)
(module_operation name: _ @function.builtin)
(module_operation "attributes" @attribute)

(custom_op_name) @function.builtin
(generic_operation (string_literal) @function.builtin)

;; Types
(builtin_type) @type.builtin

;; Two-tone highlighting inside composite types (tensor, memref, vector):
(dimension_size) @number

;; Element types inside dim_list / vector_dim_list are named nodes — their
;; capture is deeper than (dim_list)/@number so they win for their own span.
[
  (float_type)
  (integer_type)
  (index_type)
  (none_type)
] @type.builtin

[
  (type_alias)
  (dialect_type)
  (type_alias_def)
] @type

;; Numeric and Bool literals
[
  (integer_literal)
  (float_literal)
  (complex_literal)
] @number

(bool_literal) @boolean

;; Attributes and other constants
[
  (tensor_literal)
  (dense_resource_literal)
  (array_literal)
  (unit_literal)
  (uninitialized_literal)
] @constant.builtin

;; Handle name inside dense_resource<...> overrides the bare_id @keyword catch-all
(dense_resource_literal (bare_id) @constant.builtin)

[
  (attribute_alias)
  (attribute_alias_def)
  (dialect_attribute)
] @attribute

(dictionary_attribute) @attribute

;; Builtin attribute and affine keywords
(affine_map "affine_map" @keyword)
(affine_set "affine_set" @keyword)
(strided_layout "strided" @keyword)
(strided_layout "offset" @keyword)
["ceildiv" "floordiv" "mod"] @operator

;; Trailing location
(trailing_location "loc" @keyword)

;; Strings
(string_literal) @string

;; Functions and symbols
;; func.func @name  →  @string.special.symbol  (function definition name)
;; module @name     →  @module                 (module definition name)
;; @any_other_sym   →  @string.special.symbol  (symbol reference)
(func_operation sym_name: (symbol_ref_id) @string.special.symbol)
(module_operation sym_name: (symbol_ref_id) @module)
(symbol_ref_id) @string.special.symbol

;; SSA values — @variable.special gives a distinct color
(value_use) @variable.special
(func_arg_list (value_use) @variable.special)
(block_arg_list (value_use) @variable.special)
(op_result) @variable.special

;; Fallback keyword for ad-hoc tokens like `to`, `step`, `ins`, etc.
(bare_id) @keyword

;; Brackets
[
  "("
  ")"
  "{"
  "}"
  "["
  "]"
  "<"
  ">"
] @punctuation.bracket

;; Delimiters
[
  ":"
  ","
] @punctuation.delimiter

;; Variadic
(variadic) @punctuation.special

;; Operators
[
  "="
  "->"
] @operator

;; Block labels
(caret_id) @label
