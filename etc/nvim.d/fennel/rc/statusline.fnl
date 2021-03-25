(module rc.statusline
  {require {sl zest.sl}
   require-macros [zest.macros]})

(sl- [BufEnter BufWritePost] [0 0 1 1 :CursorLine]
     #(let [fname (vim.fn.expand "%:t")]
        (if (not= fname "")
          (.. "‹‹ " fname " ››")
          " ‹ new › ")))

(sl- [BufEnter] [1 0 0 0]
     #(let [fname (vim.fn.expand "%:t")]
        (if (not= fname "")
          "%{&modified?'':'saved'}")))

(sl- [BufEnter] [1 0 1 1 :Search]
     #(when vim.bo.readonly "readonly"))

(sl- "%=%<")

(sl- [BufEnter BufWritePost]
     #(vim.fn.expand "%:p:~:h"))

(sl- [BufReadPost BufWritePost] [1 0 0 0] vim.bo.filetype)

(sl- [1 0 1 1 :CursorLine] "%2p%%")

(sl.init)
