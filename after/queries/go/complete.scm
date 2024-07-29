;((function_declaration
;		name: (identifier) @func_name
;		(parameter_list
;			(parameter_declaration
;				(identifier) @complete_item)) @complete_def) @func)
(function_declaration
  name: (identifier) @context_name)

(method_declaration
  name: (field_identifier) @context_name)

(type_declaration
  (type_spec
    name: (type_identifier) @context_name))

;((function_declaration
;((type_declaration
;	(type_spec
;		name: (type_identifier) @complete_item))) @complete_global
;
;(source_file
;	(var_declaration
;		(var_spec
;			name: (identifier) @complete_item)) @complete_global)
;
;(source_file
;	(const_declaration
;		(const_spec
;			name: (identifier) @complete_item)) @complete_global)
;
;((short_var_declaration
;    left: (expression_list
;			  (identifier) @complete_item )) @complete_context)
;
;(func_literal) @complete_scope
;(source_file) @complete_top
;(if_statement) @complete_scope
;(block) @scope
;(for_statement) @complete_scope
;(method_declaration) @complete_context
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
