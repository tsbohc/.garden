;        .
;  __   __)
; (. | /o ______  __  _.
;    |/<_/ / / <_/ (_(__
;    |
;

(let [z (require :zest)]
  (z.setup
    {:target (vim.fn.resolve (vim.fn.stdpath :config))}))

(import-macros {:let-g g-} :zest.macros)

(g- python_host_prog :/usr/bin/python2)
(g- python3_host_prog :/usr/bin/python3)

(local modules
  [:options
   :keymaps
   :autocmds
   :statusline
   :plugins])

(each [_ m (ipairs modules)]
  (require m))

;(require :misc.love-compe)

; zesty hl?
;(fn hl-link [ls rs]
;  (vim.api.nvim_command (.. "hi! link " ls " " rs)))
