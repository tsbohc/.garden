set nocompatible              " required
filetype off                  " required

" =================================================
" ### vundle ###
" =================================================

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin() " alternatively, pass a path where Vundle should install plugins-- call vundle#begin('~/some/path/here')
Plugin 'gmarik/Vundle.vim'     " required

" plugins
Plugin 'Valloric/YouCompleteMe'
Plugin 'itchyny/lightline.vim'
Plugin 'terryma/vim-multiple-cursors'

call vundle#end()              " required
filetype plugin indent on      " required

" =================================================
" ### status line ###
" =================================================

set noshowmode
set laststatus=2

let g:lightline = {
    \ 'colorscheme': 'jellybeans_lightline',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'readonly', 'filepath', 'modified' ] ],
    \   'right': [ [ 'lineinfo' ],
    \              [ 'percent' ],
    \              [ 'filetype', 'spell' ] ]
    \ },
    \ 'component_function': {
    \   'readonly': 'LightlineReadonly',
    \   'fugitive': 'LightlineFugitive',
    \   'filepath': 'LightlineFilepath'
    \ },
    \ 'separator': { 'left': '', 'right': '' },
    \ 'subseparator': { 'left': '', 'right': '' }
    \ }
 
function! LightlineReadonly()
    return &readonly ? '' : ''
endfunction

function! LightlineFugitive()
    if exists('*fugitive#head')
        let branch = fugitive#head()
        return branch !=# '' ? ''.branch : ''
    endif
    return ''
endfunction

function! LightlineFilepath()
    return winwidth(0) > 80 ? expand('%:p') : expand('%')
endfunction

let g:lightline.mode_map = {
    \ 'n' : 'NORMAL',
    \ 'i' : 'INSERT',
    \ 'R' : 'REPLACE',
    \ 'v' : 'VISUAL',
    \ 'V' : 'VLINE',
    \ "\<C-v>": 'VBLOCK',
    \ 'c' : 'COMMAND',
    \ 's' : 'S',
    \ 'S' : 'SL',
    \ "\<C-s>": 'SB',
    \ 't': 'T',
    \ }

" =================================================
" ### user settings ###
" =================================================

" style
:set t_Co=256
colorscheme jellybeans

" syntax highlighting
syntax on
filetype indent on
set cursorline " current line
set showmatch " matching [{(s
hi MatchParen cterm=bold ctermbg=darkgray ctermfg=white

" line numbers
set number relativenumber
set nu rnu

" rendering
set clipboard=unnamedplus " systemwide clipboard
set encoding=utf-8
set ttyfast

" mode switch delays
set ttimeout
set ttimeoutlen=30
set timeoutlen=3000

" whitespace
set wrap
set formatoptions=tcqrn1
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set noshiftround

" search
set incsearch " search as characters are entered
set hlsearch " highlight matches
set ignorecase
"set smartcase
set showmatch
nnoremap \ :noh<return>

" =================================================
" ### keymaps ###
" =================================================

" hardmode
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
noremap <PageUp> <nop>
noremap <PageDown> <nop>

inoremap <Up> <Nop>
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>
inoremap <PageUp> <nop>
inoremap <PageDown> <nop>

" general
nnoremap j gj
nnoremap k gk
:imap ii <Esc>

" =================================================
" ### vim magic ###
" =================================================

" recompile suckless programs automagically
autocmd BufWritePost config.h,config.def.h !sudo make install

" run xrdb whenever Xdefaults or Xresources are updated
autocmd BufWritePost ~/.Xresources,~/.Xdefaults !xrdb %
