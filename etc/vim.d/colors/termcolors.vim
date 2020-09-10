set t_Co=16
set notermguicolors

highlight clear
if exists("syntax_on")
  syntax reset
endif

set background=dark
let colors_name="termcolors"

"hi Function     ctermfg=2

hi Comment      ctermfg=8
hi Whitespace   ctermfg=8

" ui
hi LineNR       ctermfg=8
hi CursorLineNr ctermfg=11
hi CursorLine   ctermfg=NONE ctermbg=0     cterm=NONE
