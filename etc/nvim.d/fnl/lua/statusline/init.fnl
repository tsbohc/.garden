(local sl (require :statusline.sl))

(sl.fn [:BufEnter] [0 0 1 1 :CursorLine]
  (fn [] (let [fname (vim.fn.expand "%:t")]
           (if (not= fname "")
             (.. "‹‹ " fname " ››")
             " ‹ new › "))))

(sl.fn [:BufEnter :BufWritePost] [1 0 0 0]
  (fn [] (if (not= (vim.fn.expand "%:t") "")
           "%{&modified?'':'saved'}")))

(sl.fn [:BufEnter] [1 0 1 1 :Search]
  (fn [] (when vim.bo.readonly "readonly")))

(sl.st [0 0 0 0] "%=%<")

(sl.fn [:BufEnter :BufWritePost] [1 0 0 0]
  (fn [] (vim.fn.expand "%:p:~:h")))

(sl.fn [:BufReadPost :BufWritePost] [1 0 0 0]
  (fn [] vim.bo.filetype))

;(sl.fn [:BufEnter :InsertLeave] [0 0 0 0]
;  (fn [] (if (not= (or vim.g._layout "us") "us")
;           "×" " ")))

(sl.st [1 0 1 1 :CursorLine] "%2p%%")

; init

(sl.init)
