(import-macros
  {:set-option     so-
   :def-augroup    au.gr-
   :def-autocmd    au.no-
   :def-autocmd-fn au.fn-
   :v-lua          v-lua} :zest.macros)

(set _G.sl {})
(local hl-reset :LineNr)

(var draw-events-set {:BufEnter true})
(var counter 0)

(fn format [s options]
  (var o (or s ""))
  (when (and options (not= o ""))
    (set o (.. (: " " :rep (. options 3)) o))
    (set o (.. o (: " " :rep (. options 4))))
    (when (. options 5)
      (set o (.. "%#" (. options 5) "#" o "%#" hl-reset "#")))
    (set o (.. (: " " :rep (. options 1)) o))
    (set o (.. o (: " " :rep (. options 2)))))
  o)

(fn store [s id]
  (let [bufnr (vim.fn.bufnr)]
    (when (not (. _G.sl bufnr))
      (tset _G.sl bufnr {})
      (for [i 1 10]
        (tset _G.sl bufnr i "")))
    (tset _G.sl bufnr id (or s ""))))

(fn def-sl-fn [events opts f]
  (set counter (+ counter 1))
  (each [_ k (ipairs events)]
    (tset draw-events-set k true))
  (let [id counter
        t (fn [] (store (format (f) opts) id))]
    (vim.api.nvim_command (.. "au " (table.concat events ",") " * :call " (v-lua t) "()"))))

(fn def-sl [opts s]
  (set counter (+ counter 1))
  (let [id counter]
    (store (format s opts) id)))

; statusline config

(def-sl-fn [:BufEnter] [0 0 1 1 :CursorLine]
  (fn [] (let [fname (vim.fn.expand "%:t")]
           (if (not= fname "")
             (.. "‹‹ " fname " ››")
             " ‹ new › "))))

(def-sl-fn [:BufEnter :BufWritePost] [1 0 0 0]
  (fn [] (if (not= (vim.fn.expand "%:t") "")
           "%{&modified?'':'saved'}")))

(def-sl-fn [:BufEnter] [1 0 1 1 :Search]
  (fn [] (when vim.bo.readonly "readonly")))

(def-sl [0 0 0 0] "%=%<")

(def-sl-fn [:BufEnter :BufWritePost] [1 0 0 0]
  (fn [] (vim.fn.expand "%:p:~:h")))

(def-sl-fn [:BufReadPost :BufWritePost] [1 0 0 0]
  (fn [] vim.bo.filetype))

(def-sl [1 0 1 1 :CursorLine] "%2p%%")

; set up draw autocmd

(var draw-events [])
(each [k _ (pairs draw-events-set)]
  (table.insert draw-events k))
(set draw-events (table.concat draw-events ","))

(fn draw []
  (let [bufnr (vim.fn.bufnr)]
    (set vim.wo.statusline (.. "%#" hl-reset "#" (table.concat (. _G.sl bufnr))))))

(local cmd vim.api.nvim_command)
(cmd "augroup event-statusline")
(cmd "au!")
(cmd (.. "au " draw-events " * :call " (v-lua draw) "()"))
(cmd "augroup END")
