(require-macros :zest.macros)

(lead- " ")

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
(li- [n] U <c-r>)
(li- [n] <c-j> J)

; ------------------------------------
; --      search and replace        --
; ------------  --/-<@  --------------

; general
(li- [nv :silent] // ":noh<cr>")
(li- [n :silent] * *N) ; check if there's an entry above?

(li- [n] <leader>r ":%s///g<left><left>")  ; replace searched text
(li- [x] <leader>r ":s///g<left><left>")   ; same but in current v-selection

; search for selected text
(ki- [x] "*" (fn []
  (norm- "gvy")
  (exec- (.. "/" (eval- "@\"")))
  (norm- "N")))

; stay in visual mode when indenting
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
