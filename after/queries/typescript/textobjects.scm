function: (member_expression
  object: (this)
  property: (property_identifier) @this_method_call)

(member_expression
  object: (member_expression
    object: (this)
    property: (property_identifier))
  property: (property_identifier) @this_method_call)

(call_expression
  function: (member_expression
    object: (this)
    property: [
      (private_property_identifier) @private
      (#match? @private "^(!(#error|#debug)).*")
      (property_identifier)
    ] @method_object_call))

(call_expression
  function: (member_expression
    object: (member_expression
      object: (this)
      property: (property_identifier))
    property: [
      (property_identifier)
      (private_property_identifier)
    ] @method_object_call))

(object
  (pair
    key: (property_identifier) @object_key
    value: [
      (string)
      (number)
      (true)
      (false)
      (null)
      (undefined)
      (template_string)
      (object)
      (array)
    ] @object_value))

(lexical_declaration
  (variable_declarator
    name: (identifier)
    value: (object) @object_declaration))

(method_definition
  parameters: (formal_parameters
    [
      (required_parameter)
      (optional_parameter)
    ] @method_parameter))

; extends

(interface_declaration) @class.outer

(interface_declaration
  body: (object_type
    .
    "{"
    .
    (_) @_start @_end
    _? @_end
    .
    "}"
    (#make-range! "class.inner" @_start @_end)))

(type_alias_declaration) @class.outer

(type_alias_declaration
  value: (object_type
    .
    "{"
    .
    (_) @_start @_end
    _? @_end
    .
    "}"
    (#make-range! "class.inner" @_start @_end)))

(enum_declaration) @class.outer

(enum_declaration
  body: (enum_body
    .
    "{"
    .
    (_) @_start @_end
    _? @_end
    .
    "}"
    (#make-range! "class.inner" @_start @_end)))

; ===== CUSTOM =====
(number) @number
