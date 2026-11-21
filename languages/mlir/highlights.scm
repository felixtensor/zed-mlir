;; ---------------------------------------------------------------------------
;; MLIR syntax highlighting (dialect-agnostic)
;;
;; Zed's tree-sitter highlighter uses last-match-wins: when two rules overlap,
;; the one that appears later in the file wins. Keep specialized rules (e.g.
;; quoted symbol refs, dictionary keys, and custom_body_arrow) AFTER the
;; generic literal or punctuation rules they override.
;; ---------------------------------------------------------------------------

;; Comments
(comment) @comment

;; Keywords and operation names
(func_operation name: _ @function)
(func_operation visibility: _ @keyword)
(func_operation specifier: (function_specifier) @keyword)
(func_operation "attributes" @attribute)
;; llvm.func post-signature clause introducers.
(vscale_range "vscale_range" @keyword)
(comdat "comdat" @keyword)
(module_operation name: _ @function)
(module_operation "attributes" @attribute)

(custom_op_name) @function

(custom_operation ["array" "sparse" "tensor" "vector"] @keyword)
(custom_operation ["+" "-" "*" "/" "&" "|" "~"] @operator)
(custom_operation "?" @punctuation.special)
(custom_operation "loc" @keyword)
(custom_operation "module" @keyword)

;; Types
;; Two-tone highlighting inside composite types (tensor, memref, vector).
(dimension_size) @number

;; Element types inside dim_list / vector_dim_list are named nodes — their
;; capture is deeper than (dim_list)/@number so they win for their own span.
[
  (float_type)
  (integer_type)
  (index_type)
  (none_type)
  (token_type)
] @type.builtin

;; Composite builtin types (including nested types reached through _prim_type).
[
  (complex_type)
  (memref_type)
  (tensor_type)
  (vector_type)
  (tuple_type)
  (opaque_type)
] @type.builtin

;; 'x' separator inside dimension lists — render as delimiter rather than
;; inheriting @type.builtin from the (memref_type)/(tensor_type)/(vector_type)
;; block above. Must appear AFTER that block under last-match-wins.
;; @cap binds to the "x" literal (parent-internal anonymous token); placing
;; it outside an alternation would capture the parent node instead.
(dim_list "x" @punctuation.delimiter)
(dimension_separator) @punctuation.delimiter
(vector_dim_list "x" @punctuation.delimiter)
(dim_list ["?" "*"] @punctuation.special)
(dialect_dim_list ["?" "*"] @punctuation.special)
(custom_body_dim_list "?" @punctuation.special)

[
  (type_alias)
  (type_alias_def)
  (dialect_type)
] @type

;; Numeric and boolean literals
[
  (integer_literal)
  (float_literal)
  (complex_literal)
] @number

(bool_literal) @boolean

;; Attributes and other constants
[
  (unit_literal)
  (uninitialized_literal)
] @constant.builtin

;; Builtin attribute/literal introducers that take a <payload> (dense, sparse,
;; array, affine_map, affine_set, strided, distinct, dense_resource) are
;; @constant.builtin — the Zed translation of the VSCode grammar's
;; constant.language anchor, distinct from numeric payloads, enclosing
;; literal/attribute channels, and general syntax or clause/field keywords
;; (loc, offset, vscale_range, comdat). Zed's official capture list has no
;; @constructor.builtin, @constructor renders identical to @function in One
;; Dark (op names), and @property stays reserved for key-side channels, so
;; upstream's finer @constructor.builtin split deliberately flattens here.
(tensor_literal ["dense" "sparse"] @constant.builtin)
(array_literal "array" @constant.builtin)

[
  (attribute_alias)
  (attribute_alias_def)
  (builtin_attribute)
  (dialect_attribute)
  (dictionary_attribute)
] @attribute

;; Builtin attribute and affine keywords
(affine_map "affine_map" @constant.builtin)
(affine_set "affine_set" @constant.builtin)
[
  (affine_map (bare_id) @variable.parameter)
  (affine_map_inline (bare_id) @variable.parameter)
  (affine_set (bare_id) @variable.parameter)
]
[
  (affine_map ["symbol" "max" "min"] @keyword)
  (affine_map_inline ["symbol" "max" "min"] @keyword)
  (affine_set ["symbol" "max" "min"] @keyword)
]
[
  (affine_map
    ["dense" "sparse" "compressed" "singleton" "loose_compressed" "n_out_of_m"]
    @keyword)
  (affine_map_inline
    ["dense" "sparse" "compressed" "singleton" "loose_compressed" "n_out_of_m"]
    @keyword)
  (affine_set
    ["dense" "sparse" "compressed" "singleton" "loose_compressed" "n_out_of_m"]
    @keyword)
]
[
  (affine_map ["+" "-" "*" "==" ">=" "<="] @operator)
  (affine_map_inline ["+" "-" "*" "==" ">=" "<="] @operator)
  (affine_set ["+" "-" "*" "==" ">=" "<="] @operator)
]
(strided_layout "strided" @constant.builtin)
(strided_layout "offset" @keyword)
(strided_layout ["?" "*"] @punctuation.special)
(distinct_attribute "distinct" @constant.builtin)
(dense_resource_literal "dense_resource" @constant.builtin)

[
  "ceildiv"
  "floordiv"
  "mod"
] @operator

[
  (pretty_dialect_item_body
    ["array" "dense" "memref" "opaque" "sparse" "tensor" "tuple" "vector"]
    @keyword)
  (dialect_dim_list
    ["array" "memref" "tuple" "vector"] @keyword)
]
[
  (pretty_dialect_item_body (bare_id) @keyword)
  (dialect_dim_list (bare_id) @keyword)
]
(pretty_dialect_item_body ["?" "*" "@" "#"] @punctuation.special)
(pretty_dialect_item_body "." @punctuation.delimiter)

;; Locations
(trailing_location "loc" @keyword)
(callsite_location ["callsite" "at"] @keyword)
(fused_location "fused" @keyword)
(location "to" @keyword)
(unknown_location) @constant.builtin

;; Symbols (@name) — all symbol references share one capture.
(symbol_ref_id) @string.special.symbol

;; Strings
(string_literal) @string
;; Same-node overrides for string_literal in specialized positions.
(generic_operation (string_literal) @function)
(symbol_ref_id (string_literal) @string.special.symbol)
(escape_sequence) @string.escape

;; SSA values — @variable.special gives a distinct color. (value_use) covers
;; both arguments and op_result children.
(value_use) @variable.special

;; Fallback keyword for ad-hoc custom operation body tokens like `to`, `step`,
;; `ins`, and `outs`. Keep this scoped so attribute keys, affine dimensions,
;; and pretty dialect payload identifiers do not all become keywords.
(custom_operation (bare_id) @keyword)

;; Dense resource handle: this bare_id is nested inside dense_resource_literal,
;; not a direct custom_operation child, so the catch-all above never matches it.
(dense_resource_literal (bare_id) @constant.builtin)

;; Dictionary attribute keys (e.g. `predicate` in `{predicate = 1}`): placed
;; after `(string_literal) @string` so quoted keys override string highlighting
;; while `array_attribute` elements remain uncolored by this rule.
(attribute_entry key: _ @attribute)

;; External resource block delimiters
(external_resources ["{-#" "#-}"] @punctuation.bracket)

;; Brackets
[
  "("
  ")"
  "["
  "]"
  "{"
  "}"
  "<"
  ">"
] @punctuation.bracket

;; Delimiters
[
  ","
  ":"
] @punctuation.delimiter

;; Variadic / dynamic markers
(variadic) @punctuation.special

;; Operators
[
  "="
  "->"
  "::"
] @operator

;; OpenMP mapped-from arrow `<-` overrides the generic `<` bracket rule above.
(custom_body_arrow ["<" "-"] @operator)

;; Block labels
(caret_id) @label
