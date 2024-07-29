[
  (function)
  (function_declaration)
  (method_definition)
] @scope

(function
  name: (identifier) @context_name)

(function_declaration
  name: (identifier) @context_name)

(method_definition
  name: (property_identifier) @context_name)

(assignment_expression
  left: (member_expression
    property: (property_identifier) @context_name)
  right: (arrow_function))

(assignment_expression
  left: (member_expression
    property: (property_identifier) @context_name)
  right: (function))
