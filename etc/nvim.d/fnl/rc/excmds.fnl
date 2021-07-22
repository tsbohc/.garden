;(require-macros :zest.old-macros)
;
;(cm- SquishWhitespace 
;  (fn []
;    ; e at the end supresses "pattern not found"
;    (exec- ":%s/\\(\\n\\n\\)\\n\\+/\\1/e")
;    (exec- ":noh")))

;(def-cm- [-nargs=1] Greet
;  (fn [name]
;    (print (.. "hello, " name "!")))
;  [<f-args>])
