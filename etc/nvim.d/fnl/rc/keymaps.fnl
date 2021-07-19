(require-macros :zest.macros)
(import-macros {:keymap-function ki.fn-
                :keymap-normal   ki.no-} :neozest.macros)

(lead- " ")

(ki.fn- :<c-m> [n]
  (print "working on zest.nvim!"))

; ------------------------------------
; -- land of opinionated navigation --
; ------------  --/-<@  --------------

; smart v-line movement
(ki.fn- :e [nv :expr] (if (> vim.v.count 0) "k" "gk"))
(ki.fn- :n [nv :expr] (if (> vim.v.count 0) "j" "gj"))
(ki.no- [o] {:e "k" :n "j"})

; screen and line movement
(ki.no- [nv] {:N "<c-d>" :E "<c-u>"})
(ki.no- :H [nv] "0")
(ki.no- :I [nv] "$")

; mousewheel blasphemy
(ki.no- [nv]
  {:<ScrollWheelUp>   "<c-y>"
   :<ScrollWheelDown> "<c-e>"})

; split movement
(ki.no- [n]
  {:<c-h> "<c-w>h"
   :<c-n> "<c-w>j"
   :<c-e> "<c-w>k"
   :<c-i> "<c-w>l"})

; ------------------------------------
; --      search and replace        --
; ------------  --/-<@  --------------

; easy nohl
(ki.no- :// [nv :silent] ":nohlsearch<cr>")

; do not jump to the next match when *-ing
(ki.no- :* [n :silent] "*N") ; check if there's an entry above?

; search for selected text
(ki.fn- :* [x]
  (norm- "gvy")
  (exec- (.. "/" (eval- "@\"")))
  (norm- "N"))

; replace search matches
(ki.no- :<leader>r [n] ":%s///g<left><left>")
(ki.no- :<leader>r [x] ":s///g<left><left>")

; ------------------------------------
; --             misc               --
; ------------  --/-<@  --------------

;stay in visual mode after indenting
(ki.no- [x] {:< "<gv" :> ">gv"})

; consistency
(ki.no- :Y [n] "y$")
(ki.no- :U [n] "<c-r>")

; fixes
(ki.no- :<c-j> [n] "J")

; ------------------------------------
; --            colemak             --
; ------------  --/-<@  --------------

; skip operator mode to keep the semantics of "i" intact, e.g ciw
(ki.no- [nv]
  {:i "l"
   :l "i"})

(ki.no- [nvo]
  {:L "I" :k "n"
   :K "N" :j "f"
   :J "F" :f "e"
   :F "E"})
