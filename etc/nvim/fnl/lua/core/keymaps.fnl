(import-macros {:def-keymap       ki-
                :def-keymap-pairs kp-} :zest.lime.macros)

(tset vim.g :mapleader " ")

; -  land of opinionated navigation  -
; ------------  --/-<@  --------------

; smart v-line movement
(ki- [nv :expr] :e [(if (> vim.v.count 0) "k" "gk")])
(ki- [nv :expr] :n [(if (> vim.v.count 0) "j" "gj")])
(kp- [o] {:e "k" :n "j"})

; screen and line movement
(kp- [nv] {:N "<c-d>"
           :E "<c-u>"
           :H "0"
           :I "$"})

; mousewheel blasphemy
(kp- [nv]
  {:<ScrollWheelUp>   "<c-y>"
   :<ScrollWheelDown> "<c-e>"})

; split movement
(kp- [n] {:<c-h> "<c-w>h"
          :<c-n> "<c-w>j"
          :<c-e> "<c-w>k"
          :<c-i> "<c-w>l"})

; -       search and replace         -
; ------------  --/-<@  --------------

; easy :nohl
(ki- [nv :silent] :// ":nohlsearch<cr>")

; keep cursor in place when norm! *
(ki- [n] :*
  [(let [p (vim.fn.getpos ".")]
     (vim.cmd "norm! *")
     (vim.fn.setpos "." p))])

; search for selected text
(ki- [x] :*
  [(let [p (vim.fn.getpos ".")]
     (vim.cmd "norm! gvy")
     (vim.cmd (.. "/" (vim.api.nvim_eval "@\"")))
     (vim.fn.setpos "." p))])

; replace search matches
(ki- [n] :<leader>r ":%s///g<left><left>")
(ki- [x] :<leader>r ":s///g<left><left>")

; -              misc                -
; ------------  --/-<@  --------------

; stay in visual mode after indenting
(kp- [x] {:< "<gv" :> ">gv"})

; consistency
(ki- [n] :Y "y$")
(ki- [n] :U "<c-r>")

; fixes
(ki- [n] :<c-j> "J")

; -             colemak              -
; ------------  --/-<@  --------------

(kp- [nvo] {:i "l"
            :L "I" :l "i"
            :K "N" :k "n"
            :J "F" :j "f"
            :F "E" :f "e"})
