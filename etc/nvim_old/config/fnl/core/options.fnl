(import-macros {:set-option se-} :zest.macros)

; colors
(vim.cmd ":syntax enable")
(vim.cmd ":colo slate")

; rendering
(se- encoding "utf-8")
(se- synmaxcol 256)
(se- termguicolors)

; ui
(se- number)
(se- relativenumber)
(se- cursorline)
(se- colorcolumn :80) ; why
(se- showmatch)
(se- matchtime 2)
(se- [:append] shortmess "IcT")

; behaviour
(se- scrolloff 10)
(se- wrap false)
(se- virtualedit "block")
(se- undofile)
(se- autoread)
(se- clipboard "unnamedplus") ; don't forget xsel!
(se- mouse "a")
(se- completeopt ["menu" "menuone" "noselect"])

; status lines
(se- showmode false)
(se- laststatus 2)

; search
(se- incsearch)
(se- inccommand "nosplit")
(se- hlsearch)
(se- ignorecase)
(se- smartcase)

; folding
(se- foldenable)
(se- foldmethod "marker")
;(se- foldtext "v:lua.folding()"

; spacing
(se- tabstop 2)
(se- shiftwidth 2)
(se- softtabstop 2)
(se- expandtab)

; invisibles
(se- listchars {:trail "␣"})
(se- list)

; disable built-in plugins
(local built-ins
  {:netrw
   :netrwPlugin
   :netrwSettings
   :netrwFileHandlers
   :gzip
   :zip
   :zipPlugin
   :tar
   :tarPlugin
   :getscript
   :getscriptPlugin
   :vimball
   :vimballPlugin
   :2html_plugin
   :logipat
   :rrhelper
   :spellfile_plugin
   :matchit})

(each [_ p (ipairs built-ins)]
  (tset vim.g (.. "loaded_" p) 1))
