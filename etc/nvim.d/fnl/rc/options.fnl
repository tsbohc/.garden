(import-macros
  {:opt-set     s:=
   :opt-get     s:?
   :opt-append  s:+
   :opt-prepend s:^
   :opt-remove  s:-} :zest.macros)

; colors
(vim.cmd ":syntax enable")
(vim.cmd ":colo limestone")

; rendering
(s:= encoding "utf-8")
(s:= synmaxcol 256)
(s:= termguicolors)

; ui
(s:= number)
(s:= relativenumber)
(s:= cursorline)
(s:= showmatch)
(s:= matchtime 2)
(s:+ shortmess "IcT")

; behaviour
(s:= scrolloff 10)
(s:= wrap false)
(s:= virtualedit "block")
(s:= undofile)
(s:= autoread)
(s:= clipboard "unnamedplus") ; don't forget xsel!
(s:= mouse "a")
(s:+ completeopt ["menuone" "noselect"])

; status lines
(s:= showmode false)
(s:= laststatus 2)

; search
(s:= incsearch)
(s:= inccommand "nosplit")
(s:= hlsearch)
(s:= ignorecase)
(s:= smartcase)

; folding
(s:= foldenable)
(s:= foldmethod "marker")
;(se- foldtext "v:lua.folding()"

; spacing
(s:= tabstop 2)
(s:= shiftwidth 2)
(s:= softtabstop 2)
(s:= expandtab)
;(se- :noshiftround)

; invisibles
(s:= listchars {:trail "␣"})
(s:= list)
;(se- :fillchars "eob:~") ; do not set those to fileseparator etc, trust me
