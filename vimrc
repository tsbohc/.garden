"        .
"  __   __)
" (. | /o ______  __  _.
"    |/<_/ / / <_/ (_(__
"    |

" -------------------------------------------------
"   plug
" -------------------------------------------------

" boostrap plug
"if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
"  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
"    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
"endif

"
" MOVE FONT CHECK TO STATUSLINE SCRIPT
"
"

if has('nvim')
  call plug#begin('~/.vim/bundle')

  Plug 'junegunn/fzf', { 'do': './install --bin' }
  Plug 'junegunn/fzf.vim'
  Plug 'Yggdroot/indentline'
  Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
  " add npm and yarn to bb
  Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
  "Plug 'terryma/vim-multiple-cursors', { 'on': [] }
  Plug 'morhetz/gruvbox'
  Plug 'joshdick/onedark.vim'
  Plug 'rakr/vim-two-firewatch'
  Plug 'jnurmine/Zenburn'

  "Plug 'junegunn/goyo.vim'

  "augroup load_us_ycm
  "  autocmd!
  "  autocmd InsertEnter * call plug#load('vim-multiple-cursors')
  "    \| autocmd! load_us_ycm
  "augroup END

  call plug#end()
endif

" -------------------------------------------------
"   user settings
" -------------------------------------------------

"let g:UltiSnipsExpandTrigger="<CR>"
"let g:UltiSnipsExpandTrigger="<c-b>"

" rendering
set encoding=utf-8
set nocompatible
set ttyfast
set synmaxcol=256
set t_Co=256
set termguicolors

" mode switch delays
set ttimeout
set ttimeoutlen=30
set timeoutlen=3000

" editor
filetype indent on
set number relativenumber " relative numbers
set cursorline " highlight current line
set showmatch " hl matching [{(s
"hi MatchParen cterm=bold ctermbg=darkgray ctermfg=white

" whitespace
set wrap
set scrolloff=10
set formatoptions=tcqrn1
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set noshiftround

" invisibles
exec "set listchars=trail:␣"
set list

" search
set incsearch " search as characters are entered
set hlsearch " highlight matches
set ignorecase " case-insensitive search
set smartcase " case-sensitive if search contains uppercase
set showmatch
nnoremap // :noh<return>

" clipboard woes, remember xsel
set clipboard+=unnamedplus

" disable new line comment
autocmd FileType * setlocal formatoptions-=cro

" code folding
filetype plugin indent on
set foldenable
set foldmethod=marker
au FileType sh let g:sh_fold_enabled=1
au FileType sh let g:is_bash=1
au FileType sh set foldmethod=syntax
syntax enable

function! MyFoldText() " {{{
  let line = getline(v:foldstart)

  let nucolwidth = &fdc + &number * &numberwidth
  let windowwidth = winwidth(0) - nucolwidth - 3
  let foldedlinecount = v:foldend - v:foldstart

  " expand tabs into spaces
  let onetab = strpart('          ', 0, &tabstop)
  let line = substitute(line, '\t', onetab, 'g')

  let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
  let fillcharcount = windowwidth - len(line) - len(foldedlinecount) - 1
  return line . ' ' . repeat(" ", fillcharcount) . ' ' . foldedlinecount . '  '
endfunction " }}}
set foldtext=MyFoldText()

" -------------------------------------------------
"   plug specific
" -------------------------------------------------

" fzf-vim
nnoremap <C-F> :Files<cr>
vnoremap <C-F> <esc>:Files<cr>
inoremap <C-F> <esc>:Files<cr>

" indent line
let g:indentLine_char = '│'

" gruvbox
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_italicize_comments = '1'
let g:gruvbox_italic = '1'
let g:gruvbox_bold = '0'

" onedark
let g:onedark_color_overrides = {
\ "black": {'gui': '#282c34', 'cterm': '0', 'cterm16': '0' }
\}

try
  " theme : DO NOT REMOVE THIS TAG
colorscheme gruvbox
  catch
  try
    colorscheme termcolors
    catch
  endtry
endtry

" remove fold bg
"highlight Folded guibg=bg
"hi! link Folded User5

" -------------------------------------------------
"   vim magic
" -------------------------------------------------

" write a function that handles swapfiles automagically

" auto-update current buffer if it's been changed from somewhere else
set autoread
augroup autoRead
    autocmd!
    autocmd CursorHold * silent! checktime
augroup END

" auto remake lantern with each edit
autocmd BufWritePost ~/blueberry/lantern.d/* silent! !cd ~/blueberry/lantern.d ; make

" recompile suckless programs automagically
autocmd BufWritePost config.h,config.def.h !sudo make install

" run xrdb whenever Xdefaults or Xresources are updated
autocmd BufWritePost ~/.Xresources,~/.Xdefaults !xrdb %

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

" vi-line movement
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

" -------------------------------------------------
"   filetype specific
" -------------------------------------------------

" python
au FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4

" -------------------------------------------------
"   sources
" -------------------------------------------------

source ~/blueberry/vim/statusline.vim
