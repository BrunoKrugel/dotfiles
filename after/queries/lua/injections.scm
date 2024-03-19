((function_call
  name: [
    (identifier) @_cdef_identifier
    (_ _ (identifier) @_cdef_identifier)
  ]
  arguments:
    (arguments
      (string content: _ @injection.content)))
  (#set! injection.language "c")
  (#eq? @_cdef_identifier "cdef"))

;; highlight string as query if starts with `;; query`
(string content: _ @injection.content
 (#lua-match? @injection.content "^%s*;+%s?query")
 (#set! injection.language "query"))

((comment) @injection.content
  (#lua-match? @injection.content "^[-][-][-][%s]*@")
  (#set! injection.language "luadoc")
  (#set! injection.include-children)
  (#offset! @injection.content 0 3 0 0))
