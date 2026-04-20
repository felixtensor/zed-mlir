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

;; Built-in type constraints
(type_constraint
  ["Op" "Attr" "Type" "Value" "ValueRange" "TypeRange"] @type.builtin)

;; op<...> / attr<"..."> / type<"..."> expression keywords
(op_expr "op" @keyword)
(attr_expr "attr" @keyword)
(type_expr "type" @keyword)

;; Op name inside op<ns.name> and string forms
(op_expr "<" (identifier) @constant ">")
(op_expr "<" (string) @constant ">")

;; Declaration names
(pattern_decl . (identifier) @function)
(rewrite_decl . (identifier) @function)
(constraint_decl . (identifier) @type)

;; Variable definition: name : Type
(variable_def (identifier) @variable)

;; Function-style invocation of user Constraint / Rewrite
(call_expr (identifier) @variable)

;; Fallback: bare identifier in expression position
(identifier) @variable

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
