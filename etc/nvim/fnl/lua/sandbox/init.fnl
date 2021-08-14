(require-macros :zest.lime.macros)

;(def-autocmd :foo "*" My_dinosaur_function)

(fn a [key]
  (def-keymap [nvo] key [(print)]))

42
