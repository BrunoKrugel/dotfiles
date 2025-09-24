; extends

; inject sql in single line strings
; e.g. db.GetContext(ctx, "SELECT * FROM users WHERE name = 'John'")
((call_expression
  (selector_expression
    field: (field_identifier) @_field)
  (argument_list
    (interpreted_string_literal) @injection.content))
  (#any-of? @_field
    "Exec" "GetContext" "ExecContext" "SelectContext" "In" "RebindNamed" "Rebind" "QueryRowxContext"
    "NamedExec" "MustExec" "Get" "Queryx")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "sql"))

; ----------------------------------------------------------------
; a general query injection
([
  (interpreted_string_literal)
  (raw_string_literal)
] @injection.content
  (#match? @injection.content
    "(SELECT|select|INSERT|insert|UPDATE|update|DELETE|delete).+(FROM|from|INTO|into|VALUES|values|SET|set).*(WHERE|where|GROUP BY|group by)?")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "sql"))

; ----------------------------------------------------------------
; fallback keyword and comment based injection
([
  (interpreted_string_literal)
  (raw_string_literal)
] @injection.content
  (#contains? @injection.content
    "-- sql" "--sql" "ADD CONSTRAINT" "ALTER TABLE" "ALTER COLUMN" "DATABASE" "FOREIGN KEY"
    "GROUP BY" "HAVING" "CREATE INDEX" "INSERT INTO" "NOT NULL" "PRIMARY KEY" "UPDATE SET"
    "TRUNCATE TABLE" "LEFT JOIN" "add constraint" "alter table" "alter column" "database"
    "foreign key" "group by" "having" "create index" "insert into" "not null" "primary key"
    "update set" "truncate table" "left join")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "sql"))

; should I use a more exhaustive list of keywords?
;  "ADD" "ADD CONSTRAINT" "ALL" "ALTER" "AND" "ASC" "COLUMN" "CONSTRAINT" "CREATE" "DATABASE" "DELETE" "DESC" "DISTINCT" "DROP" "EXISTS" "FOREIGN KEY" "FROM" "JOIN" "GROUP BY" "HAVING" "IN" "INDEX" "INSERT INTO" "LIKE" "LIMIT" "NOT" "NOT NULL" "OR" "ORDER BY" "PRIMARY KEY" "SELECT" "SET" "TABLE" "TRUNCATE TABLE" "UNION" "UNIQUE" "UPDATE" "VALUES" "WHERE"
; json
((const_spec
  name: (identifier) @_const
  value: (expression_list
    (raw_string_literal) @json))
  (#lua-match? @_const ".*[J|j]son.*"))

; jsonStr := `{"foo": "bar"}`
((short_var_declaration
  left: (expression_list
    (identifier) @_var)
  right: (expression_list
    (raw_string_literal) @json))
  (#lua-match? @_var ".*[J|j]son.*")
  (#offset! @json 0 1 0 -1))

(field_declaration
  name: (field_identifier)
  type: (type_identifier)
  tag: (raw_string_literal
    (raw_string_literal_content) @injection.content
    (#set! injection.language "go_tags")))

(if_statement
  condition: (binary_expression
    left: (identifier) @err_var
    (#eq? @err_var "err")
    operator: "!="
    right: (nil))
  consequence: (block
    (return_statement
      (expression_list
        (identifier) @ret_err
        (#eq? @ret_err "err"))))) @iferr_block
