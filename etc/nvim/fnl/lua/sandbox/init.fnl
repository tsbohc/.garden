(import-macros
  {: def-keymap} :zest.next.macros)

;(fn My_fn [] (print "yay_var"))
;(def-keymap :<c-m> [n] My_fn)
;(def-keymap :<c-m> [n] (fn [] (print :yay_fn)))
;(def-keymap :<c-m> [n] #(print :yay_hashfn))
(def-keymap :<c-m> [n] [(print :yay_sugar)])
