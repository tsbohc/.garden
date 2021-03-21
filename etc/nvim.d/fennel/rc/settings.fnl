(module rc.settings
  {require {s zest.set}
   require-macros [zest.set-macros]})



; why not this tho?
;(macro s- [o ...]
;  `(z.set ,(tostring o) ...))
;
;(macro n- [modes ...]
;  (let [params [...]
;        rs (table.remove params)
;        ls (table.remove params)]
;    `(do
;       (m.map ,(tostring modes) ,(tostring ls) ,(tostring rs)))))

; rendering ;
(s- encoding "utf-8")              ; self-explanatory
(s- synmaxcol 256)                 ; max colums to use highlighting on
(s- termguicolors)                 ; true color support

; ui ;
(s- number)                        ; show ruler
(s- relativenumber)                ; relative ruler
(s- cursorline)                    ; highlight current line
(s- showmatch)                     ; blink matching brace when a new one is inserted
(s- matchtime 2)                   ; blink quicker
(s- shortmess
    (.. "c" ; completion messages
        "I" ; intro message
        ))

; behaviour ;
(s- scrolloff 10)                  ; cursor padding in window
(s- nowrap)                        ; do not wrap at the end of a line TODO: filetype au istext iscode
(s- virtualedit "block")           ; do not restrict v-block to characters
(s- undofile)                      ; persistent undo/redo
(s- clipboard "unnamedplus")       ; don't forget xsel!
(s- mouse "a")                     ; blasphemy!

; status lines ;
;(s- noshowmode)                    ; do not show -- INSERT --, etc on statusline
(s- laststatus 2)                  ; always show statusline

; folding ;
(s- foldenable)
(s- foldmethod "marker")
;(s- foldtext "v:lua.folding()"

; search ;
(s- incsearch)                     ; search as characters are typed
(s- inccommand "nosplit")          ; show substitute effects as characters are typed
(s- hlsearch)                      ; highlight matches
(s- ignorecase)                    ; case-insensitive search
(s- smartcase)                     ; case-sensitive if search contains uppercase

; spacing ;
(s- tabstop 2)
(s- shiftwidth 2)
(s- softtabstop 2)
(s- expandtab)
;(s- :noshiftround)                  ; round indent to multiples of shiftwidth

; invisibles ;
(s- listchars "trail:␣")
(s- list)
;(s- :fillchars "eob:~")             ; do not set those to fileseparator etc, trust me

; unsorted ;
;(s- compatible false)              ; allow vim -u vimc

