;; ---------------------------------------------------------------------------
;; PDLL syntax highlighting
;; ---------------------------------------------------------------------------

;; Comments
(comment) @comment

;; Strings, multi-line string blocks (`[{ ... }]`), and native C++ code blocks
(string) @string
(string_block) @string
(escape_sequence) @string.escape
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
(benefit_metadata "benefit" @keyword)
(recursion_metadata) @keyword

;; op<...> / attr<"..."> / type<"..."> expression keywords
(op_expr "op" @keyword)
(attr_expr "attr" @keyword)
(type_expr "type" @keyword)

;; Identifier fallback — keep BEFORE the specific identifier rules below.
;; Zed's tree-sitter highlighter uses last-match-wins: later captures for the
;; same identifier node override this fallback.
(identifier) @variable

;; Anonymous wildcard placeholder (`_: Op`). Zed's official capture table has
;; no `@variable.builtin`, so `@variable.special` is used here.
((variable_def name: (identifier) @variable.special)
  (#eq? @variable.special "_"))

;; Built-in type constraints
(type_constraint
  ["Op" "Attr" "Type" "Value" "ValueRange" "TypeRange"] @type.builtin)

;; User-defined type constraints in type position; scoped to `name:` so
;; parameterized payloads in `Attr<myType>` / `Value<myType>` stay `@variable`.
(type_constraint
  name: (identifier) @type)

;; Parameter names (includes contextual keywords aliased to identifier)
(argument name: (identifier) @variable.parameter)
(named_type_constraint name: (identifier) @variable.parameter)

;; Operation attribute keys; scoped to `name:` so value expressions stay
;; unaffected, and placed after `(string)` / `(string_block)` so quoted and
;; block keys override string highlighting.
(op_attribute
  name: [(identifier) (string) (string_block)] @attribute)

;; Declaration names
(pattern_decl name: (identifier) @function)
(rewrite_decl name: (identifier) @function)
(constraint_decl name: (identifier) @type)

;; Member access and named tuple elements — aligned with `src/completion.rs`
;; and TableGen. Keep BEFORE member calls below so `t.helper(x)` highlights
;; `helper` as `@function`.
(member_access_expr member: (identifier) @property)
(named_tuple_element name: (identifier) @property)

;; Ordinary, member, and negated calls
(call_expr function: (identifier) @function)
(call_expr function: (member_access_expr member: (identifier) @function))
(negated_call_expr function: (identifier) @function)

;; Op names inside op<ns.name> / Op<ns.name>.
(op_name (identifier) @constant)

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
  ";"
  "."
] @punctuation.delimiter

;; Operators
[
  "="
  "=>"
  "->"
] @operator

;; The `.` in op<ns.name> separates two halves of one name rather than acting
;; as member access, so it takes the surrounding @constant and the dotted name
;; renders as a single unit. Must come AFTER the delimiter list above.
(op_name "." @constant)
