set nocompatible              " required
filetype off                  " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" add all your plugins here (note older versions of Vundle
" used Bundle instead of Plugin)

Plugin 'Valloric/YouCompleteMe'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" required for autoswap.vim
set title titlestring=

" ### user settings ###

" style
:set t_Co=256
colorscheme jellybeans
" set guifont=Monaco:h10 noanti

" powerline colors
" monaco noalias

" syntax highlighting
syntax on
filetype indent on
set showmatch " highlight matching [{(s
set number " show line numbers

" rendering
set clipboard=unnamedplus " systemwide clipboard
set encoding=utf-8
set ttyfast

" whitespace
set wrap
"set textwidth=79
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

" keymaps
nnoremap j gj
nnoremap k gk
:imap ii <Esc>

" powerline
let g:powerline_pycmd="py3"
:set laststatus=2

" ### vim magic ###

" recompile suckless programs automagically
autocmd BufWritePost config.h,config.def.h !sudo make install

" run xrdb whenever Xdefaults or Xresources are updated
autocmd BufWritePost ~/.Xresources,~/.Xdefaults !xrdb %
