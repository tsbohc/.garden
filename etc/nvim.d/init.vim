"        .
"  __   __)
" (. | /o ______  __  _.
"    |/<_/ / / <_/ (_(__
"    |
"

let g:python_host_prog = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python3'
let g:vimsyn_embed = 'l' " lua highligting in *.vim

lua <<EOF
require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  -- colorschemes
  use 'sainnhe/everforest'

  -- tree-sitter & completion
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'nvim-lua/completion-nvim'
  use 'nvim-treesitter/completion-treesitter'
  use 'steelsojka/completion-buffers'

  -- fennel
  use 'Olical/aniseed'
  use 'Olical/conjure'
  use 'bakpakin/fennel.vim'

  use 'guns/vim-sexp'
  use 'tpope/vim-repeat'
  use 'tpope/vim-surround'

  use 'pigpigyyy/moonplus-vim'

  --use 'Yggdroot/indentLine'
end)

require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained",
  highlight = {
    enable = true,
  },
}
EOF

nnoremap <Space> <Nop>
let maplocalleader=" "

let g:aniseed#env = v:true
"lua require("aniseed.env").init()

" {{{
" sources are pulled separately, switched when previous one returns nothing
let g:completion_chain_complete_list = [
    \{'complete_items': ['ts']},
    \{'complete_items': ['buffers']},
    \{'mode': '<c-p>'},
    \{'mode': '<c-n>'}
\]

let g:completion_auto_change_source = 1

autocmd BufEnter * lua require'completion'.on_attach()

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

"let g:completion_enable_auto_popup = 0

" triggering completion
imap <tab> <Plug>(completion_smart_tab)
imap <s-tab> <Plug>(completion_smart_s_tab)
" }}}


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

set clipboard=unnamedplus
syntax enable
set termguicolors

let g:everforest_background = 'soft'
let g:everforest_enable_italic = 1
let g:everforest_better_performance = 1

colorscheme everforest

" changes to everforest
highlight! link TSConstant Fg
highlight! link TSFuncBuiltin Aqua
highlight! link TSFuncMacro Aqua
highlight! link TSFunction Aqua
highlight! link TSString Green
highlight! link vimTodo Green

"let g:indentLine_char = '│'

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
"

"augroup testgroup
"    autocmd!
"    autocmd BufWrite * :echom "Cats"
"augroup END

" cheat sheet
"(    - jump around

"B    - prev element head
"W    - next element head
"F    - next element tail

"daf  - delete around form
"dif  - delete inside form
"ds   - delete surroundings

"dae  - delete around element
"dae  - delete inside element

"sf(  - surround form and place cursor at the head
"se(  - surround element and place cursor at the head

"<L  - insert in the head of the form
">L  - insert at the tail of the form

">(  - emit from the head
">)  - emit from the tail
"<(  - chomp prev
"<)  - chomp next

">f  - move form forward
"<e  - move element backward

let g:sexp_filetypes = "fennel"
let g:sexp_mappings = {
    \ 'sexp_outer_list':                'af',
    \ 'sexp_inner_list':                'if',
    \ 'sexp_outer_top_list':            'aF',
    \ 'sexp_inner_top_list':            'iF',
    \ 'sexp_outer_string':              '',
    \ 'sexp_inner_string':              '',
    \ 'sexp_outer_element':             'ae',
    \ 'sexp_inner_element':             'ie',
    \ 'sexp_move_to_prev_bracket':      '(',
    \ 'sexp_move_to_next_bracket':      ')',
    \ 'sexp_move_to_prev_element_head': 'B',
    \ 'sexp_move_to_next_element_head': 'W',
    \ 'sexp_move_to_prev_element_tail': 'gF',
    \ 'sexp_move_to_next_element_tail': 'F',
    \ 'sexp_flow_to_prev_close':        '',
    \ 'sexp_flow_to_next_open':         '',
    \ 'sexp_flow_to_prev_open':         '',
    \ 'sexp_flow_to_next_close':        '',
    \ 'sexp_flow_to_prev_leaf_head':    '',
    \ 'sexp_flow_to_next_leaf_head':    '',
    \ 'sexp_flow_to_prev_leaf_tail':    '',
    \ 'sexp_flow_to_next_leaf_tail':    '',
    \ 'sexp_move_to_prev_top_element':  '[[',
    \ 'sexp_move_to_next_top_element':  ']]',
    \ 'sexp_select_prev_element':       '',
    \ 'sexp_select_next_element':       '',
    \ 'sexp_indent':                    '==',
    \ 'sexp_indent_top':                '=-',
    \ 'sexp_round_head_wrap_list':      'sf(',
    \ 'sexp_round_tail_wrap_list':      'sf)',
    \ 'sexp_square_head_wrap_list':     'sf[',
    \ 'sexp_square_tail_wrap_list':     'sf]',
    \ 'sexp_curly_head_wrap_list':      'sf{',
    \ 'sexp_curly_tail_wrap_list':      'sf}',
    \ 'sexp_round_head_wrap_element':   'se(',
    \ 'sexp_round_tail_wrap_element':   'se)',
    \ 'sexp_square_head_wrap_element':  'se[',
    \ 'sexp_square_tail_wrap_element':  'se]',
    \ 'sexp_curly_head_wrap_element':   'se{',
    \ 'sexp_curly_tail_wrap_element':   'se}',
    \ 'sexp_insert_at_list_head':       '<L',
    \ 'sexp_insert_at_list_tail':       '>L',
    \ 'sexp_splice_list':               'ds',
    \ 'sexp_convolute':                 '',
    \ 'sexp_raise_list':                '',
    \ 'sexp_raise_element':             '',
    \ 'sexp_swap_list_backward':        '<f',
    \ 'sexp_swap_list_forward':         '>f',
    \ 'sexp_swap_element_backward':     '<e',
    \ 'sexp_swap_element_forward':      '>e',
    \ 'sexp_emit_head_element':         '>(',
    \ 'sexp_emit_tail_element':         '>)',
    \ 'sexp_capture_prev_element':      '<(',
    \ 'sexp_capture_next_element':      '<)',
    \ }

set autoread
au FocusGained,BufEnter * :checktime

fun! Runcmd(cmd)
    silent! exe "noautocmd botright pedit ".a:cmd
    noautocmd wincmd P
    set buftype=nofile
    exe "noautocmd r! ".a:cmd
    noautocmd wincmd p
endfun
com! -nargs=1 Runcmd :call Runcmd("<args>")

fun! FennelCompile()
  exe "w"
  call Runcmd("fennel --compile " . expand('%:p'))
endfun
com! FennelCompile :call FennelCompile()
nnoremap <c-c> :call FennelCompile()<cr>
