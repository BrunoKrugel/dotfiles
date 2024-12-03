; ; ===== CUSTOM =====
; (function_declaration
;   (identifier) @function_definition)

; Match Swagger annotations inside comments
((line_comment) @comment
   (#match? @comment "@\\w+"))

; Specific Swagger keywords
 ((line_comment) @swagger.tag
   (#match? @swagger.tag "@(Summary|Tags|accepts|param|produces|Success|Failure|Router)"))
