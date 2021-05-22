(require-macros :zest.macros)

; show/hide cursorline based on window focus and mode
(au- [InsertEnter BufLeave FocusLost] "*"
     (fn [] (se- nocursorline)))

(au- [InsertLeave BufEnter FocusGained] "*"
     (fn [] (if (not= (vim.fn.mode) :i) (se- cursorline))))

; flash yanked text
(au- [TextYankPost] "*"
     (fn [] (vim.highlight.on_yank {:higroup "Search" :timeout 100})))

; restore last position in file
(au- [BufReadPost] "*"
     (fn []
       (when (and (>= (vim.fn.line "'\"") 1)
                  (<= (vim.fn.line "'\"") (vim.fn.line "$"))
                  (not (vim.bo.filetype:find "commit")))
         (norm- "`\""))))

; open help in a vertical buffer
(au- [FileType] "help"
     (fn [] (exec- "wincmd L")))

; default ft to 'text'
;(au- [BufEnter] "*"
;     (fn [] (if (= vim.bo.filetype "") (set vim.bo.filetype "text"))))

; enable wrap in non-programming fts
(au- [FileType] "text,latex,markdown,tex,context,plaintex"
     (fn [] (se- wrap)))

;(au- [FileType] "fennel"
;     (fn [] (se- lispwords (.. vim.o.lispwords (table.concat [:when-not :if-not] ",")))))
