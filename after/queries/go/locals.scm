(function_declaration
  name: (identifier) @complete_item
  (parameter_list
    (parameter_declaration
      (identifier) @complete_item)) @complete_def) @complete_global

;((function_declaration
(type_declaration
  (type_spec
    name: (type_identifier) @complete_item)) @complete_global

(source_file
  (var_declaration
    (var_spec
      name: (identifier) @complete_item)) @complete_global)

(source_file
  (const_declaration
    (const_spec
      name: (identifier) @complete_item)) @complete_global)

(short_var_declaration
  left: (expression_list
    (identifier) @complete_item)) @complete_context

(func_literal) @complete_context

(source_file) @complete_top

(if_statement) @complete_scope

(block) @complete_scope

(for_statement) @complete_scope

(method_declaration) @complete_context

;(
;	(function_declaration
;		name: (identifier) @decl.function) @decl_scope
;)
;
;(
;	(method_declaration
;		name: (field_identifier) @decl.method
;		body: (block)? @decl_scope_inner)  @decl_scope
;)
;
;((type_declaration
;	  (type_spec
;		name: (type_identifier) @decl.type
;		(struct_type
;			(field_declaration_list (_)?) @decl_scope_inner))) @decl_scope)
;
;
;((var_spec
;  name: (identifier) @decl.var))
;(局部变量也会被纳入
;	(var_declaration
;		(var_spec
;			name: (identifier) @decl_ident
;		)
;	)
;)
;(
;	(short_var_declaration
;	  left: (expression_list
;			  (identifier) @decl.var
;		  )
;	  right: (expression_list
;			(func_literal) @lamda
;		  )
;	)
;)
; extends

(var_spec) @local.scope

(field_declaration
  name: (field_identifier) @local.definition.field)

(method_elem
  name: (field_identifier) @function.method.name
  parameters: (parameter_list) @function.method.parameter_list) @local.interface.method.declaration

(type_declaration
  (type_spec
    name: (type_identifier) @local.name
    type: [
      (struct_type)
      (interface_type)
    ] @local.type)) @local.start
