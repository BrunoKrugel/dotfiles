; inherits: markdown

(fenced_code_block
  (info_string) @_lang
  (#eq? @_lang "sh")
  (code_fence_content) @bash)

(fenced_code_block
  (info_string) @_lang
  (#eq? @_lang "js")
  (code_fence_content) @javascript)

; extends

(((inline) @_inline
  (#match? @_inline "^\(import\|export\)")) @injection.content
  (#set! injection.language "tsx"))
