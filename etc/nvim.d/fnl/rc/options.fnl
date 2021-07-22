(require-macros :zest.old-macros)
(import-macros {:set-option so-} :zest.macros)

; colors
(viml- "syntax enable")
(colo- :limestone)

; rendering
(so- encoding "utf-8")
(so- synmaxcol 256)
(so- termguicolors)

; ui
(so- number)
(so- relativenumber)
(so- cursorline)
(so- showmatch)
(so- matchtime 2)
(so- shortmess:append "IcT")

; behaviour
(so- scrolloff 10)
(so- wrap false)
(so- virtualedit "block")
(so- undofile)
(so- autoread)
(so- clipboard "unnamedplus") ; don't forget xsel!
(so- mouse "a")
(so- completeopt:append ["menuone" "noselect"])

; status lines
(so- showmode false)
(so- laststatus 2)

; search
(so- incsearch)
(so- inccommand "nosplit")
(so- hlsearch)
(so- ignorecase)
(so- smartcase)

; folding
(so- foldenable)
(so- foldmethod "marker")
;(se- foldtext "v:lua.folding()"

; spacing
(so- tabstop 2)
(so- shiftwidth 4)
(so- softtabstop 2)
(so- expandtab)
;(se- :noshiftround)

; invisibles
(so- listchars {:trail "␣"})
(so- list)
;(se- :fillchars "eob:~") ; do not set those to fileseparator etc, trust me
