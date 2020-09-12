set laststatus=0
set encoding=utf-8
set nocompatible
set ttyfast
set synmaxcol=256
set t_Co=256
set termguicolors

set ignorecase " case-insensitive search

set readonly
syntax enable

set syntax=man

" keybinds
cabbrev q q!
nmap q :q<CR>
nnoremap i <Nop>
nnoremap // :noh<return>

let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_italicize_comments = '1'
let g:gruvbox_italic = '1'
let g:gruvbox_bold = '0'

set runtimepath+=~/.vim/bundle/gruvbox
colorscheme gruvbox

" nvim <(man man) -u ...
" man man | nvim -u ...
" the second one is faster i think
