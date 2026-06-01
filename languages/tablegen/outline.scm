;; ---------------------------------------------------------------------------
;; TableGen outline (symbol navigation)
;; Anonymous and computed record names are skipped because they do not have a
;; stable, readable label to surface in Zed's outline.
;; ---------------------------------------------------------------------------

(class_definition
  "class" @context
  . (identifier) @name) @item

(def_definition
  "def" @context
  . (identifier) @name) @item

(defm_definition
  "defm" @context
  . (identifier) @name) @item

(multiclass_definition
  "multiclass" @context
  . (identifier) @name) @item

(defset_definition
  "defset" @context
  . (type)
  . (identifier) @name) @item

;; These declarations are most useful at file scope. In-body defvars are
;; implementation details and would add noise to the outline.
(source_file
  (deftype_definition
    "deftype" @context
    . (identifier) @name) @item)

(source_file
  (defvar_statement
    "defvar" @context
    . (identifier) @name) @item)
