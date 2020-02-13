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

let s:statuslineseparator=""
let statuslinesfr=""
let statuslinesfl=""

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
let g:xres_lighter_background=system('get_xres color0')
let g:xres_lighter_background=system('hex_to_rgb ' . g:xres_lighter_background . '')
let g:xres_lighter_background=system('rgb_to_hex ' . g:xres_lighter_background . '')
let g:xres_lighter_background=system('shade_hex ' . g:xres_lighter_background . ' 0.7')
let g:xres_lighter_background='#' . g:xres_lighter_background

" pull colors from xrdb
let g:xres_foreground='#' . system('get_xres foreground')
let g:xres_background='#' . system('get_xres background')
let g:xres_color0=    '#' . system('get_xres color0')
let g:xres_color1=    '#' . system('get_xres color1')
let g:xres_color2=    '#' . system('get_xres color2')
let g:xres_color3=    '#' . system('get_xres color3')
let g:xres_color4=    '#' . system('get_xres color4')
let g:xres_color5=    '#' . system('get_xres color5')
let g:xres_color6=    '#' . system('get_xres color6')
let g:xres_color7=    '#' . system('get_xres color7')
let g:xres_color8=    '#' . system('get_xres color8')
let g:xres_color9=    '#' . system('get_xres color9')
let g:xres_color10=   '#' . system('get_xres color10')
let g:xres_color11=   '#' . system('get_xres color11')
let g:xres_color12=   '#' . system('get_xres color12')
let g:xres_color13=   '#' . system('get_xres color13')
let g:xres_color14=   '#' . system('get_xres color14')
let g:xres_color15=   '#' . system('get_xres color15')

" set define highlights
call SetHighlight("statusline_normal_bg", g:xres_background, g:xres_color12, 1)
call SetHighlight("statusline_normal_separator", g:xres_color12, g:xres_lighter_background, 0)

call SetHighlight("statusline_insert_bg", g:xres_background, g:xres_color10, 1)
call SetHighlight("statusline_insert_separator", g:xres_color10, g:xres_lighter_background, 0)

call SetHighlight("statusline_visual_bg", g:xres_background, g:xres_color11, 1)
call SetHighlight("statusline_visual_separator", g:xres_color11, g:xres_lighter_background, 0)

call SetHighlight("statusline_command_bg", g:xres_background, g:xres_color9, 1)
call SetHighlight("statusline_command_separator", g:xres_color9, g:xres_lighter_background, 0)

call SetHighlight("User3", g:xres_foreground, g:xres_lighter_background, 0)
call SetHighlight("User4", g:xres_lighter_background, g:xres_background, 0)
call SetHighlight("User5", g:xres_foreground, g:xres_lighter_background, 0)
call SetHighlight("User6", g:xres_background, g:xres_foreground, 0)

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
