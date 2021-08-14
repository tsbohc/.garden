(import-macros
  {:vlua vlua} :zest.macros)

(set _G.sl {})
(local hl-reset :LineNr)

(var draw-events-set {:BufEnter true :VimEnter true})
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
      (for [i 1 25]
        (tset _G.sl bufnr i "")))
    (tset _G.sl bufnr id (or s ""))))

(local M {})

(fn M.fn [events opts f]
  (set counter (+ counter 1))
  (each [_ k (ipairs events)]
    (tset draw-events-set k true))
  (let [id counter
        t (fn [] (store (format (f) opts) id))]
    (vim.api.nvim_command (.. "au " (table.concat events ",") " * :call " (vlua t) "()"))))

(fn M.st [opts s]
  (set counter (+ counter 1))
  (let [id counter]
    (store (format s opts) id)))

(fn draw []
  (let [bufnr (vim.fn.bufnr)]
    (set vim.wo.statusline (.. "%#" hl-reset "#" (table.concat (. _G.sl bufnr))))))

(fn M.init []
  (var draw-events [])
  (each [k _ (pairs draw-events-set)]
    (table.insert draw-events k))
  (set draw-events (table.concat draw-events ","))
  (local cmd vim.api.nvim_command)
  (cmd "augroup event-statusline")
  (cmd "au!")
  (cmd (.. "au " draw-events " * :call " (vlua draw) "()"))
  (cmd "augroup END"))

M
