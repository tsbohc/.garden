; settings

(se- scrolloff 10)
(se- relativenumber)
(se- nowrap)
(se- foldmethod "marker")

; keymaps

(k.nvo [expr] :j #(if (> vim.v.count 0) :k :gk))
(k.nvo [expr] :k #(if (> vim.v.count 0) :j :gj))

(k.x :< :<gv)
(k.x :> :>gv)

; autocmds

(au- [InsertEnter BufLeave FocusLost] *
     #(se- nocursorline))

(au- [InsertLeave BufEnter FocusGained] *
     #(when (not= :i (vim.fn.mode))
        (se- cursorline)))

; statusline

(sl- [BufEnter] [1 0 1 1 :Search]
     #(when vim.bo.readonly "readonly"))

(sl- [1 0 1 1 :CursorLine]
     "%2p%%")
