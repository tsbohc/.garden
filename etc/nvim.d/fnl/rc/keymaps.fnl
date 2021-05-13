(require-macros :zest.ki-macros)
(require-macros :zest.no-macros)

(mapleader- " ")

; ------------------------------------
; -- land of opinionated navigation --
; ------------  --/-<@  --------------

; smart v-line movement
(ki- [nvo :expr] :e (fn [] (if (> vim.v.count 0) :k :gk)))
(ki- [nvo :expr] :n (fn [] (if (> vim.v.count 0) :j :gj)))

; vertical
(li- [n] N <c-d>)
(li- [n] E <c-u>)

; horizontal
(li- [nv] H 0)
(li- [nv] I $)
(li- [nv] <ScrollWheelUp> <c-y>)
(li- [nv] <ScrollWheelDown> <c-e>)

; split-wise
(li- [n] <c-h> <c-w>h)
(li- [n] <c-n> <c-w>j)
(li- [n] <c-e> <c-w>k)
(li- [n] <c-i> <c-w>l)

; consistency
(li- [n] Y y$)

; fixes
(li- [n] <c-j> J)

; ------------------------------------
; --      search and replace        --
; ------------  --/-<@  --------------

; general
(li- [n :silent] // ":noh<cr>")
(li- [n :silent] * *N) ; check if there's an entry above?

(li- [n] <leader>r ":%s///g<left><left>")  ; replace searched text
(li- [x] <leader>r ":s///g<left><left>")   ; same but in current v-selection

; search for selected text
;(k.x * (do (z.norm "gvy") (z.exec (.. "/" (z.eval "@\""))) (z.norm "<c-o>")))

; undo-redo
(li- [n] U <c-r>)

; stay visual when indenting
(li- [x] < <gv)
(li- [x] > >gv)

; colemak
(li- [nvo] i l)
(li- [nvo] l i)
(li- [nvo] L I)
(li- [nvo] k n)
(li- [nvo] K N)
(li- [nvo] j f)
(li- [nvo] J F)
(li- [nvo] f e)
(li- [nvo] F E)

;```
;(each [_ k (ipairs [:h :j :k :l])]
;  (ki- [n] (.. "<c-" k ">") (.. "<c-w>" k)))

;(no- dd)

;(li- [nvo] U o) ; - bind U to o
;```

;(ki- [n] "<C-M>" (fn [] (rint "woooo")))
;(ki- [n] "<C-M>" (no- D))
;(ki- [n] "<C-M>" (vim.api.nvim_command "norm! D"))

;(li- [n] <C-M> ":echo 'hello'")
