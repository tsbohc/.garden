(require-macros :zest.macros)

; flash yanked text
(au- [TextYankPost] "*"
     (fn [] (vim.highlight.on_yank {:higroup "Search" :timeout 100})))

; open help in a vertical buffer
(au- [FileType] "help"
     (fn [] (exec- "wincmd L")))

; show/hide cursorline based on window focus and mode
(au- [InsertEnter BufLeave FocusLost] "*"
     (fn [] (se- nocursorline)))

(au- [InsertLeave BufEnter FocusGained] "*"
     (fn [] (if (not= (vim.fn.mode) :i) (se- cursorline))))

; restore last position in file
(au- [BufReadPost] "*"
     (fn []
       (when (and (>= (vim.fn.line "'\"") 1)
                  (<= (vim.fn.line "'\"") (vim.fn.line "$"))
                  (not (vim.bo.filetype:find "commit")))
         (norm- "`\""))))
