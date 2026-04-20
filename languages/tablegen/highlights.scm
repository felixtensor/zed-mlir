;; Preprocessor

(preprocessor_directive) @preproc

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
  "defvar"
] @keyword

"in" @keyword.operator

;; Conditionals

[
  "if"
  "else"
  "then"
] @keyword.control

;; Loops

"foreach" @keyword.control

;; Identifier fallback — keep BEFORE the specific identifier rules below.
;; Zed's tree-sitter highlighter uses last-match-wins: later captures for the
;; same identifier node override this fallback.
(identifier) @variable

(var) @variable.special

;; Template parameters
(template_arg (identifier) @variable.parameter)

;; Member access: `Foo.bar` — the `.bar` identifier in a value_suffix
(value_suffix (identifier) @variable.member)

;; Types

(type) @type

[
  "bit"
  "int"
  "string"
  "dag"
  "bits"
  "list"
  "code"
] @type.builtin

(class name: (identifier) @type)
(multiclass name: (identifier) @type)
(def name: (value (_) @type))
(defm name: (value (_) @type))
(defset name: (identifier) @type)
(parent_class_list (identifier) @type (value (_) @type)?)
(anonymous_record (identifier) @type)
(anonymous_record (value (_) @type))

((identifier) @type
  (#match? @type "^_*[A-Z][A-Z0-9_]+$"))

;; Fields

(instruction (identifier) @variable.member)
(let_instruction (identifier) @variable.member)
(let_item (identifier) @variable.member)

;; Bang operators / built-in functions

[
  (bang_operator)
  (cond_operator)
] @function.builtin

;; Operators

[
  "="
  "#"
  "-"
  ":"
  "..."
] @operator

;; Punctuation

[ "{" "}" ] @punctuation.bracket
[ "[" "]" ] @punctuation.bracket
[ "(" ")" ] @punctuation.bracket
[ "<" ">" ] @punctuation.bracket

[
  "."
  ","
  ";"
] @punctuation.delimiter

"!" @punctuation.special

;; Literals

(string) @string
(code) @string.special
(integer) @number
["true" "false"] @boolean
(uninitialized_value) @constant.builtin

;; Comments

[
  (comment)
  (multiline_comment)
] @comment

;; Errors

(ERROR) @error
