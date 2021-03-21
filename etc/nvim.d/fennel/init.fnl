(module init
  {require {settings rc.settings
            mappings rc.mappings}})


; {{{
;(fn get-callable-index-table [callback]
;  "translates callback(parameter) to table.parameter()"
;  (setmetatable
;    {} {:__index
;        (fn [self index]
;          (tset self index (fn [...] (callback index ...)))
;          (rawget self index))}))
; }}}
