(import-macros
  {:packer-use-wrapper p-
   :let-g              g-} :zest.macros)

(fn plugins []
  (p- :wbthomason/packer.nvim)

  (p- :Olical/aniseed)
  (p- :/home/sean/code/zest)
  ;(p- :tsbohc/zest.nvim)

  (p- :/home/sean/code/limestone)
  (p- :morhetz/gruvbox)
  (p- :junegunn/fzf.vim)
  ;(pa- wellle/targets.vim)
  ;(pa- tpope/vim-surround)
  ;(p- :ggandor/lightspeed.nvim)
  (p- :neovim/nvim-lspconfig)

  (p- :huyvohcmc/atlas.vim)

  (p- :jose-elias-alvarez/null-ls.nvim
      {:config
       (fn []
         (let [null-ls (require :null-ls)
               lspconfig (require :lspconfig)]
           (null-ls.config {:sources [(null-ls.builtins.diagnostics.shellcheck.with
                                        {:diagnostics_format "#{m}"})]})
           (lspconfig.null-ls.setup {})))
       :requires [:nvim-lua/plenary.nvim :neovim/nvim-lspconfig]})

  (p- :nvim-treesitter/nvim-treesitter
      {:event "BufRead"
       :run ":TSUpdate"
       :config
       (fn []
         (let [ts (require :nvim-treesitter.configs)]
           (ts.setup
             {:highlight {:enable true}})))})

  (p- :nvim-treesitter/playground
      {:after "nvim-treesitter"})

  (p- :hrsh7th/nvim-compe
      {:event "InsertEnter"
       :config (fn [] (require :plugins.nvim-compe))})

  ;(require :plugins.nvim-compe)
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

  ; lisp

  (p- :bakpakin/fennel.vim {:ft ["fennel"]})

  (p- :guns/vim-sexp)
  (require :plugins.vim-sexp)

  ; hmmm
  ;(p- :guns/vim-sexp
  ;    {:ft ["fennel"]
  ;     :event "VimEnter"
  ;     :config (fn [] (require :plugins.vim-sexp))})

  (p- :Yggdroot/indentLine
      {:config
       (fn []
         (g- indentLine_setColors 0)
         (g- indentLine_char "·")
         (g- indentLine_fileTypeExclude ["markdown"]))})

  (p- :tweekmonster/startuptime.vim
      {:cmd "StartupTime"}))

(let [p (require :packer)]
  (p.startup plugins))
