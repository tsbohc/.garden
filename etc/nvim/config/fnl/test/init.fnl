;(require-macros :lime.macros)
;
;(def-keymap [n] :<c-m> "echo 'keymap-str-m'<cr>")
;
;(def-keymap [n] :<c-m>
;  (fn [] (print "keymap-fn-m")))
;
;(def-augroup :test-m
;  (def-autocmd [:BufLeave :BufEnter] "*"
;    (fn [] (print :macro-augroup-1)))
;  (def-autocmd [:BufLeave :BufEnter] "*"
;    (fn [] (print :macro-augroup-2))))
