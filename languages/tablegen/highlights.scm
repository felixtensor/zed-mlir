;; Comments
(line_comment) @comment
(block_comment) @comment

;; Preprocessor
"#define"  @keyword.directive
"#ifdef"   @keyword.directive
"#ifndef"  @keyword.directive
"#else"    @keyword.directive
"#endif"   @keyword.directive
(macro_name) @constant.macro

"include" @keyword.import

;; Keywords
[
  "assert"
  "class"
  "multiclass"
  "field"
  "let"
  "def"
  "defm"
  "defset"
  "deftype"
  "defvar"
  "dump"
  "foreach"
  "if"
  "else"
  "then"
  "in"
] @keyword

(let_mode) @keyword.modifier

;; Identifier fallback — keep BEFORE the specific identifier rules below.
;; Zed's tree-sitter highlighter uses last-match-wins: later captures for the
;; same identifier node override this fallback.
(identifier) @variable

;; Variable substitution (`$foo` / `$0` inside code_literal, `$bare` in DAG)
;; These are single-token nodes in the grammar, matching VS Code's `(\$\w+)\b`.
(variable_substitution) @variable.special
(variable_name) @variable.special

;; Template parameters
(template_parameter (identifier) @variable.parameter)

;; Foreach iteration variable — the first identifier child before `=`
(foreach_statement (identifier) @variable.parameter)

;; Member access: `Foo.bar`
(value_suffix_dot (identifier) @variable.member)

;; Field declarations
(field_declaration (identifier) @property)

;; Named arguments
(named_argument (identifier) @field)

;; Let / defvar bindings — variable-like definitions, not member access
(let_assignment (identifier) @variable)
(let_item (identifier) @variable)
(defvar_statement (identifier) @variable)

;; Types
(type) @type

[
  "bit"
  "bits"
  "int"
  "string"
  "dag"
  "code"
  "list"
] @type.builtin

;; Definition names — parser-aligned highlight groups
(class_definition (identifier) @type.definition)
(def_definition (identifier) @constant)
(multiclass_definition (identifier) @function.macro)
(defm_definition (identifier) @type)
(defset_definition (identifier) @type)
(deftype_definition (identifier) @type)

;; Parent class references
(parent_class (identifier) @type)

;; Anonymous records
(anonymous_record (identifier) @type)

;; UPPER_CASE identifiers as types
((identifier) @type
  (#match? @type "^_*[A-Z][A-Z0-9_]+$"))

;; Bang operators / built-in functions
(bang_operator) @function.builtin
"!cond" @function.builtin

;; Operators
[
  "="
  "#"
  "-"
  "..."
] @operator

;; Punctuation
[ "{" "}" "[" "]" "(" ")" "<" ">" ] @punctuation.bracket

[
  "."
  ","
  ";"
  ":"
] @punctuation.delimiter

;; Literals
(string_literal) @string
(escape_sequence) @string.escape
(code_chunk) @string
(integer_literal) @number
(boolean_literal) @boolean
(unset_value) @constant.builtin

;; ─── MLIR dialect-flavor predicates ─────────────────────────────────────────
;; (Per spec §2.1: dialect identification is queries-side, not grammar-side.)

;; Common MLIR ODS base classes
(parent_class (identifier) @type.builtin
  (#match? @type.builtin "^(Op|Pattern|Pat|Intrinsic|Attr|AttrDef|TypeDef|Dialect|Interface|OpInterface|AttrInterface|TypeInterface|Constraint|Pred|Property)$"))

;; ODS def names that follow the "Op" / "Type" / "Attr" suffix convention
(def_definition (identifier) @type
  (#match? @type "Op$|Type$|Attr$"))

;; Common ODS field names
(field_declaration (identifier) @property.special
  (#match? @property.special "^(arguments|results|regions|successors|summary|description|hasVerifier|hasCanonicalizer|hasCanonicalizeMethod|assemblyFormat|extraClassDeclaration|builders|hasFolder)$"))

;; Errors
(ERROR) @error
