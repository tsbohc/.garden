(require-macros :zest.macros)

; colors
(viml- "syntax enable")
(colo- :limestone)

; rendering
(so- encoding "utf-8")
(so- synmaxcol 256)                 ; max colums to use highlighting on
(so- termguicolors)                 ; true color support

; ui
(so- number)
(so- relativenumber)
(so- cursorline)
(so- showmatch)                     ; blink matching brace when a new one is inserted
(so- matchtime 2)                   ; blink quicker
(so- shortmess+ "Ic")               ; disable intro and completion messages

; behaviour
(so- scrolloff 10)
(so- wrap false)
(so- virtualedit "block")           ; do not restrict v-block to characters
(so- undofile)                      ; persistent undo/redo
(so- autoread)                      ; reload when file changes externally
(so- clipboard "unnamedplus")       ; don't forget xsel!
(so- mouse "a")                     ; blasphemy!
(so- completeopt+ ["menuone" "noselect"])

; status lines
(so- showmode false)
(so- laststatus 2)                  ; always show statusline

; search
(so- incsearch)                     ; search as characters are typed
(so- inccommand "nosplit")          ; show substitute effects as characters are typed
(so- hlsearch)                      ; highlight matches
(so- ignorecase)                    ; case-insensitive search
(so- smartcase)                     ; case-sensitive if search contains uppercase

; folding
(so- foldenable)
(so- foldmethod "marker")
;(se- foldtext "v:lua.folding()"

; spacing
(so- tabstop 2)
(so- shiftwidth 4)
(so- softtabstop 2)
(so- expandtab)
;(se- :noshiftround)                  ; round indent to multiples of shiftwidth

; invisibles
(so- listchars {:trail "␣"})
(so- list)
;(se- :fillchars "eob:~")             ; do not set those to fileseparator etc, trust me
