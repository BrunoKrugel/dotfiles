; extends

(return_statement
  (expression_list
    "," @_start .
    (_) @parameter.inner
  (#make-range! "parameter.outer" @_start @parameter.inner))
)

(return_statement
  (expression_list
    . (_) @parameter.inner
    . ","? @_end
   (#make-range! "parameter.outer" @parameter.inner @_end))
)


; extends

(literal_element) @parameter.inner

(keyed_element) @parameter.inner

(literal_element) @parameter.outer

(keyed_element) @parameter.outer

(literal_element) @keyed_element

(if_statement
  condition: (_)  @parameter.inner)

(expression_list) @expression_list

(call_expression) @call_expression

; extends

;; inner function textobject
(function_declaration
  body: (block . "{" . (_) @_start @_end (_)? @_end . "}"
 (#make-range! "function.inner" @_start @_end)))

;; inner function literals
(func_literal
  body: (block . "{" . (_) @_start @_end (_)? @_end . "}"
 (#make-range! "function.inner" @_start @_end)))

;; method as inner function textobject
(method_declaration
  body: (block . "{" . (_) @_start @_end (_)? @_end . "}"
 (#make-range! "function.inner" @_start @_end)))

;; outer function textobject
(function_declaration) @function.outer

;; outer function literals
(func_literal (_)?) @function.outer

;; method as outer function textobject
(method_declaration body: (block)?) @function.outer


;; struct and interface declaration as class textobject?
(type_declaration
    (type_spec (type_identifier) (struct_type (field_declaration_list (_)?) @class.inner))) @class.outer

(type_declaration
  (type_spec (type_identifier) (interface_type) @class.inner)) @class.outer

;; struct literals as class textobject
(composite_literal
  (type_identifier)?
  (struct_type (_))?
  (literal_value (_)) @class.inner) @class.outer

;; conditionals
(if_statement
  alternative: (_ (_) @conditional.inner)?) @conditional.outer

(if_statement
  consequence: (block)? @conditional.inner)

(if_statement
  condition: (_) @conditional.inner)

;; loops
(for_statement
  body: (block)? @loop.inner) @loop.outer

;; blocks
(_ (block) @block.inner) @block.outer

;; statements
(block (_) @statement.outer)

;; comments
(comment) @comment.outer

;; calls
(call_expression) @call.outer
(call_expression
  arguments: (argument_list . "(" . (_) @_start (_)? @_end . ")"
  (#make-range! "call.inner" @_start @_end)))

;; parameters
(parameter_list
  "," @_start .
  (parameter_declaration) @parameter.inner
 (#make-range! "parameter.outer" @_start @parameter.inner))
(parameter_list
  . (parameter_declaration) @parameter.inner
  . ","? @_end
 (#make-range! "parameter.outer" @parameter.inner @_end))

(parameter_declaration
  (identifier)
  (identifier) @parameter.inner)

(parameter_declaration
  (identifier) @parameter.inner
  (identifier))

(parameter_list
  "," @_start .
  (variadic_parameter_declaration) @parameter.inner
 (#make-range! "parameter.outer" @_start @parameter.inner))

;; arguments
(argument_list
  "," @_start .
  (_) @parameter.inner
 (#make-range! "parameter.outer" @_start @parameter.inner))
(argument_list
  . (_) @parameter.inner
  . ","? @_end
 (#make-range! "parameter.outer" @parameter.inner @_end))

;; ===== CUSTOM =====

(function_declaration
  body: (block)? @function.inside) @function.around

(func_literal
  (_)? @function.inside) @function.around

(method_declaration
  body: (block)? @function.inside) @function.around

;; struct and interface declaration as class textobject?
(type_declaration
  (type_spec (type_identifier) (struct_type (field_declaration_list (_)?) @class.inside))) @class.around

(type_declaration
  (type_spec (type_identifier) (interface_type (method_spec)+ @class.inside))) @class.around

(parameter_list
  (_) @parameter.inside)

(argument_list
  (_) @parameter.inside)

(comment) @comment.inside

(comment)+ @comment.around
