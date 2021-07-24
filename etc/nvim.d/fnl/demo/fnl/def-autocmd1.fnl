(require-macros :zest.macros)

(def-autocmd [BufNewFile BufRead] [:*.html :*.xml]
  "setlocal nowrap")

42
