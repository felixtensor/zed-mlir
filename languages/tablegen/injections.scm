;; Inject tree-sitter-cpp into TableGen code blocks — but ONLY when the
;; enclosing field is unambiguously C++ code, not arbitrary text.
;; Editors should provide tree-sitter-cpp as a sibling parser.

;; Case 1: field declared with `code` type — always C++.
;;   code extraClassDeclaration = [{ ... }];
(field_declaration
  (type) @_type
  (code_literal (code_chunk) @injection.content)
  (#eq? @_type "code")
  (#set! injection.language "cpp")
  (#set! injection.combined))

;; Case 2: field declaration (any type) whose name is a known C++-carrying
;; ODS key.
;;   string builders = [{ ... }];
(field_declaration
  (identifier) @_name
  (code_literal (code_chunk) @injection.content)
  (#match? @_name "^(extraClassDeclaration|extraClassDefinition|extraTraitClassDeclaration|extraSharedClassDeclaration|builders|verify)$")
  (#set! injection.language "cpp")
  (#set! injection.combined))

;; Case 3: standalone let-assignment with a known C++-carrying ODS key.
;;   let builders = [{ ... }];
(let_assignment
  (identifier) @_name
  (code_literal (code_chunk) @injection.content)
  (#match? @_name "^(extraClassDeclaration|extraClassDefinition|extraTraitClassDeclaration|extraSharedClassDeclaration|builders|verify)$")
  (#set! injection.language "cpp")
  (#set! injection.combined))

;; Case 4: let-item inside a comma-separated `let ... in { }` block.
;;   let builders = [{ ... }],
;;       verify = [{ ... }] in { ... }
(let_item
  (identifier) @_name
  (code_literal (code_chunk) @injection.content)
  (#match? @_name "^(extraClassDeclaration|extraClassDefinition|extraTraitClassDeclaration|extraSharedClassDeclaration|builders|verify)$")
  (#set! injection.language "cpp")
  (#set! injection.combined))
