; extends

; modified version from https://github.com/ray-x/go.nvim
; inject sql in single line strings
; e.g. db.GetContext(ctx, "SELECT * FROM users WHERE name = 'John'")
((call_expression
  (selector_expression
    field: (field_identifier) @_field)
  (argument_list
    (interpreted_string_literal) @sql))
  (#any-of? @_field
    "Exec" "ExecContext" "Query" "QueryContext" "QueryRow" "QueryRowContext" "Prepare"
    "PrepareContext")
  (#offset! @sql 0 1 0 -1))

; ----------------------------------------------------------------
; a general query injection
([
  (interpreted_string_literal)
  (raw_string_literal)
] @sql
  (#match? @sql
    "(SELECT|select|INSERT|insert|UPDATE|update|DELETE|delete).+(FROM|from|INTO|into|VALUES|values|SET|set).*(WHERE|where|GROUP BY|group by)?")
  (#offset! @sql 0 1 0 -1))

; ----------------------------------------------------------------
; fallback keyword and comment based injection
([
  (interpreted_string_literal)
  (raw_string_literal)
] @sql
  (#contains? @sql
    "ADD CONSTRAINT" "ALTER TABLE" "ALTER COLUMN" "FOREIGN KEY" "GROUP BY" "HAVING" "CREATE INDEX"
    "INSERT INTO" "NOT NULL" "PRIMARY KEY" "UPDATE SET" "TRUNCATE TABLE" "LEFT JOIN"
    "add constraint" "alter table" "alter column" "foreign key" "group by" "having" "create index"
    "insert into" "not null" "primary key" "update set" "truncate table" "left join")
  (#offset! @sql 0 1 0 -1))

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

; extends

; inject sql into any const string with word query in the name
; e.g. const query = `SELECT * FROM users WHERE name = 'John'`;
(const_spec
  name: (identifier) @_name
  (#match? @_name "[Qq]uery")
  value: (expression_list
    (raw_string_literal) @sql)
  (#offset! @sql 0 1 0 -1))

; inject sql in single line strings
(call_expression
  (selector_expression
    field: (field_identifier) @_field
    (#any-of? @_field "GetContext" "ExecContext" "SelectContext" "In"))
  (argument_list
    (interpreted_string_literal) @sql)
  (#offset! @sql 0 1 0 -1)) ; wtf does this do?

; inject sql in multi line strings
(call_expression
  (selector_expression
    field: (field_identifier) @_field
    (#any-of? @_field "GetContext" "ExecContext" "SelectContext" "In"))
  (argument_list
    (raw_string_literal) @sql)
  (#offset! @sql 0 1 0 -1)) ; wtf does this do?

((raw_string_literal) @sql
  (#lua-match? @sql "^`%s*[Ss][Ee][Ll][Ee][Cc][Tt]%s*")
  (#offset! @sql 0 1 0 -1))

((raw_string_literal) @sql
  (#lua-match? @sql "^`%s*[Ii][Nn][Ss][Ee][Rr][Tt]%s*")
  (#offset! @sql 0 1 0 -1))

((raw_string_literal) @sql
  (#lua-match? @sql "^`%s*[Uu][Pp][Dd][Aa][Tt][Ee]%s*")
  (#offset! @sql 0 1 0 -1))

((raw_string_literal) @sql
  (#lua-match? @sql "^`%s*[Uu][Pp][Ss][Ee][Rr][Tt]%s*")
  (#offset! @sql 0 1 0 -1))

((raw_string_literal) @sql
  (#lua-match? @sql "^`%s*[Dd][Ee][Ll][Ee][Tt][Ee]%s*")
  (#offset! @sql 0 1 0 -1))

((raw_string_literal) @sql
  (#lua-match? @sql "^`%s*[Rr][Ee][Pp][Ll][Aa][Cc][Ee]%s*")
  (#offset! @sql 0 1 0 -1))

((raw_string_literal) @sql
  (#lua-match? @sql "^`%s*[Aa][Ll][Tt][Ee][Rr]%s*")
  (#offset! @sql 0 1 0 -1))

((raw_string_literal) @sql
  (#lua-match? @sql "^`%s*[Ww][Ii][Tt][Hh]%s*")
  (#offset! @sql 0 1 0 -1))

((raw_string_literal) @sql
  (#lua-match? @sql "^`%s*[Ee][Xx][Pp][Ll][Ll][Aa][Ii][Nn]%s*")
  (#offset! @sql 0 1 0 -1))

((interpreted_string_literal) @sql
  (#lua-match? @sql "^`%s*[Ss][Ee][Ll][Ee][Cc][Tt]%s*")
  (#offset! @sql 0 1 0 -1))

((interpreted_string_literal) @sql
  (#lua-match? @sql "^`%s*[Ii][Nn][Ss][Ee][Rr][Tt]%s*")
  (#offset! @sql 0 1 0 -1))

((interpreted_string_literal) @sql
  (#lua-match? @sql "^`%s*[Uu][Pp][Dd][Aa][Tt][Ee]%s*")
  (#offset! @sql 0 1 0 -1))

((interpreted_string_literal) @sql
  (#lua-match? @sql "^`%s*[Uu][Pp][Ss][Ee][Rr][Tt]%s*")
  (#offset! @sql 0 1 0 -1))

((interpreted_string_literal) @sql
  (#lua-match? @sql "^`%s*[Dd][Ee][Ll][Ee][Tt][Ee]%s*")
  (#offset! @sql 0 1 0 -1))

((interpreted_string_literal) @sql
  (#lua-match? @sql "^`%s*[Rr][Ee][Pp][Ll][Aa][Cc][Ee]%s*")
  (#offset! @sql 0 1 0 -1))

((interpreted_string_literal) @sql
  (#lua-match? @sql "^`%s*[Aa][Ll][Tt][Ee][Rr]%s*")
  (#offset! @sql 0 1 0 -1))

((interpreted_string_literal) @sql
  (#lua-match? @sql "^`%s*[Ww][Ii][Tt][Hh]%s*")
  (#offset! @sql 0 1 0 -1))

((interpreted_string_literal) @sql
  (#lua-match? @sql "^`%s*[Ee][Xx][Pp][Ll][Ll][Aa][Ii][Nn]%s*")
  (#offset! @sql 0 1 0 -1))

; ----------------------------------------------------------------
; inject json
(field_declaration
  tag: (raw_string_literal) @injection.content
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.self))
