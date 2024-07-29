; extends

((predicate
  name: (identifier) @_name
  parameters: (parameters
    (string) @injection.content))
  (#match? @_name "^#?setgsub$")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "luap"))
