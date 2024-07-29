; ;; extends
; ;; Keywords
; (("return"   @keyword) (#set! conceal "󰌑"))
; (("var"      @keyword) (#set! conceal  "ν"))
; (("if"       @keyword) (#set! conceal "? "))
; (("else"     @keyword) (#set! conceal "! "))
; (("func"     @keyword) (#set! conceal ""))
; (("for"      @keyword) (#set! conceal ""))
; (("switch"   @keyword) (#set! conceal "🎮"))
; (("default"  @keyword) (#set! conceal  ""))
; (("break"    @keyword.return) (#set! conceal  "⏹️"))
; (("case"     @keyword) (#set! conceal  ""))
; (("import"   @keyword) (#set! conceal  ""))
; (("package"  @keyword) (#set! conceal  ""))
; (("range"    @keyword) (#set! conceal ""))
; (("chan"     @keyword) (#set! conceal ""))
; (("continue" @keyword) (#set! conceal "↙"))
; (("struct"   @keyword) (#set! conceal ""))
; (("type"     @keyword) (#set! conceal ""))
; (("interface"       @keyword) (#set! conceal ""))
; (("*"       @keyword) (#set! conceal "✳️"))
;
; ;; Function names
; ((call_expression function: (identifier) @function (#eq? @function "append"  )) (#set! conceal "匿"))  ;; 
;
; ;; type
; (((type_identifier) @type (#eq? @type "string")) (#set! conceal ""))
; (((type_identifier) @type (#eq? @type "error")) (#set! conceal ""))
; (((type_identifier) @type (#eq? @type "int")) (#set! conceal "כֿ"))
; (((type_identifier) @type (#eq? @type "byte")) (#set! conceal ""))
; (((nil) @type (#set! conceal "ﳠ")))
; (((true) @type (#set! conceal "")))
; ;; fmt.*
; (((selector_expression) @error (#eq? @error "fmt.Println"     )) (#set! conceal ""))
; (((selector_expression) @error (#eq? @error "fmt.Printf"     )) (#set! conceal "狼"))
; (((selector_expression) @field (#eq? @field "fmt.Sprintf"     )) (#set! conceal ""))
; ;; type
; (((qualified_type) @type (#eq? @type "testing.T")) (#set! conceal "τ"))
; (((pointer_type) @type (#eq? @type "*testing.T")) (#set! conceal "τ"))
; ;; identifiers
; (((identifier) @type (#eq? @type "err"     )) (#set! conceal "ε"))
; (((identifier) @type (#eq? @type "errors"     )) (#set! conceal "é"))
; (((identifier) @type (#eq? @type "request"     )) (#set! conceal "黎"))
; (((identifier) @type (#eq? @type "Request"     )) (#set! conceal "黎"))
; (((identifier) @type (#eq? @type "response"     )) (#set! conceal ""))
; (((identifier) @type (#eq? @type "Response"     )) (#set! conceal ""))
; (((identifier) @field (#eq? @field "Errorf"     )) (#set! conceal "🥹"))
; (((identifier) @field (#eq? @field "assert"     )) (#set! conceal "🅰️"))
; (((field_identifier) @field (#eq? @field "Error"     )) (#set! conceal "E"))
; (((field_identifier) @field (#eq? @field "Equal"     )) (#set! conceal "🟰"))
; (((identifier) @field (#eq? @field "fmt"     )) (#set! conceal ""))
; extends

; Forked from tree-sitter-go
; Copyright (c) 2014 Max Brunsfeld (The MIT License)
;
; Identifiers
(type_identifier) @type

(type_spec
  name: (type_identifier) @type.definition)

(field_identifier) @property

(identifier) @variable

(package_identifier) @namespace

(parameter_declaration
  (identifier) @parameter)

(variadic_parameter_declaration
  (identifier) @parameter)

(label_name) @label

((identifier) @constant
  (#eq? @constant "_"))

(const_spec
  name: (identifier) @constant)

; Function calls
(call_expression
  function: (identifier) @function.call)

(call_expression
  function: (selector_expression
    field: (field_identifier) @method.call))

; Function definitions
(function_declaration
  name: (identifier) @function)

(method_declaration
  name: (field_identifier) @method)

(method_spec
  name: (field_identifier) @method)

; Operators
[
  "--"
  "-"
  "-="
  ":="
  "!"
  "!="
  "..."
  "*"
  "*"
  "*="
  "/"
  "/="
  "&"
  "&&"
  "&="
  "%"
  "%="
  "^"
  "^="
  "+"
  "++"
  "+="
  "<-"
  "<"
  "<<"
  "<<="
  "<="
  "="
  "=="
  ">"
  ">="
  ">>"
  ">>="
  "|"
  "|="
  "||"
  "~"
] @operator

; Keywords
[
  "break"
  "chan"
  "const"
  "continue"
  "default"
  "defer"
  "go"
  "goto"
  "interface"
  "map"
  "range"
  "select"
  "struct"
  "type"
  "var"
  "fallthrough"
] @keyword

"func" @keyword.function

"return" @keyword.return

"for" @repeat

[
  "import"
  "package"
] @include

[
  "else"
  "case"
  "switch"
  "if"
] @conditional

; Builtin types
((type_identifier) @type.builtin
  (#any-of? @type.builtin
    "any" "bool" "byte" "complex128" "complex64" "error" "float32" "float64" "int" "int16" "int32"
    "int64" "int8" "rune" "string" "uint" "uint16" "uint32" "uint64" "uint8" "uintptr"))

; Builtin functions
((identifier) @function.builtin
  (#any-of? @function.builtin
    "append" "cap" "close" "complex" "copy" "delete" "imag" "len" "make" "new" "panic" "print"
    "println" "real" "recover"))

; Delimiters
"." @punctuation.delimiter

"," @punctuation.delimiter

":" @punctuation.delimiter

";" @punctuation.delimiter

"(" @punctuation.bracket

")" @punctuation.bracket

"{" @punctuation.bracket

"}" @punctuation.bracket

"[" @punctuation.bracket

"]" @punctuation.bracket

; Literals
(interpreted_string_literal) @string

(raw_string_literal) @string @spell

(rune_literal) @string

(escape_sequence) @string.escape

(int_literal) @number

(float_literal) @float

(imaginary_literal) @number

[
  (true)
  (false)
] @boolean

(nil) @constant.builtin

(keyed_element
  .
  (literal_element
    (identifier) @field))

(field_declaration
  name: (field_identifier) @field)

; Comments
(comment) @comment @spell

; Doc Comments
(source_file
  .
  (comment)+ @comment.documentation)

(source_file
  (comment)+ @comment.documentation
  .
  (const_declaration))

(source_file
  (comment)+ @comment.documentation
  .
  (function_declaration))

(source_file
  (comment)+ @comment.documentation
  .
  (type_declaration))

(source_file
  (comment)+ @comment.documentation
  .
  (var_declaration))

; Errors
(ERROR) @error

; Spell
((interpreted_string_literal) @spell
  (#not-has-parent? @spell import_spec))

; ===== CUSTOM =====
(function_declaration
  (identifier) @function_definition)
