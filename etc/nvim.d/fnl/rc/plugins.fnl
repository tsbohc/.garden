(import-macros
  {:packer-use-wrapper p-
   :let-g              g-} :zest.macros)

(fn plugins []
  (p- :wbthomason/packer.nvim)

  (p- :/home/sean/code/zest)

  (let [z (require :zest)]
    (z.setup))

  (p- :/home/sean/code/limestone)
  (p- :morhetz/gruvbox)

  (p- :junegunn/fzf.vim)

  ;(pa- wellle/targets.vim)
  ;(pa- tpope/vim-surround)

  (p- :ggandor/lightspeed.nvim)

  (p- :neovim/nvim-lspconfig)

  (p- :nvim-treesitter/nvim-treesitter
      {:run ":TSUpdate"})
  (let [ts (require :nvim-treesitter.configs)]
    (ts.setup {:highlight {:enable true}}))

  (p- :nvim-treesitter/playground)

  (p- :hrsh7th/nvim-compe)
  (require :plugins.nvim-compe)

  (p- :rktjmp/lush.nvim)

  (p- :lervag/vimtex
      {:config
       (fn []
         (g- tex_flavor "latex")
         (g- vimtex_compiler_latexmk
             {:executable "latexmk"
              :options ["-xelatex"
                        "-file-line-error"
                        "-synctex=1"
                        "-interaction=nonstopmode"]})
         (g- vimtex_view_method "zathura")
         (g- vimtex_quickfix_mode 0)
         (g- tex_conceal ""))})

  ;(p- :folke/which-key.nvim
  ;    {:config
  ;     (fn []
  ;       (let [c (require :which-key)]
  ;         (c.setup {})))})

  ; lisp
  (p- :bakpakin/fennel.vim
      {:ft ["fennel"]})

  (p- :guns/vim-sexp)
  (require :plugins.vim-sexp)

  (p- :Yggdroot/indentLine
      {:config
       (fn []
         (g- indentLine_setColors 0)
         (g- indentLine_char "·")
         (g- indentLine_fileTypeExclude ["markdown"]))})

  (p- :tweekmonster/startuptime.vim))

(let [p (require :packer)]
  (p.startup plugins))
