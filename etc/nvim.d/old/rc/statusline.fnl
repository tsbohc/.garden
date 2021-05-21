(module rc.statusline
  {require {sl zest.sl}
   require-macros [zest.macros]})

; filename
(sl- [BufEnter BufWritePost] [0 0 1 1 :CursorLine]
     #(let [fname (vim.fn.expand "%:t")]
        (if (not= fname "")
          (.. "‹‹ " fname " ››")
          " ‹ new › ")))

; inverse modified tag
(sl- [BufEnter BufWritePost] [1 0 0 0]
     #(if (not= (vim.fn.expand "%:t") "")
        "%{&modified?'':'saved'}"))

; readonly tag
(sl- [BufEnter] [1 0 1 1 :Search]
     #(when vim.bo.readonly "readonly"))

; align to the right
(sl- "%=%<")

; file location
(sl- [BufEnter BufWritePost]
     #(vim.fn.expand "%:p:~:h"))

; filetype
(sl- [BufReadPost BufWritePost] [1 0 0 0] vim.bo.filetype)

; scroll percentage
(sl- [1 0 1 1 :CursorLine] "%2p%%")

(sl.init)

