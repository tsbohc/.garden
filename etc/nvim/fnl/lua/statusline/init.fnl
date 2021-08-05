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

;(sl.fn [:BufEnter :CursorMoved] [1 0 0 0 :Comment]
;  (fn []
;    (let [d (vim.lsp.diagnostic.get_line_diagnostics)]
;      (?. (?. d 1) :message))))

(sl.st [0 0 0 0] "%=%<")

(sl.fn [:VimEnter :CursorMoved :CursorMovedI] [1 0 0 0 :LspDiagnosticsSignError]
       (fn []
         (let [n (vim.lsp.diagnostic.get_count 0 "Error")]
           (if (> n 0) (.. "%#LineNr#<%#LspDiagnosticsFloatingError#" n "%#LineNr#>") ""))))

(sl.fn [:VimEnter :CursorMoved :CursorMovedI] [1 0 0 0 :LspDiagnosticsSignWarning]
  (fn []
    (let [n (vim.lsp.diagnostic.get_count 0 "Warning")]
      (if (> n 0) (.. "%#LineNr#<%#LspDiagnosticsFloatingWarning#" n "%#LineNr#>") ""))))

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
