;(require-macros :zest.macros)

;(set-option [:append] completeopt ["menuone" "noselect"])
;(set-option completeopt ["menuone" "noselect"])

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
