(module rc.autocmds
  {require {au zest.au
            z zest.lib}
   require-macros [zest.macros]})

; show/hide cursorline based on window focus and mode
(au- [InsertEnter BufLeave FocusLost] *
     #(se- nocursorline))

(au- [InsertLeave BufEnter FocusGained] *
     #(if (not= (vim.fn.mode) :i)
        (se- cursorline)))

; flash yanks
(au- TextYankPost *
     #(vim.highlight.on_yank {:higroup "Search" :timeout 100}))

; open help in a vertical buffer
(au- FileType help
     #(z.exec "wincmd L"))

; default filetype to txt
(au- BufEnter *
     #(if (= vim.bo.filetype "")
        (set vim.bo.filetype "txt")))
