(module settings)

;; okay, THIS is the wacky shit I've always wanted to do
(macro > [option value]
  `(V.set ,option ,value))

;
;; this is an even better idea
;; why -'s though then?
;(o- :number)
;(b- :number)
;(w- :number)

; rendering ;
(> :encoding :utf-8)              ; self-explanatory
; FIXME: why does this even error w/ no- prefix?
;(> :nocompatible)                  ; allow vim -u vimc
(> :synmaxcol 256)                 ; max colums to use highlighting on
(> :termguicolors)                 ; true color support

; ui ;
(> :number)                        ; show ruler
(> :relativenumber)                ; relative ruler
(> :cursorline)                    ; highlight current line
(> :showmatch)                     ; blink matching brace when a new one is inserted
(> :matchtime 2)                   ; blink quicker

; behaviour ;
(> :scrolloff 10)                  ; cursor padding in window
(> :nowrap)                        ; do not wrap at the end of a line TODO: filetype au istext iscode
(> :virtualedit "block")           ; do not restrict v-block to characters

;vim.cmd [[set undofile]]
;(> :undofile                      ; persistent undo/redo

(> :clipboard "unnamedplus")       ; don't forget xsel!
(> :mouse "a")                     ; blasphemy!

; invisibles ;
(> :listchars "trail:␣")
(> :list)
;(> :fillchars "eob:~")             ; do not set those to fileseparator etc, trust me

; search ;
(> :incsearch)                     ; search as characters are typed
(> :inccommand "nosplit")          ; show substitute effects as characters are typed
(> :hlsearch)                      ; highlight matches
(> :ignorecase)                    ; case-insensitive search
(> :smartcase)                     ; case-sensitive if search contains uppercase

; spacing ;
(> :tabstop 2)
(> :shiftwidth 2)
(> :softtabstop 2)
(> :expandtab)
;(> :noshiftround)                  ; round indent to multiples of shiftwidth

; status lines ;
;(> :noshowmode                    ; do not show ; INSERT ;, etc on lastline
(> :laststatus 2)                  ; always show statusline

; folding ;
(> :foldenable)
(> :foldmethod "marker")
;(> :foldtext "v:lua.folding()"
