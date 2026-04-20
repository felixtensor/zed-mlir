;; ---------------------------------------------------------------------------
;; PDLL syntax highlighting
;; Scope choices follow the upstream TextMate grammar
;; (tmp/pdll-grammar.json), mapped to Zed's documented highlight captures.
;; ---------------------------------------------------------------------------

;; Comments
(comment) @comment

;; Strings and embedded C++ code block (`[{ ... }]`)
(string) @string
(code_block) @string.special

;; Numbers
(integer) @number

;; Include directive
(include_directive "#include" @keyword)

;; Top-level declaration keywords
[
  "Pattern"
  "Constraint"
  "Rewrite"
] @keyword

;; Statement / control keywords
[
  "let"
  "erase"
  "replace"
  "rewrite"
  "return"
  "with"
  "not"
] @keyword

;; Pattern metadata (Pattern Foo with benefit(1), recursion { ... })
(benefit_metadata "benefit" @variable)
(recursion_metadata) @variable

;; op<...> / attr<"..."> / type<"..."> expression keywords
(op_expr "op" @keyword)
(attr_expr "attr" @keyword)
(type_expr "type" @keyword)

;; Identifier defaults — keep this BEFORE the specific identifier rules below.
;; Zed's tree-sitter highlighter uses last-match-wins: any later capture for
;; the same identifier node overrides this fallback.
(identifier) @variable
(variable_def (identifier) @variable)
(call_expr (identifier) @variable)

;; Built-in type constraints
(type_constraint
  ["Op" "Attr" "Type" "Value" "ValueRange" "TypeRange"] @type.builtin)

;; Declaration names
(pattern_decl . (identifier) @function)
(rewrite_decl . (identifier) @function)
(constraint_decl . (identifier) @type)

;; Op name inside op<ns.name> and string forms
(op_expr "<" (identifier) @constant ">")
(op_expr "<" (string) @constant ">")

;; Inner name of built-in type constraints:
;;   Op<my.dialect>, Op<"my.dialect">  — direct identifier/string child
;;   Attr<x>, Type<x>, Value<x>, ValueRange<x>, TypeRange<x>
;;     — wrapped in an inner type_constraint by the grammar
(type_constraint "<" (identifier) @constant ">")
(type_constraint "<" (string) @constant ">")
(type_constraint "<" (type_constraint (identifier) @constant) ">")

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
  ";"
] @punctuation.delimiter

;; Operators
[
  "="
  "=>"
  "->"
  "."
] @operator
