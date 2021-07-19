(require-macros :zest.macros)
(import-macros {:setoption $} :neozest.macros)

; colors
(viml- "syntax enable")
(colo- :limestone)

; rendering
($ encoding "utf-8")
($ synmaxcol 256)
($ termguicolors)

; ui
($ number)
($ relativenumber)
($ cursorline)
($ showmatch)
($ matchtime 2)
($ shortmess:append "Ic")

; behaviour
($ scrolloff 10)
($ wrap false)
($ virtualedit "block")
($ undofile)
($ autoread)
($ clipboard "unnamedplus") ; don't forget xsel!
($ mouse "a")
($ completeopt:append ["menuone" "noselect"])

; status lines
($ showmode false)
($ laststatus 2)

; search
($ incsearch)
($ inccommand "nosplit")
($ hlsearch)
($ ignorecase)
($ smartcase)

; folding
($ foldenable)
($ foldmethod "marker")
;(se- foldtext "v:lua.folding()"

; spacing
($ tabstop 2)
($ shiftwidth 4)
($ softtabstop 2)
($ expandtab)
;(se- :noshiftround)

; invisibles
($ listchars {:trail "␣"})
($ list)
;(se- :fillchars "eob:~") ; do not set those to fileseparator etc, trust me
