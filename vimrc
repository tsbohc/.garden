"        .
"  __   __)            
" (. | /o ______  __  _.
"    |/<_/ / / <_/ (_(__
"    |                  

" -------------------------------------------------
"   plug
" -------------------------------------------------

if has('nvim')
    call plug#begin('~/.vim/bundle')

    Plug 'itchyny/lightline.vim', { 'do': 'ln -s ~/blueberry/vim/jellybeans_lightline.vim ~/.vim/bundle/lightline.vim/autoload/lightline/colorscheme/jellybeans_lightline.vim' }
    Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
    Plug 'terryma/vim-multiple-cursors', { 'on': [] }

    augroup load_us_ycm
        autocmd!
        autocmd InsertEnter * call plug#load('vim-multiple-cursors')
                    \| autocmd! load_us_ycm
    augroup END

    call plug#end()
endif

" -------------------------------------------------
"   status line
" -------------------------------------------------

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
    return &readonly ? 'readonly' : ''
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

" -------------------------------------------------
"   user settings
" -------------------------------------------------

" style
set t_Co=256
set synmaxcol=256
colorscheme jellybeans

" syntax highlighting
syntax on
filetype indent on
set cursorline " current line
set showmatch " matching [{(s
hi MatchParen cterm=bold ctermbg=darkgray ctermfg=white

" invisibles
"set list
"set listchars=
"set listchars+=tab:|

" line numbers
set number relativenumber

" rendering
set encoding=utf-8
set ttyfast

" mode switch delays
set ttimeout
set ttimeoutlen=30
set timeoutlen=3000

" whitespace
set wrap
set scrolloff=10
set formatoptions=tcqrn1
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set noshiftround

" search
set incsearch " search as characters are entered
set hlsearch " highlight matches
set ignorecase " case-insensitive search
set smartcase " case-sensitive if search contains uppercase
set showmatch
nnoremap \ :noh<return>

" clipboard woes, default vim
set clipboard=unnamedplus " systemwide
vmap <leader>y :w! /tmp/vitmp<CR>
nmap <leader>p :r! cat /tmp/vitmp<CR>

" -------------------------------------------------
"   filetype specifics
" -------------------------------------------------

" python
au FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4

" -------------------------------------------------
"   keymaps
" -------------------------------------------------

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

" -------------------------------------------------
"   vim magic
" -------------------------------------------------

" recompile suckless programs automagically
autocmd BufWritePost config.h,config.def.h !sudo make install

" run xrdb whenever Xdefaults or Xresources are updated
autocmd BufWritePost ~/.Xresources,~/.Xdefaults !xrdb %
