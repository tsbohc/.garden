(import-macros
  {:def-keymap-fn ki.fn-
   :def-keymap    ki.no-} :zest.macros)

(tset vim.g :mapleader " ")

; ------------------------------------
; -- land of opinionated navigation --
; ------------  --/-<@  --------------

; smart v-line movement
(ki.fn- :e [nv :expr] (if (> vim.v.count 0) "k" "gk"))
(ki.fn- :n [nv :expr] (if (> vim.v.count 0) "j" "gj"))
(ki.no- [o] {:e "k" :n "j"})

(local n "m")
(ki.fn- n [nv]
  (print "ya"))

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

; easy :nohl
(ki.no- :// [nv :silent] ":nohlsearch<cr>")

; keep cursor in place when norm! *
(ki.fn- :* [n]
  (let [p (vim.fn.getpos ".")]
    (vim.cmd "norm! *")
    (vim.fn.setpos "." p)))

; search for selected text
(ki.fn- :* [x]
  (let [p (vim.fn.getpos ".")]
    (vim.cmd "norm! gvy")
    (vim.cmd (.. "/" (vim.api.nvim_eval "@\"")))
    (vim.fn.setpos "." p)))

; replace search matches
(ki.no- :<leader>r [n] ":%s///g<left><left>")
(ki.no- :<leader>r [x] ":s///g<left><left>")

; ------------------------------------
; --             misc               --
; ------------  --/-<@  --------------

; stay in visual mode after indenting
(ki.no- [x] {:< "<gv" :> ">gv"})

; consistency
(ki.no- :Y [n] "y$")
(ki.no- :U [n] "<c-r>")

; fixes
(ki.no- :<c-j> [n] "J")

; ------------------------------------
; --            colemak             --
; ------------  --/-<@  --------------

(ki.no- [nvo]
  {:i "l"
   :L "I" :l "i"
   :K "N" :k "n"
   :J "F" :j "f"
   :F "E" :f "e"})
