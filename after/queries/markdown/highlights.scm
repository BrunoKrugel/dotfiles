; extends

; Thematic breaks
((thematic_break) @punctuation.special
  (#offset! @punctuation.special 0 2 0 0)
  (#set! conceal "━"))

((thematic_break) @punctuation.special
  (#offset! @punctuation.special 0 1 0 0)
  (#set! conceal "━"))

((thematic_break) @punctuation.special
  (#set! conceal "━"))

; Bullet points
([
  (list_marker_minus)
  (list_marker_star)
] @punctuation.special
  (#offset! @punctuation.special 0 0 0 -1)
  (#set! conceal "•"))

(list
  (list_item
    (list
      (list_item
        ([
          (list_marker_minus)
          (list_marker_star)
        ] @punctuation.special
          (#offset! @punctuation.special 0 0 0 -1)
          (#set! conceal "⭘"))))))

(list
  (list_item
    (list
      (list_item
        (list
          (list_item
            ([
              (list_marker_minus)
              (list_marker_star)
            ] @punctuation.special
              (#offset! @punctuation.special 0 0 0 -1)
              (#set! conceal "◼"))))))))

(list
  (list_item
    (list
      (list_item
        (list
          (list_item
            (list
              (list_item
                ([
                  (list_marker_minus)
                  (list_marker_star)
                ] @punctuation.special
                  (#offset! @punctuation.special 0 0 0 -1)
                  (#set! conceal "◻"))))))))))

(list
  (list_item
    (list
      (list_item
        (list
          (list_item
            (list
              (list_item
                (list
                  (list_item
                    ([
                      (list_marker_minus)
                      (list_marker_star)
                    ] @punctuation.special
                      (#offset! @punctuation.special 0 0 0 -1)
                      (#set! conceal "→"))))))))))))

; Checkbox list items
((task_list_marker_unchecked) @text.todo.unchecked
  (#offset! @text.todo.unchecked 0 -2 0 0)
  (#set! conceal "✗"))

((task_list_marker_checked) @text.todo.checked
  (#offset! @text.todo.checked 0 -2 0 0)
  (#set! conceal "✔"))

(list_item
  (task_list_marker_checked)) @comment

; Tables
(pipe_table_header
  "|" @punctuation.special @conceal
  (#set! conceal "┃"))

(pipe_table_delimiter_row
  "|" @punctuation.special @conceal
  (#set! conceal "┃"))

(pipe_table_delimiter_cell
  "-" @punctuation.special @conceal
  (#set! conceal "━"))

((pipe_table_align_left) @punctuation.special @conceal
  (#set! conceal "┣"))

((pipe_table_align_right) @punctuation.special @conceal
  (#set! conceal "┫"))

(pipe_table_row
  "|" @punctuation.special @conceal
  (#set! conceal "┃"))

; Block quotes
((block_quote_marker) @punctuation.special
  (#offset! @punctuation.special 0 0 0 -1)
  (#set! conceal "▐"))

((block_continuation) @punctuation.special
  (#eq? @punctuation.special ">")
  (#set! conceal "▐"))

((block_continuation) @punctuation.special
  (#eq? @punctuation.special "> ")
  (#offset! @punctuation.special 0 0 0 -1)
  (#set! conceal "▐"))

((block_continuation) @punctuation.special
  ; for indented code blocks
  (#eq? @punctuation.special ">     ")
  (#offset! @punctuation.special 0 0 0 -5)
  (#set! conceal "▐"))

; Headers
((atx_h1_marker) @text.title
  (#set! conceal "1"))

((atx_h2_marker) @text.title
  (#set! conceal "2"))

((atx_h3_marker) @text.title
  (#set! conceal "3"))

((atx_h4_marker) @text.title
  (#set! conceal "4"))

((atx_h5_marker) @text.title
  (#set! conceal "5"))

((atx_h6_marker) @text.title
  (#set! conceal "6"))

; Fenced codeblocks + devicons for the language
; (
;   fenced_code_block (fenced_code_block_delimiter) @markdown_code_block_marker
;   (#set! conceal "")
; )
((info_string
  (language)) @markdown_code_block_lang_javascript
  (#eq? @markdown_code_block_lang_javascript "javascript")
  (#set! conceal " "))

((info_string
  (language)) @markdown_code_block_lang_typescript
  (#eq? @markdown_code_block_lang_typescript "typescript")
  (#set! conceal " "))

((info_string
  (language)) @markdown_code_block_lang_json
  (#eq? @markdown_code_block_lang_json "json")
  (#set! conceal " "))

((info_string
  (language)) @markdown_code_block_lang_bash
  (#eq? @markdown_code_block_lang_bash "bash")
  (#set! conceal " "))

((info_string
  (language)) @markdown_code_block_lang_bash
  (#eq? @markdown_code_block_lang_bash "sh")
  (#set! conceal ""))

((info_string
  (language)) @markdown_code_block_lang_lua
  (#eq? @markdown_code_block_lang_lua "lua")
  (#set! conceal " "))

((info_string
  (language)) @markdown_code_block_lang_bash
  (#eq? @markdown_code_block_lang_bash "rust")
  (#set! conceal " "))

((info_string
  (language)) @markdown_code_block_lang_bash
  (#eq? @markdown_code_block_lang_bash "bash")
  (#set! conceal " "))

((info_string
  (language)) @markdown_code_block_lang_diff
  (#eq? @markdown_code_block_lang_diff "diff")
  (#set! conceal " "))

((info_string
  (language)) @markdown_code_block_lang_vim
  (#eq? @markdown_code_block_lang_vim "vim")
  (#set! conceal " "))

((info_string
  (language)) @markdown_code_block_lang_yaml
  (#eq? @markdown_code_block_lang_yaml "yaml")
  (#set! conceal ""))

((info_string
  (language)) @markdown_code_block_lang_java
  (#eq? @markdown_code_block_lang_java "java")
  (#set! conceal " "))

((info_string
  (language)) @markdown_code_block_lang_html
  (#eq? @markdown_code_block_lang_html "html")
  (#set! conceal " "))

((info_string
  (language)) @markdown_code_block_lang_css
  (#eq? @markdown_code_block_lang_css "css")
  (#set! conceal " "))

((info_string
  (language)) @markdown_code_block_lang_sql
  (#eq? @markdown_code_block_lang_sql "sql")
  (#set! conceal " "))
