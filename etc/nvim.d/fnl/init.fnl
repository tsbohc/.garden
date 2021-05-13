;        .
;  __   __)
; (. | /o ______  __  _.
;    |/<_/ / / <_/ (_(__
;    |
;

(require-macros :zest.macros)

; TODO: check if those are needed
(g- python_host_prog :/usr/bin/python2)
(g- python3_host_prog :/usr/bin/python3)

(local packer (require :packer))

(packer.startup (fn []
  (pa- wbthomason/packer.nvim)

  (pa- /home/sean/code/zest
       :zest (fn []
         (g- :zest#env "/home/sean/.garden/etc/nvim.d/fnl")
         (g- :zest#dev true)))
  (pa- /home/sean/code/limestone)

  (pa- neovim/nvim-lspconfig)
  (pa- nvim-treesitter/nvim-treesitter
       :run ":TSUpdate"
       :zest (fn []
         (let [ts (require :nvim-treesitter.configs)]
           (ts.setup {:highlight {:enable true}}))))

  (pa- hrsh7th/nvim-compe
       :zest (fn []
         (require :plugins.nvim-compe)))

  (pa- rktjmp/lush.nvim)

  ;(pa- morhetz/gruvbox
  ;     :config (fn []
  ;       (g- gruvbox_bold 0)
  ;       (g- gruvbox_contrast_dark :soft)))

  (pa- lervag/vimtex
       :config (fn []
         (g- tex_flavor "latex")
         (g- vimtex_view_method "zathura")
         (g- vimtex_quickfix_mode 0)))

  ; lisp
  (pa- bakpakin/fennel.vim :ft ["fennel"])
  (pa- guns/vim-sexp
       :zest (fn []
         (require :plugins.vim-sexp)))

  (pa- Yggdroot/indentLine
       :config (fn []
         (g- indentLine_setColors 0)
         (g- indentLine_char "·")))

  (pa- tweekmonster/startuptime.vim)
))

(require :rc.options)
(require :rc.keymaps)
