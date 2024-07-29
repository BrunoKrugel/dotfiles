; extends

"export" @keyword.export

; inherits: ecma

[
  "declare"
  "enum"
  "export"
  "implements"
  "interface"
  "keyof"
  "type"
  "namespace"
  "override"
  "satisfies"
  "module"
  "infer"
] @keyword

(as_expression
  "as" @keyword)

[
  "abstract"
  "private"
  "protected"
  "public"
  "readonly"
] @type.qualifier

; types
(type_identifier) @type

(predefined_type) @type.builtin

(import_statement
  "type"
  (import_clause
    (named_imports
      (import_specifier
        name: (identifier) @type))))

(template_literal_type) @string

; punctuation
(type_arguments
  [
    "<"
    ">"
  ] @punctuation.bracket)

(type_parameters
  [
    "<"
    ">"
  ] @punctuation.bracket)

(union_type
  "|" @punctuation.delimiter)

(intersection_type
  "&" @punctuation.delimiter)

(type_annotation
  ":" @punctuation.delimiter)

(pair
  ":" @punctuation.delimiter)

(index_signature
  ":" @punctuation.delimiter)

(opting_type_annotation
  "?:" @punctuation.delimiter)

"?." @punctuation.delimiter

(method_signature
  "?" @punctuation.special)

(property_signature
  "?" @punctuation.special)

(optional_parameter
  "?" @punctuation.special)

(template_type
  [
    "${"
    "}"
  ] @punctuation.special)

(conditional_type
  [
    "?"
    ":"
  ] @conditional.ternary)

; Variables
(undefined) @variable.builtin

; Parameters
(required_parameter
  (identifier) @parameter)

(optional_parameter
  (identifier) @parameter)

(required_parameter
  (rest_pattern
    (identifier) @parameter))

; ({ a }) => null
(required_parameter
  (object_pattern
    (shorthand_property_identifier_pattern) @parameter))

; ({ a: b }) => null
(required_parameter
  (object_pattern
    (pair_pattern
      value: (identifier) @parameter)))

; ([ a ]) => null
(required_parameter
  (array_pattern
    (identifier) @parameter))

; a => null
(arrow_function
  parameter: (identifier) @parameter)

; function signatures
(ambient_declaration
  (function_signature
    name: (identifier) @function))

; method signatures
(method_signature
  name: (_) @method)

; property signatures
(property_signature
  name: (property_identifier) @method
  type: (type_annotation
    [
      (union_type
        (parenthesized_type
          (function_type)))
      (function_type)
    ]))

((identifier) @class.builtin.reflection
  (#any-of? @class.builtin.reflection "Reflect" "Proxy"))

; extends

(function
  name: (identifier) @function)

(function_declaration
  name: (identifier) @function.declaration)

(generator_function
  name: (identifier) @function)

(generator_function_declaration
  name: (identifier) @function.declaration)

(method_definition
  name: [
    (property_identifier)
    (private_property_identifier)
  ] @method)

"export" @keyword.export

[
  "const"
  "let"
  "var"
] @keyword.declaration

(class_declaration
  name: (type_identifier) @class)

; Built-in classes
; @see [Global Objects in Mozilla Reference](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects)
; ----------------------------
((identifier) @class.builtin.fundamental
  (#any-of? @class.builtin.fundamental "Object" "Function" "Boolean" "Symbol"))

((identifier) @class.builtin.error
  (#any-of? @class.builtin.error
    "Error" "AggregateError" "EvalError" "InternalError Non-Standard" "RangeError" "ReferenceError"
    "SyntaxError" "TypeError" "URIError"))

((identifier) @class.builtin.number_or_date
  (#any-of? @class.builtin.number_or_date "Number" "BigInt" "Math" "Date"))

((identifier) @class.builtin.text_processing
  (#any-of? @class.builtin.text_processing "String" "RegExp"))

((identifier) @class.builtin.indexed_collection
  (#any-of? @class.builtin.indexed_collection
    "Array" "Int8Array" "Uint8Array" "Uint8ClampedArray" "Int16Array" "Uint16Array" "Int32Array"
    "Uint32Array" "Float32Array" "Float64Array" "BigInt64Array" "BigUint64Array"))

((identifier) @class.builtin.keyed_collection
  (#any-of? @class.builtin.keyed_collection "Map" "Set" "WeakMap" "WeakSet"))

((identifier) @class.builtin.structured_data
  (#any-of? @class.builtin.structured_data
    "ArrayBuffer" "SharedArrayBuffer" "Atomics" "DataView" "JSON"))

((identifier) @class.builtin.control_abstraction
  (#any-of? @class.builtin.control_abstraction
    "Promise" "Generator" "GeneratorFunction" "AsyncFunction"))

; ===== CUSTOM =====
(function_signature
  name: (identifier) @function)

(index_signature
  name: (identifier) @field)

; Change to this an orange highlight group instead of blue
(undefined) @constant.builtin

(override_modifier) @keyword

; (this_type) @variable.builtin
(this_type) @type.builtin

((identifier) @variable.builtin
  (#vim-match? @variable.builtin "^(arguments|module|console|window|document|globalThis)$"))

; Make anything following `new` highlight as a constructor
(new_expression
  ((identifier) @constructor
    (#lua-match? @constructor "^[_a-zA-Z]")))
