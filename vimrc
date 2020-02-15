"        .
"  __   __)
" (. | /o ______  __  _.
"    |/<_/ / / <_/ (_(__
"    |

" -------------------------------------------------
"   sources
" -------------------------------------------------

"source ~/blueberry/vim/statusline.vim

" -------------------------------------------------
"   plug
" -------------------------------------------------

" boostrap plug
"if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
"  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
"    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
"endif

if has('nvim')
  call plug#begin('~/.vim/bundle')

  Plug 'Yggdroot/indentline'
  Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
  Plug 'terryma/vim-multiple-cursors', { 'on': [] }
  Plug 'morhetz/gruvbox'
  Plug 'joshdick/onedark.vim'
  Plug 'rakr/vim-two-firewatch'
  Plug 'jnurmine/Zenburn'

  "Plug 'junegunn/goyo.vim'

  augroup load_us_ycm
    autocmd!
    autocmd InsertEnter * call plug#load('vim-multiple-cursors')
      \| autocmd! load_us_ycm
  augroup END

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

" -------------------------------------------------
"   plug specific
" -------------------------------------------------

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
"   status line
" -------------------------------------------------

" should implement a check that looks for a hex value, and if it doesn't find it, grabs term colors
" add cterm check and options

"" cterm color definitions
"" mode name
"hi User1 ctermbg=4 ctermfg=bg cterm=bold
"" mode arrow separator
"hi User2 ctermbg=8 ctermfg=4
"" file name
"hi User3 ctermbg=8 ctermfg=fg
"" gray to black
"hi User4 ctermbg=bg ctermfg=8
"" gray to white
"hi User5 ctermbg=8 ctermfg=fg
"" black on white
"hi User6 ctermbg=fg ctermfg=bg

" settings
let g:currentmode={
    \ 'n'  : 'NORMAL',
    \ 'no' : 'N Operator Pending',
    \ 'v'  : 'VISUAL',
    \ 'V'  : 'VLINE',
    \ '^V' : 'VBLOCK',
    \ 's'  : 'Select',
    \ 'S'  : 'SLine',
    \ '^S' : 'SBlock',
    \ 'i'  : 'INSERT',
    \ 'R'  : 'REPLACE',
    \ 'Rv' : 'VReplace',
    \ 'c'  : 'COMMAND',
    \ 'cv' : 'Vim Ex',
    \ 'ce' : 'Ex',
    \ 'r'  : 'Prompt',
    \ 'rm' : 'More',
    \ 'r?' : 'Confirm',
    \ '!'  : 'Shell',
    \ 't'  : 'Terminal'
    \ }


if system('get_xres font') =~? 'powerline'
 let s:statuslineseparator=""
 let statuslinesfr=""
 let statuslinesfl=""
else
 let s:statuslineseparator="│"
 let statuslinesfr="▒░"
 let statuslinesfl="░▒"
endif

function! SetHighlight(name, fg, bg, bold) " for some reason nvim would complain when doing it w/ one line
  let command = 'hi ' . a:name
  if a:bold == 1
    execute 'hi ' . a:name . ' gui=bold'
  endif
  if a:bg != ''
    execute 'hi ' . a:name . ' guibg=' . a:bg
  endif
  if a:fg != ''
    execute 'hi ' . a:name . ' guifg=' . a:fg
  endif
endfunction

" FIXME something is wrong somewhere and it requires a conversion for some reason
let s:xres_lighter_background=system('get_xres color0')
let s:xres_lighter_background=system('hex_to_rgb ' . s:xres_lighter_background . '')
let s:xres_lighter_background=system('rgb_to_hex ' . s:xres_lighter_background . '')
let s:xres_lighter_background=system('shade_hex ' . s:xres_lighter_background . ' 0.7')
let s:xres_lighter_background='#' . s:xres_lighter_background

" pull colors from xrdb
let s:xres_foreground='#' . system('get_xres foreground')
let s:xres_background='#' . system('get_xres background')
let s:xres_color0=    '#' . system('get_xres color0')
let s:xres_color1=    '#' . system('get_xres color1')
let s:xres_color2=    '#' . system('get_xres color2')
let s:xres_color3=    '#' . system('get_xres color3')
let s:xres_color4=    '#' . system('get_xres color4')
let s:xres_color5=    '#' . system('get_xres color5')
let s:xres_color6=    '#' . system('get_xres color6')
let s:xres_color7=    '#' . system('get_xres color7')
let s:xres_color8=    '#' . system('get_xres color8')
let s:xres_color9=    '#' . system('get_xres color9')
let s:xres_color10=   '#' . system('get_xres color10')
let s:xres_color11=   '#' . system('get_xres color11')
let s:xres_color12=   '#' . system('get_xres color12')
let s:xres_color13=   '#' . system('get_xres color13')
let s:xres_color14=   '#' . system('get_xres color14')
let s:xres_color15=   '#' . system('get_xres color15')

" set define highlights
call SetHighlight("statusline_normal_bg", s:xres_background, s:xres_color12, 1)
call SetHighlight("statusline_normal_separator", s:xres_color12, s:xres_lighter_background, 0)

call SetHighlight("statusline_insert_bg", s:xres_background, s:xres_color10, 1)
call SetHighlight("statusline_insert_separator", s:xres_color10, s:xres_lighter_background, 0)

call SetHighlight("statusline_visual_bg", s:xres_background, s:xres_color11, 1)
call SetHighlight("statusline_visual_separator", s:xres_color11, s:xres_lighter_background, 0)

call SetHighlight("statusline_command_bg", s:xres_background, s:xres_color9, 1)
call SetHighlight("statusline_command_separator", s:xres_color9, s:xres_lighter_background, 0)

call SetHighlight("User3", s:xres_foreground, s:xres_lighter_background, 0)
call SetHighlight("User4", s:xres_lighter_background, s:xres_background, 0)
call SetHighlight("User5", s:xres_foreground, s:xres_lighter_background, 0)
call SetHighlight("User6", s:xres_background, s:xres_foreground, 0)

function! ChangeStatuslineColor()
  if mode() == 'n'
    hi! link User1 statusline_normal_bg
    hi! link User2 statusline_normal_separator
  elseif mode() == 'i'
    hi! link User1 statusline_insert_bg
    hi! link User2 statusline_insert_separator
  elseif (mode() =~# '\v(v|V)' || ModeCurrent() == 'VBLOCK')
    hi! link User1 statusline_visual_bg
    hi! link User2 statusline_visual_separator
  else
    hi! link User1 statusline_command_bg
    hi! link User2 statusline_command_separator
  endif
  redrawstatus
  return ''
endfunction

function! ModeCurrent() abort
  let l:modecurrent = mode()
  " abort -> function will abort soon as error detected
  " use get() -> fails safely, since ^V doesn't seem to register
  " 3rd arg is used when return of mode() == 0, which is case with ^V
  " thus, ^V fails -> returns 0 -> replaced with 'V Block'
  let l:modelist = toupper(get(g:currentmode, l:modecurrent, 'VBLOCK'))
  let l:current_status_mode = l:modelist
  return l:current_status_mode
endfunction

function! StatusLineFileName()
  let full_file_path = expand('%')
  if full_file_path == ''
    let full_file_path = '[new]'
  else
    let full_file_path = fnamemodify(expand('%'), ':~')
  endif
  return strlen(full_file_path) < winwidth(0)*0.55 ? full_file_path : expand('%f')
endfunction

function! StatusLineFileType()
  return &filetype
endfunction

function! StatusLineModified()
  return &modified ? s:statuslineseparator . ' + ' : ''
endfunction

function! StatusLineReadonly()
  return &readonly ? s:statuslineseparator . ' readonly ' : ''
endfunction

set noshowmode
set laststatus=2
set statusline=

" left side
set statusline+=%{ChangeStatuslineColor()}
set statusline+=%1*\ %{ModeCurrent()}\ %2*%{statuslinesfr} " [1]_mode_[2]>
set statusline+=%3*\ %{StatusLineFileName()}\  " [3]_filename_
set statusline+=%{StatusLineReadonly()}
set statusline+=%{StatusLineModified()}
set statusline+=%4*%{statuslinesfr}
" right side
set statusline+=%=
set statusline+=%{StatusLineFileType()} " filetype
set statusline+=\ %4*%{statuslinesfl}%3*\ %p%% " _[4]<[3]_percentage
set statusline+=\ %5*%{statuslinesfl}%6*\ %l:%c\  " _[5]<[6]_line:column_
