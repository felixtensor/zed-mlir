;; ---------------------------------------------------------------------------
;; Dialect-agnostic MLIR syntax highlighting
;; ---------------------------------------------------------------------------

;; Comments
(comment) @comment

;; Keywords and Operation names
(func_operation name: _ @keyword)
(func_operation "private" @keyword)
(func_operation "attributes" @keyword)
(module_operation name: _ @keyword)

(custom_op_name) @function.method
(generic_operation (string_literal) @function)

;; Types
(builtin_type) @type.builtin

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
  (array_literal)
  (unit_literal)
  (uninitialized_literal)
] @constant.builtin

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

;; Trailing location
(trailing_location "loc" @keyword)

;; Strings
(string_literal) @string

;; Functions and symbols
(func_operation sym_name: (symbol_ref_id) @function)
(module_operation sym_name: (symbol_ref_id) @string.special.symbol)
(symbol_ref_id) @string.special.symbol

;; Variables
(value_use) @variable.special
(func_arg_list (value_use) @variable.parameter)
(block_arg_list (value_use) @variable.parameter)
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
