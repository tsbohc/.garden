(macro g- [k v]
  `(tset vim.g ,k ,v))

(macro def-package [name ...]
  (let [xs [...]
        xt [(tostring name)]]
    (each [i v (ipairs xs)]
      (when (= 1 (% i 2))
        (tset xt v (. xs (+ i 1)))))
    `,xt))

(local sexp (require :plug.vim-sexp))
(sexp)

[

(def-package "/home/sean/code/zest")

(def-package "/home/sean/code/limestone"
  :requires ["rktjmp/lush.nvim"])

(def-package "nvim-treesitter/nvim-treesitter"
  :opt true
  :event ["BufRead" "BufWritePost"]
  :branch "0.5-compat"
  :run ":TSUpdate"
  :config (require :plug.nvim-treesitter))

(def-package "jose-elias-alvarez/null-ls.nvim"
  :config (require :plug.null-ls)
  :requires ["nvim-lua/plenary.nvim" "neovim/nvim-lspconfig"])

(def-package "hrsh7th/nvim-compe"
  :opt true
  :event "InsertEnter"
  :config (require :plug.nvim-compe))

(def-package "tweekmonster/startuptime.vim"
  :cmd "StartupTime")

(def-package "bakpakin/fennel.vim"
  :ft ["fennel"])

(def-package "guns/vim-sexp"
  :ft ["fennel"])

(def-package "Yggdroot/indentLine"
  :config (fn []
            (set vim.g.indentLine_setColors 0)
            (set vim.g.indentLine_char "·")
            (set vim.g.indentLine_fileTypeExclude ["markdown"])))
]
