"        .
"  __   __)
" (. | /o ______  __  _.
"    |/<_/ / / <_/ (_(__
"    |
"

"let g:zest#env = "/home/sean/.garden/etc/nvim.d/fnl"
"let g:zest#dev = 1

" squeezes multiple blank lines into 1 blank line
" :%s/\(\n\n\)\n\+/\1/

" remove trailing whitespaces
" Remap for destroying trailing whitespace cleanly
":nnoremap <Leader>w :let _save_pos=getpos(".") <Bar>
"    \ :let _s=@/ <Bar>
"    \ :%s/\s\+$//e <Bar>
"    \ :let @/=_s <Bar>
"    \ :nohl <Bar>
"    \ :unlet _s<Bar>
"    \ :call setpos('.', _save_pos)<Bar>
"    \ :unlet _save_pos<CR><CR>

"syntax include @sh syntax/sh.vim
"syntax region snipSh start="\[\[" end="\]\]" contains=@sh
"hi link Snip SpecialComment

augroup testgroup
  autocmd!
  autocmd BufRead *.fnl :set lispwords+=when-not,ecs
  "autocmd BufRead *.fnl :syntax keyword TSString arst
augroup END

"augroup zest
"    autocmd!
"    autocmd BufReadPost * :echo "wooo"
"augroup END
"
"augroup zest
"    autocmd BufReadPost * :echo "waaah"
"augroup END

"hi LspDiagnosticsVirtualTextError guifg=red gui=bold,italic,underline
"hi LspDiagnosticsVirtualTextWarning guifg=orange gui=bold,italic,underline
"hi LspDiagnosticsVirtualTextInformation guifg=yellow gui=bold,italic,underline
"hi LspDiagnosticsVirtualTextHint guifg=green gui=bold,italic,underline

"syntax enable

"let g:signify_sign_add               = '›'
"let g:signify_sign_delete            = '×'
"let g:signify_sign_delete_first_line = '×'
"let g:signify_sign_change            = '·'
"let g:signify_sign_change_delete     = '·'
"
"let g:signify_sign_show_count = 0
"let g:signify_sign_show_text = 0

" {{{
"nnoremap n j
"vnoremap n j
"onoremap n j
"
"nnoremap N J
"vnoremap N J
"onoremap N J
"
"nnoremap e k
"vnoremap e k
"onoremap e k
"
"nnoremap E K
"vnoremap E K
"onoremap E K
"
"nnoremap i l
"vnoremap i l
"onoremap i l
"
"nnoremap I L
"vnoremap I L
"onoremap I L
"
"nnoremap l i
"vnoremap l i
"onoremap l i
"
"nnoremap L I
"vnoremap L I
"onoremap L I
"
"nnoremap k n
"vnoremap k n
"onoremap k n
"
"nnoremap K N
"vnoremap K N
"onoremap K N
"
"nnoremap j f
"vnoremap j f
"onoremap j f
"
"nnoremap J F
"vnoremap J F
"onoremap J F
"
"nnoremap f e
"vnoremap f e
"onoremap f e
"
"nnoremap F E
"vnoremap F E
"onoremap F E
"
"
"nnoremap <expr> N '<c-d>'
"vnoremap <expr> N '<c-d>'
"
"nnoremap <expr> E '<c-u>'
"vnoremap <expr> E '<c-u>'
"
"nnoremap <expr> U '<c-r>'
"vnoremap <expr> U '<c-r>'
"
"
""get join lines back
"nnoremap <c-j> J
""nnoremap <c-e> K
"
"nnoremap <c-h> <c-w>h
"nnoremap <c-n> <c-w>j
"nnoremap <c-e> <c-w>k
"nnoremap <c-i> <c-w>l
"" }}}

func! GodotSettings() abort
  set tabstop=4 shiftwidth=4 expandtab
  nnoremap <buffer> <F4> :GodotRunLast<CR>
  nnoremap <buffer> <F5> :GodotRun<CR>
  nnoremap <buffer> <F6> :GodotRunCurrent<CR>
  nnoremap <buffer> <F7> :GodotRunFZF<CR>
endfunc
augroup godot | au!
    au FileType gdscript call GodotSettings()
augroup end

map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

au FocusGained,BufEnter * :checktime

fun! Runcmd(cmd)
  silent! exe "topleft vertical pedit previewwindow ".a:cmd
  noautocmd wincmd P
  set buftype=nofile
  exe "noautocmd r! ".a:cmd
  noautocmd wincmd p
endfun
com! -nargs=1 Runcmd :call Runcmd("<args>")

fun! MyRun()
  exe "w"
  ":silent call Runcmd("lua " . expand('%:p'))
  :silent call Runcmd("fennel --correlate --add-fennel-path '/home/sean/code/zest/fnl/?.fnl' --metadata " . expand('%:p'))
  " FIXME: this bug is completely retarded
  "exe "colo limestone"
endfun

fun! Zct()
  exe "w"
  :silent call Runcmd("fennel --compile --add-fennel-path '/home/sean/code/zest/fnl/?.fnl' --metadata " . expand('%:p'))
endfun

fun! LoveRun()
    execute "silent !fennel --compile main.fnl > main.lua"
    execute "silent !love ."
endfun

"com! MyRun :call MyRun()
nnoremap <c-c> :call MyRun()<cr>
nnoremap <c-t> :call Zct()<cr>
nnoremap <c-l> :call LoveRun()<cr>

"function SetLovePrefs()
"  setlocal dictionary+=~/.garden/etc/nvim.d/love-dict/love.dict
"  "setlocal iskeyword+=.
"endfunction
"
"augroup love
"    au!
"    autocmd FileType fnl call SetLovePrefs()
"augroup END

" * while visual to search selected text
"function! s:VisualStarSearch(search_cmd)
"  let l:tmp = @"
"  normal! gvy
"  let @/ = '\V' . substitute(escape(@", a:search_cmd . '\'), '\n', '\\n', 'g')
"  let @" = l:tmp
"endfunction
"xmap * :<c-u>call <SID>VisualStarSearch('/')<CR>n<c-o>
"
"nnoremap * *<c-o>

hi link StatusLine LineNr
set laststatus=2
set statusline=%#Normal#
set statusline+=%f
set statusline+=\ 
set statusline+=%m
set statusline+=\ 
set statusline+=%r
set statusline+=\ 
set statusline+=%=%<
set statusline+=%F
set statusline+=\ 
set statusline+=%y
set statusline+=\ 
set statusline+=%P

lua require('init')



"--require'nvim-treesitter.configs'.setup {
"--  --ensure_installed = "maintained",
"--  highlight = {
"--    enable = true,
"--  },
"--}
"
"--require'lspconfig'.gdscript.setup{}
"
"--vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with( vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false, underline = true, signs = true, } ) 
"--vim.cmd [[autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()]] 
"--vim.cmd [[autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help()]]
