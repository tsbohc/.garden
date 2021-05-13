"        .
"  __   __)
" (. | /o ______  __  _.
"    |/<_/ / / <_/ (_(__
"    |
"

" {{{
" {{{
"let g:python_host_prog = '/usr/bin/python2'
"let g:python3_host_prog = '/usr/bin/python3'
"let g:vimsyn_embed = 'l' " lua highligting in *.vim

"lua <<EOF
"----require('packer').startup(function()
"----  use 'wbthomason/packer.nvim'
"----
"----  -- colorschemes
"----  --use 'sainnhe/everforest'
"----  --use 'morhetz/gruvbox'
"----  --use 'franbach/miramare'
"----  --use 'axvr/photon.vim'
"----  --use 'cideM/yui'
"----  --use 'davidosomething/vim-colors-meh'
"----  --use 'sainnhe/sonokai'
"----  --use 'hardselius/warlock'
"----  --use 'arcticicestudio/nord-vim'
"----  --use 'danishprakash/vim-yami'
"----  --use 'huyvohcmc/atlas.vim'
"----  --use 'nikolvs/vim-sunbather'
"----  --use 'arzg/vim-substrata'
"----
"----  -- 'tsbohc/zest'
"----  --use '~/code/zest'
"----  --use '~/code/limestone'
"----  --use 'tsbohc/limestone'
"----  -- use 'jaredgorski/fogbell.vim' -- too much contrast, little distinction
"----
"----  -- colodev
"----  use 'rktjmp/lush.nvim'
"----
"----  -- lsp
"----  use 'neovim/nvim-lspconfig'
"----
"----  -- tree-sitter
"----  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
"----  use 'nvim-treesitter/playground'
"----
"----  -- telescope
"----  --use {
"----  --  'nvim-telescope/telescope.nvim',
"----  --  requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
"----  --}
"----
"----  use 'tweekmonster/startuptime.vim'
"----
"----  use 'junegunn/fzf.vim'
"----
"----  -- completion
"----  use 'hrsh7th/nvim-compe'
"----  --use 'nvim-lua/completion-nvim'
"----  --use 'nvim-treesitter/completion-treesitter'
"----  --use 'steelsojka/completion-buffers'
"----
"----  -- fennel
"----  use 'bakpakin/fennel.vim'
"----
"----  -- customize?
"----  --use { 'eraserhd/parinfer-rust', run = "cargo build --release" }
"----
"----  use 'guns/vim-sexp'
"----  use 'tpope/vim-repeat'
"----  use 'tpope/vim-surround'
"----
"----  --use 'neoclide/coc.nvim'
"----  --use 'andymass/vim-matchup'
"----
"----  -- moonscript
"----  --use 'pigpigyyy/moonplus-vim'
"----  --use 'leafo/moonscript-vim'
"----  --use 'pigpigyyy/yuescript-vim'
"----
"----  -- latex
"----  --use 'lervag/vimtex'
"----
"----  -- nim
"----  --use 'SirVer/ultisnips'
"----  --use 'honza/vim-snippets'
"----
"----  --use 'habamax/vim-godot'
"----
"----  --use 'airblade/vim-gitgutter'
"----  --use 'mhinz/vim-signify'
"----
"----  --use 'cespare/vim-toml'
"----  use 'Yggdroot/indentLine'
"----end)
"--
"--require'nvim-treesitter.configs'.setup {
"--  --ensure_installed = "maintained",
"--  highlight = {
"--    enable = true,
"--  },
"--}
"--
"--require'lspconfig'.gdscript.setup{}
"--
"--require'compe'.setup {
"--  enabled = true;
"--  autocomplete = true;
"--  debug = false;
"--  min_length = 1;
"--  preselect = 'enable';
"--  throttle_time = 80;
"--  source_timeout = 200;
"--  incomplete_delay = 400;
"--  max_abbr_width = 100;
"--  max_kind_width = 100;
"--  max_menu_width = 100;
"--  documentation = true;
"--
"--  source = {
"--    path = true;
"--    buffer = true;
"--    nvim_lsp = true;
"--    calc = true;
"--    --nvim_lua = true;
"--    ultisnips = true;
"--    nvim_treesitter = true;
"--  };
"--}
"--
"--local t = function(str)
"--  return vim.api.nvim_replace_termcodes(str, true, true, true)
"--end
"--
"--local check_back_space = function()
"--    local col = vim.fn.col('.') - 1
"--    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
"--        return true
"--    else
"--        return false
"--    end
"--end
"--
"---- Use (s-)tab to:
"----- move to prev/next item in completion menuone
"----- jump to prev/next snippet's placeholder
"--_G.tab_complete = function()
"--  if vim.fn.pumvisible() == 1 then
"--    return t "<C-n>"
"--  elseif vim.api.nvim_eval([[ UltiSnips#CanJumpForwards() ]]) == 1 then
"--    return t "<cmd>call UltiSnips#JumpForwards()<CR>"
"--  else
"--    return t "<Tab>"
"--  end
"--end
"--_G.s_tab_complete = function()
"--  if vim.fn.pumvisible() == 1 then
"--    return t "<C-p>"
"--  elseif vim.api.nvim_eval([[ UltiSnips#CanJumpBackwards() ]]) == 1 then
"--    return t "<cmd>call UltiSnips#JumpBackwards()<CR>"
"--  --elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
"--  --  return t "<Plug>(vsnip-jump-prev)"
"--  else
"--    return t "<S-Tab>"
"--  end
"--end
"--_G.enter_with_snippets = function()
"--  local autocompleteOpen = vim.fn.pumvisible() == 1
"--
"--  if vim.api.nvim_eval([[ UltiSnips#CanExpandSnippet() ]]) == 1 then
"--    if autocompleteOpen then
"--      vim.fn['compe#close']('<C-e>')
"--    end
"--    return t "<cmd>call UltiSnips#ExpandSnippet()<CR>"
"--  else
"--    return vim.fn['compe#confirm']("\n")
"--  end
"--end
"--
"--vim.api.nvim_set_keymap("i", "<CR>", "v:lua.enter_with_snippets()", {expr = true, silent = true, noremap = true})
"--vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
"--vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
"--vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
"--vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
"--
"--vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with( vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false, underline = true, signs = true, } ) 
"--vim.cmd [[autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()]] 
"--vim.cmd [[autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help()]]
"--
"---- telescope
"--require('telescope').setup{
"--  defaults = {
"--    vimgrep_arguments = {
"--      'rg',
"--      '--color=never',
"--      '--no-heading',
"--      '--with-filename',
"--      '--line-number',
"--      '--column',
"--      '--smart-case'
"--    },
"--    prompt_position = "bottom",
"--    prompt_prefix = "> ",
"--    selection_caret = "> ",
"--    entry_prefix = "  ",
"--    initial_mode = "insert",
"--    selection_strategy = "reset",
"--    sorting_strategy = "descending",
"--    layout_strategy = "vertical",
"--    layout_defaults = {
"--      horizontal = {
"--        mirror = false,
"--      },
"--      vertical = {
"--        mirror = false,
"--      },
"--    },
"--    file_sorter =  require'telescope.sorters'.get_fuzzy_file,
"--    file_ignore_patterns = {},
"--    generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
"--    shorten_path = true,
"--    winblend = 0,
"--    width = 0.75,
"--    preview_cutoff = 120,
"--    results_height = 0.4,
"--    results_width = 0.8,
"--    border = {},
"--    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
"--    color_devicons = true,
"--    use_less = true,
"--    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
"--    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
"--    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
"--    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
"--
"--    -- Developer configurations: Not meant for general override
"--    buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker
"--  }
"--}
"--
"--
"--EOF
"}}}

"nnoremap <SPACE> <Nop>
"let mapleader=" "

"nnoremap <leader>ts :lua require'telescope.builtin'.treesitter{}<cr>

"let g:tex_flavor = 'latex'
"let g:vimtex_view_method = 'zathura'
"let g:vimtex_quickfix_mode = 0

" req by nvim-compe
"set completeopt=menuone,noselect
"inoremap <silent><expr> <C-Space> compe#complete()
"inoremap <silent><expr> <CR>      compe#confirm('<CR>')
"inoremap <silent><expr> <C-e>     compe#close('<C-e>')
"inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
"inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

"nnoremap <silent>S     <cmd>lua vim.lsp.buf.hover()<CR>

"let g:aniseed#env = v:true
"lua require("aniseed.env").init()


" {{{
"" sources are pulled separately, switched when previous one returns nothing
"let g:completion_chain_complete_list = [
"    \{'complete_items': ['lsp']},
"    \{'complete_items': ['UltiSnips']},
"    \{'complete_items': ['ts']},
"    \{'complete_items': ['buffers']},
"    \{'mode': '<c-p>'},
"    \{'mode': '<c-n>'}
"\]
"
"let g:completion_auto_change_source = 1
"
"autocmd BufEnter * lua require'completion'.on_attach()
"
"" Use <Tab> and <S-Tab> to navigate through popup menu
"inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
"inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
"
"" Set completeopt to have a better completion experience
"set completeopt=menuone,noinsert,noselect
"
""let g:completion_enable_auto_popup = 0
"
"" triggering completion
"imap <tab> <Plug>(completion_smart_tab)
"imap <s-tab> <Plug>(completion_smart_s_tab)
"
"let g:completion_enable_snippet = 'UltiSnips'
" }}}

" breaks nvim-compe setup?
"let g:UltiSnipsExpandTrigger="<c-cr>"
"let g:UltiSnipsJumpForwardTrigger="<c-tab>"
"let g:UltiSnipsJumpBackwardTrigger="<c-s-tab>"


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
" }}}

augroup testgroup
  autocmd!
  autocmd BufRead *.fnl :set lispwords+=when-not
  "autocmd BufRead *.fnl :syntax keyword TSString arst
augroup END


hi LspDiagnosticsVirtualTextError guifg=red gui=bold,italic,underline
hi LspDiagnosticsVirtualTextWarning guifg=orange gui=bold,italic,underline
hi LspDiagnosticsVirtualTextInformation guifg=yellow gui=bold,italic,underline
hi LspDiagnosticsVirtualTextHint guifg=green gui=bold,italic,underline

"set clipboard=unnamedplus
syntax enable
"set termguicolors

"let g:everforest_background = 'soft'
"let g:everforest_enable_italic = 1
"let g:everforest_better_performance = 1
"
"let g:gruvbox_bold = 0
"let g:gruvbox_contrast_dark = "soft"
"
"let g:miramare_enable_bold = 0

"colorscheme limestone

"lua package.loaded['colo'] = nil
"lua require('lush')(require('colo'))


"let g:indentLine_setColors = 0 "do not override Conceal hl group
"let g:indentLine_char = "·"


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

" {{{
"fun! Everf()
"  " changes to everforest
"  highlight! link TSConstant Fg
"  highlight! link TSFuncBuiltin Aqua
"  highlight! link TSFuncMacro Aqua
"  highlight! link TSFunction Aqua
"  highlight! link TSString Green
"  "highlight! link TSPunctSpecial Yellow
"  highlight! link vimTodo Green
"endfun
"
"augroup everforest_changes
"    autocmd!
"    autocmd BufRead,BufNewFile * :call Everf()
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

"let g:sexp_filetypes = 'fennel'
"let g:sexp_mappings = {
"    \ 'sexp_outer_list':                'af',
"    \ 'sexp_inner_list':                'mf',
"    \ 'sexp_outer_top_list':            'aF',
"    \ 'sexp_inner_top_list':            'mF',
"    \ 'sexp_outer_string':              'as',
"    \ 'sexp_inner_string':              'ms',
"    \ 'sexp_outer_element':             'ae',
"    \ 'sexp_inner_element':             'me',
"    \ 'sexp_move_to_prev_bracket':      '(',
"    \ 'sexp_move_to_next_bracket':      ')',
"    \ 'sexp_move_to_prev_element_head': 'B',
"    \ 'sexp_move_to_next_element_head': 'W',
"    \ 'sexp_move_to_prev_element_tail': 'gF',
"    \ 'sexp_move_to_next_element_tail': 'F',
"    \ 'sexp_flow_to_prev_close':        '',
"    \ 'sexp_flow_to_next_open':         '',
"    \ 'sexp_flow_to_prev_open':         '',
"    \ 'sexp_flow_to_next_close':        '',
"    \ 'sexp_flow_to_prev_leaf_head':    '',
"    \ 'sexp_flow_to_next_leaf_head':    '',
"    \ 'sexp_flow_to_prev_leaf_tail':    '',
"    \ 'sexp_flow_to_next_leaf_tail':    '',
"    \ 'sexp_move_to_prev_top_element':  '[[',
"    \ 'sexp_move_to_next_top_element':  ']]',
"    \ 'sexp_select_prev_element':       '',
"    \ 'sexp_select_next_element':       '',
"    \ 'sexp_indent':                    '==',
"    \ 'sexp_indent_top':                '=-',
"    \ 'sexp_round_head_wrap_list':      'sf(',
"    \ 'sexp_round_tail_wrap_list':      'sf)',
"    \ 'sexp_square_head_wrap_list':     'sf[',
"    \ 'sexp_square_tail_wrap_list':     'sf]',
"    \ 'sexp_curly_head_wrap_list':      'sf{',
"    \ 'sexp_curly_tail_wrap_list':      'sf}',
"    \ 'sexp_round_head_wrap_element':   'se(',
"    \ 'sexp_round_tail_wrap_element':   'se)',
"    \ 'sexp_square_head_wrap_element':  'se[',
"    \ 'sexp_square_tail_wrap_element':  'se]',
"    \ 'sexp_curly_head_wrap_element':   'se{',
"    \ 'sexp_curly_tail_wrap_element':   'se}',
"    \ 'sexp_insert_at_list_head':       '<L',
"    \ 'sexp_insert_at_list_tail':       '>L',
"    \ 'sexp_splice_list':               'ds',
"    \ 'sexp_convolute':                 '',
"    \ 'sexp_raise_list':                '',
"    \ 'sexp_raise_element':             '',
"    \ 'sexp_swap_list_backward':        '<f',
"    \ 'sexp_swap_list_forward':         '>f',
"    \ 'sexp_swap_element_backward':     '<e',
"    \ 'sexp_swap_element_forward':      '>e',
"    \ 'sexp_emit_head_element':         '>(',
"    \ 'sexp_emit_tail_element':         '>)',
"    \ 'sexp_capture_prev_element':      '<(',
"    \ 'sexp_capture_next_element':      '<)',
"    \ }
"}}}

map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

set autoread
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

"com! MyRun :call MyRun()
nnoremap <c-c> :call MyRun()<cr>
nnoremap <c-t> :call Zct()<cr>

" {{{
"fun! FennelCompile()
"  exe "w"
"  call Runcmd("fennel --compile " . expand('%:p'))
"endfun
"com! FennelCompile :call FennelCompile()
"nnoremap <c-c> :call FennelCompile()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""" RUN CURRENT FILE """""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Execute current file
"nnoremap <F5> :call ExecuteFile()<CR>
"
"" Will attempt to execute the current file based on the `&filetype`
"" You need to manually map the filetypes you use most commonly to the
"" correct shell command.
"function! ExecuteFile()
"  let filetype_to_command = {
"  \   'javascript': 'node',
"  \   'coffee': 'coffee',
"  \   'python': 'python',
"  \   'html': 'open',
"  \   'sh': 'sh'
"  \ }
"  let cmd = get(filetype_to_command, &filetype, &filetype)
"  call RunShellCommand(cmd." %s")
"endfunction
"
"" Enter any shell command and have the output appear in a new buffer
"" For example, to word count the current file:
""
""   :Shell wc %s
""
"" Thanks to: http://vim.wikia.com/wiki/Display_output_of_shell_commands_in_new_window
"command! -complete=shellcmd -nargs=+ Shell call RunShellCommand(<q-args>)
"function! RunShellCommand(cmdline)
"  echo a:cmdline
"  let expanded_cmdline = a:cmdline
"  for part in split(a:cmdline, ' ')
"     if part[0] =~ '\v[%#<]'
"        let expanded_part = fnameescape(expand(part))
"        let expanded_cmdline = substitute(expanded_cmdline, part, expanded_part, '')
"     endif
"  endfor
"  botright new
"  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
"  call setline(1, 'You entered:    ' . a:cmdline)
"  call setline(2, 'Expanded Form:  ' .expanded_cmdline)
"  call setline(3,substitute(getline(2),'.','=','g'))
"  execute '$read !'. expanded_cmdline
"  setlocal nomodifiable
"  1
"endfunction
"}}}

set number
set laststatus=2
set statusline=
set statusline+=%f
set statusline+=\ 
set statusline+=%m
set statusline+=\ 
set statusline+=%r
set statusline+=%=
set statusline+=%F
set statusline+=\ 
set statusline+=%y
set statusline+=\ 
set statusline+=%P
set relativenumber

nnoremap <SPACE> <Nop>
let mapleader=" "

noremap i l
noremap I L

noremap l i
noremap L I

noremap j f
noremap J F

noremap k n
noremap K N

noremap f e
noremap F E

noremap <expr> n v:count ? 'j' : 'gj'
noremap <expr> e v:count ? 'k' : 'gk'

noremap N <c-d>
noremap E <c-u>

noremap H 0
noremap I $

noremap <c-j> J

noremap // :noh<cr>

noremap U <c-r>

nnoremap <leader>r :%s///g<left><left>
xnoremap <leader>r :s///g<left><left>

" * while visual to search selected text
function! s:VisualStarSearch(search_cmd)
  let l:tmp = @"
  normal! gvy
  let @/ = '\V' . substitute(escape(@", a:search_cmd . '\'), '\n', '\\n', 'g')
  let @" = l:tmp
endfunction
xmap * :<c-u>call <SID>VisualStarSearch('/')<CR>n<c-o>

nnoremap * *<c-o>

xnoremap < <gv
xnoremap > >gv

"hi link StatusLine LineNr

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

lua <<EOF

require'nvim-treesitter.configs'.setup {
  --ensure_installed = "maintained",
  highlight = {
    enable = true,
  },
}

--require'lspconfig'.gdscript.setup{}

--vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with( vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false, underline = true, signs = true, } ) 
--vim.cmd [[autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()]] 
--vim.cmd [[autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help()]]
