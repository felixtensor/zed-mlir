;; ---------------------------------------------------------------------------
;; Dialect-agnostic MLIR syntax highlighting
;; ---------------------------------------------------------------------------

;; Tier 1: Structural operation names (func, module)
(func_operation name: _ @keyword)
(module_operation name: _ @keyword)

;; Tier 2: Generic custom operation names (dialect.op_name)
(custom_op_name) @function.builtin

;; Tier 3: Generic operations ("string.op"(...) : type)
(generic_operation) @function

;; Function and module symbol names
(func_operation sym_name: (symbol_ref_id) @function)
(module_operation sym_name: (symbol_ref_id) @module)

;; Types
(builtin_type) @type.builtin

[
  (type_alias)
  (dialect_type)
  (type_alias_def)
] @type

;; Numeric literals
[
  (integer_literal)
  (float_literal)
  (complex_literal)
] @number

;; Constant literals
[
  (bool_literal)
  (tensor_literal)
  (array_literal)
  (unit_literal)
] @constant.builtin

(string_literal) @string

;; Attributes
[
  (attribute_alias_def)
  (attribute_alias)
  (dictionary_attribute)
] @attribute

;; Brackets
[
  "("
  ")"
  "{"
  "}"
  "["
  "]"
] @punctuation.bracket

;; Delimiters
[
  ":"
  ","
] @punctuation.delimiter

;; Operators
[
  "="
  "->"
] @operator

;; Block labels
(caret_id) @tag

;; Variables
(value_use) @variable
(func_arg_list (value_use) @variable.parameter)
(block_arg_list (value_use) @variable.parameter)

;; Comments
(comment) @comment
