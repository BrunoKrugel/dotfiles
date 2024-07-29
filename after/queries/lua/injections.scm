(function_call
  name: (_) @_vimcmd_identifier
  arguments: (arguments
    .
    (_)
    .
    (table_constructor
      (field
        name: (identifier) @_command
        value: (string
          content: (_) @injection.content))) .)
  ; limit so only 2-argument functions get matched before pred handle
  (#eq? @_vimcmd_identifier "autocmd")
  (#eq? @_command "command")
  (#set! injection.language "vim"))

; highlight string as query if starts with `;; query`
(string
  content: _ @injection.content
  (#lua-match? @injection.content "^%s*;+%s?query")
  (#set! injection.language "query"))

((comment) @injection.content
  (#lua-match? @injection.content "^[-][-][-][%s]*@")
  (#set! injection.language "luadoc")
  (#set! injection.include-children)
  (#offset! @injection.content 0 3 0 0))
