(require-macros :zest.macros)

(local packer (require :packer))
(packer.startup (fn []
  (pa- wbthomason/packer.nvim)

  (pa- /home/sean/code/zest)
  ;(pa- /home/sean/code/test)
  (pa- /home/sean/code/limestone)

  (pa- junegunn/fzf.vim)

  ;(pa- wellle/targets.vim)
  ;(pa- tpope/vim-surround)

  (pa- neovim/nvim-lspconfig)
  (pa- nvim-treesitter/nvim-treesitter
       :run ":TSUpdate"
       :zest (fn []
         (let [ts (require :nvim-treesitter.configs)]
           (ts.setup {:highlight {:enable true}}))))

  (pa- nvim-treesitter/playground)

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
         (g- vimtex_compiler_latexmk
             {:executable "latexmk"
              :options ["-xelatex"
                        "-file-line-error"
                        "-synctex=1"
                        "-interaction=nonstopmode"]})
         (g- vimtex_view_method "zathura")
         (g- vimtex_quickfix_mode 0)
         (g- tex_conceal "")))

  (pa- folke/which-key.nvim
       :config (fn []
         (let [c (require :which-key)]
           (c.setup {}))))

  ; lisp
  (pa- bakpakin/fennel.vim :ft ["fennel"])
  (pa- guns/vim-sexp
       :zest (fn []
         (require :plugins.vim-sexp)))

  (pa- Yggdroot/indentLine
       :config (fn []
         (g- indentLine_setColors 0)
         (g- indentLine_char "·")
         (g- indentLine_fileTypeExclude ["markdown"])))

  (pa- tweekmonster/startuptime.vim)
))
