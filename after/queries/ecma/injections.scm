; extends

; foo(/* html */ `<span>`)
; foo(/* sql */ `SELECT * FROM foo`)
((
  (template_string) @constant
  (#match? @constant "(SELECT|select|insert|INSERT|DELETE|delete|WITH|with|UPDATE|update).*")
)@injection.content (#set! injection.language "sql") 
    (#set! injection.include-children))

