; extends

; foo(/* html */ `<span>`)
; foo(/* sql */ `SELECT * FROM foo`)
((
  (template_string) @constant
  (#match? @constant "(SELECT|select|insert|INSERT).*")
)@injection.content (#set! injection.language "sql") 
    (#set! injection.include-children))

