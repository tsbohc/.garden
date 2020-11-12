--[[      .
'  __   __)
' (. | /o ______  __  _.
'    |/<_/ / / <_/ (_(__
'    |
'
'           luautism~  ]]

require('vimp')
api = vim.api

-- TODO
-- abbreviations!!!
-- chage gruvbox visual mode to the same hl group as cursorline
-- bring back from the dead mouse scrolling and mouse generally


-- ice needs to check if packer options are passed
-- eventually move this into a separate file w/ require

-- make <c-c> same as c in vblock

-- filetype = vim.bo.filetype
Command = vim.cmd

Normal = (command) ->
  Command 'norm! ' .. command

g = vim.g
v = vim.v
fn = vim.fn

o = setmetatable({}, {
  __call: (options) =>
    for k, v in pairs options
      if type(k) == 'number'
        Command 'set ' .. v
      else
        Command 'set ' .. k .. '=' .. v

  __index: (k) =>
    api.nvim_get_option(k)

  __newindex: (k, v) =>
    api.nvim_set_option(k, v)
})

colorscheme = (name) ->
    Command 'colorscheme ' .. name

--------------------------------
--          plugins           --
--------------------------------

-- {{{
ice_before = {}
ice = (name, hook) ->
  if hook == nil
    hook = () ->
  ice_before[name] = hook

plugins = (init) ->
  init!
  for p, h in pairs ice_before
    h!
-- }}}

plugins ->

  -- code --
  ice 'neoclide/coc.nvim'
  ice 'SirVer/ultisnips', ->
    g.UltiSnipsExpandTrigger = '<s-tab>'
    g.UltiSnipsJumpForwardTrigger = '<c-b>'
    g.UltiSnipsJumpBackwardTrigger = '<c-z>'

  ice 'honza/vim-snippets'
  ice 'svermeulen/vimpeccable'

  ice 'pigpigyyy/moonplus-vim'
  ice 'habamax/vim-godot'

  ice 'Yggdroot/indentline', ->
    g.indentLine_char = '│'

  -- write --
  ice 'dbmrq/vim-ditto'
  ice 'ron89/thesaurus_query.vim'
  ice 'reedes/vim-lexical'

  -- latex --
  ice 'lervag/vimtex', ->
    g.tex_flavor = 'latex'
    g.tex_conceal = ''
    g.vimtex_latexmk_continuous = 1
    g.vimtex_view_method = 'zathura'
    g.vimtex_quickfix_latexlog = { 'default': 0 }

  -- style --
  ice 'morhetz/gruvbox', ->
    g.gruvbox_contrast_dark = 'hard'
    g.gruvbox_italicize_comments = 1
    --g.gruvbox_italic = 1
    g.gruvbox_bold = 0

  ice 'sainnhe/sonokai'
  ice 'ayu-theme/ayu-vim'

  -- general --
  ice 'junegunn/fzf.vim'

--------------------------------
--          options           --
--------------------------------

o {
  -- rendering --
  'encoding':      'utf-8'       -- self-explanatory
  'nocompatible'                 -- allow vim -u vimrc
  'synmaxcol':     256           -- max colums to use highlighting on
  'termguicolors'                -- true color support

  -- ui --
  'number'                       -- current line number
  'relativenumber'               -- relative ruler
  'cursorline'                   -- highlight current line

  'showmatch'                    -- blink matching brace when a new one is inserted
  'matchtime':     2             -- return quicker

  -- behaviour --
  'scrolloff':     10            -- cursor padding in window
  'wrap'                         -- wrap at the end of a line
  'virtualedit':   'block'       -- do not restrict v-block to characters
  'undofile'                     -- persistent undo/redo
  'clipboard':     'unnamedplus' -- don't forget xsel!

  -- invisibles --
  'listchars':     'trail:␣'
  'list'

  -- search --
  'incsearch'                    -- search as characters are typed
  'inccommand':    'nosplit'     -- show substitute effects as characters are typed
  'hlsearch'                     -- highlight matches
  'ignorecase'                   -- case-insensitive search
  'smartcase'                    -- case-sensitive if search contains uppercase

  'tabstop':       2
  'shiftwidth':    2
  'softtabstop':   2
  'expandtab'
  'noshiftround'

  'noshowmode'                   -- do not show -- INSERT --, etc on lastline
  'laststatus':    2             -- always show statusline
  --'showtabline':   2
  --'statusline':    '%!v:lua.statusline()'

  'foldtext':      'v:lua.folding()'
}

-- TODO add check if file exists or try expect
colorscheme 'gruvbox'

--------------------------------
--          keybinds          --
--------------------------------

g.mapleader = ' '

bind = {
  n: (...) ->
    vimp.nnoremap ...
  x: (...) ->
    vimp.xnoremap ...
  i: (...) ->
    vimp.inoremap ...
}

keyremap = (mode, data) ->
  for k, v in pairs data
    -- operator mode is what makes d5e and etc work properly!
    vimp.bind mode, k, v
    vimp.bind mode, string.upper(k), string.upper(v)

    --api.nvim_set_keymap('', k, v, { noremap: true })
    --api.nvim_set_keymap('', string.upper(k), string.upper(v), { noremap: true })

keyremap 'nvo', {
  'n': 'j'
  'e': 'k'
  'i': 'l'

  'l': 'i'
  'k': 'n'

  'j': 'f'
  'f': 'e'
}

-- {{{
ru = () ->
  --cyrillic = [[ё"№;:?йцукенгшщзхъфывапролджэячсмитьбю.ЙЦУКЕНГШЩЗХЪ/ФЫВАПРОЛДЖЭЯЧСМИТЬБЮ,]]
  --colemak =  [[`@#$^&qwfpgjluy;[]arstdhneio'zxcvbkm,./QWFPGJLUY:{}|ARSTDHNEIO"ZXCVBKM<>?]]

  --cyrillic = [[ё"№;:?йцукенгшщзхъфывапролджэячсмитьбю.ЙЦУКЕНГШЩЗХЪ/ФЫВАПРОЛДЖЭЯЧСМИТЬБЮ,]]
  --colemak =  [[`@#$^&qwfpgjluy;[]arstdhneio'zxcvbkm,./QWFPGJLUY:{}|ARSTDHNEIO"ZXCVBKM<>?]]
  cyrillic = [[йцукенгшщхъфывапролджячсмитьЙЦУКЕНГШЩФЫВАПРОЛДЖЯЧСМИТЬБЮ,]]
  colemak =  [[qwfpgjluy[]arstdhneiozxcvbkmQWFPGJLUYARSTDHNEIOZXCVBKM<>?]]
  Command [[set langmap=ё"№\;:?йцукенгшщзхъфывапролджэячсмитьбю.йцукенгшщзхъ/фывапролджэячсмитьбю\,;qwfpgjluy[]arstdhneiozxcvbkmQWFPGJLUYARSTDHNEIOZXCVBKM<>?]]
  --n = 1
  --for c in string.gmatch(cyrillic, "[%z\1-\127\194-\244][\128-\191]*")
  --  vimp.rbind 'c', c, string.sub(colemak, n, n)
  --  n += 1
-- }}}

-- opinionated
bind.n 'zC', 'zM'
bind.n 'Y', 'y$'
bind.n ';', ':'
bind.n 'U', '<c-r>'

-- stay visual when indenting
bind.x '<', '<gv'
bind.x '>', '>gv'

-- search
bind.n { 'silent' }, '//', ':noh<cr>'
bind.n { 'silent' }, '*', '*N'

-- smart replace
bind.n '<leader>r', ':%s///g<left><left>'
bind.x '<leader>r', ':s///g<left><left>'

-- seach for selected text
vimp.bind 'x', '*', ->
  Normal 'gvy'
  Command '/' .. api.nvim_eval '@"'
  Normal '<c-o>'

-- smart line movement
bind.n { 'override', 'expr' }, 'n', ->
  if v.count > 0 then 'j' else 'gj'

bind.n { 'override', 'expr' }, 'e', ->
  if v.count > 0 then 'k' else 'gk'

bind.n 'H', 'J'

-- scrolling
bind.n { 'override' }, 'N', '<c-d>'
bind.n { 'override' }, 'E', '<c-u>'

-- split movement
-- {{{
bind.n '<c-h>',    '<c-w>h'
bind.n '<c-n>',    '<c-w>j'
bind.n '<c-e>',    '<c-w>k'
bind.n '<c-i>',    '<c-w>l'
-- }}}

-- useful arrowkeys
-- {{{
bind.n '<left>',   '<c-w>h'
bind.n '<down>',   '<c-w>j'
bind.n '<up>',     '<c-w>k'
bind.n '<right>',  '<c-w>l'
-- }}}

-- easy umlauts
-- {{{
bind.i '<c-o>', 'ö'
bind.i '<c-a>', 'ä'
bind.i '<c-u>', 'ü'
bind.i '<c-s>', 'ß'
-- }}}

-- reload vimrc.lua
-- {{{
unload_lua_namespace = (prefix) ->
  prefix_with_dot = prefix .. '.'
  for key, value in pairs(package.loaded) do
    if key == prefix or key\sub(1, #prefix_with_dot) == prefix_with_dot then
      package.loaded[key] = nil

vimp.nnoremap '<leader>s', ->
  vimp.unmap_all()
  unload_lua_namespace('vimrc')
  Command('silent wa')
  require('vimrc')
  print 'reloaded vimrc'
  Command 'silent noh'
-- }}}

--------------------------------
--         vim magic          --
--------------------------------

_G.dump = (...) ->
  objects = vim.tbl_map(vim.inspect, {...})
  print(unpack(objects))

-- custom folding
-- {{{
_G.folding = () ->
  fold_size = v.foldend - v.foldstart - 1

  --line = fn.getline v.foldstart
  --if string.len(line) <= 6

  line = fn.getline v.foldstart + 1
  indent = string.match(line, "^%s*")
  line = string.match(line, "^%s*(.-)%s*$")

  window_width = tonumber(fn.winwidth(0)) - tonumber(api.nvim_eval '&number') * tonumber(api.nvim_eval '&numberwidth') - tonumber(api.nvim_eval '&foldcolumn')

  l = indent .. '+ ' .. line
  r= '' .. fold_size .. '+     '

  txt_len = window_width - string.len(l .. r) + 1

  return l .. string.rep(' ', txt_len) .. r
-- }}}

-- statusline
-- TODO:
-- check if autocmds update all windows -- don't think so
-- different function for inactive statusline
-- focuslost event! all inactive
-- highlight active window
-- light mode (only internal flags)

statusline_events = {
  'WinEnter','BufEnter','BufDelete','SessionLoadPost','FileChangedShellPost',
  'CursorMoved'
  'CursorMovedI'
  'InsertEnter'
  'InsertChange'
  'InsertLeave'
}

-- {{{
_G.statusline = (bufnr) ->
  -- {{{
  out = (data) ->
    _out = ''
    for _, k in pairs data
      _out ..= k
    return _out
  _ = ' '

  padding = ->
    size = tonumber(api.nvim_eval '&number') * tonumber(api.nvim_eval '&numberwidth') + tonumber(api.nvim_eval '&foldcolumn') - 1
    return string.rep(' ', size)
  -- }}}

  -- {{{
  percent = ->
    blocks = {' ', '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█'}
    current_line = vim.fn.line('.')
    total_line = vim.fn.line('$')
    if current_line == 1 then
      return blocks[1]
    elseif current_line == vim.fn.line('$') then
      return blocks[#blocks]
    d = current_line / total_line
    index = vim.fn.float2nr(d * #blocks)
    if index == 0
      index = 1
    block = blocks[index]
    return block
  -- }}}

  -- {{{
  mode = ->
    --modes = {
    --  'n': '‹‹ %f ››'
    --  'i': '.. %f ..'
    --  'v': '-- %f --'
    --  'V': '== %f =='
    --  'c': '›› %f ‹‹'
    --  'B': 'vib'
    --}

    modes = {
      'n': '‹›'
      'i': '..'
      'v': '--'
      'V': '=='
      'c': '›‹'
      'B': 'vib'
    }

    m = vim.fn.mode!
    txt = modes[m]

    if txt == nil
      return m
    else
      return txt

  modified = ->
    if vim.bo.modified then 'modified' else ''

  readonly = ->
    if vim.bo.readonly then ' readonly ' else ''

  filetype = ->
    return vim.bo.filetype
  -- }}}

  -- just in case
  --if vim.w.aaa != nil
  --  bufnr = vim.w.aaa
  --else
  --  vim.w.aaa = bufnr

  filepath = vim.fn.getbufinfo()[bufnr].name

  fpath = ->
    if filepath == ''
      return ''
    else
      home = '/home/sean'
      return string.gsub(filepath, home, '~')

  fname = ->
    if filepath == ''
      return '[ new ]'
    else
      return '‹‹ ' .. string.match(filepath, "^.+/(.+)$") .. ' ››'

  test = ->
    return 'foo'

  out {
    '%#CursorLine#'
    '%L'
    _
    fname!
    _
    --test!
    '%#LineNr#'
    _
    modified!
    '%#Search#'
    readonly!
    '%#LineNr#'
    _
    '%='

    fpath!
    _
    --percent!
    --_

    '%#CursorLine#'
    _
    --bufnr
    --_
    --'::'
    --_
    '%p%%'
    _
    '%#LineNr#'
  }
-- }}}

api.nvim_command 'augroup statusline_events'
api.nvim_command 'autocmd!'
for _, k in ipairs statusline_events
  api.nvim_command 'autocmd ' .. k .. ' * lua vim.wo.statusline = statusline(vim.fn.bufnr())'
api.nvim_command 'augroup END'

-- writing mode
bind.n '<leader>w', ->
  info = vim.fn.getbufinfo!
  for n, buf in pairs info
    print '--', n, buf
    for k, v in pairs buf
      print k, v

--------------------------------
--          autocmd           --
--------------------------------

-- TODO: redo when proper api support

autocmd = (callback) ->
  Command 'autocmd ' .. callback

-- hide CursorLine in insert mode
autocmd 'InsertEnter * set nocul'
autocmd 'InsertLeave * set cul'

-- briefly flash yanked text
autocmd 'TextYankPost * silent! lua vim.highlight.on_yank { higroup = "Search", timeout = 100}'

-- recompile config
autocmd 'BufWritePost ~/.config/nvim/lua/*.mp silent !moonp %'
--autocmd 'BufWritePost ~/.config/nvim/lua/*.mp silent :PackerCompile'

--------------------------------
--          plugins           --
--------------------------------

Command "packadd packer.nvim"
return require('packer').startup ->
  use 'wbthomason/packer.nvim'
  for p, h in pairs ice_before
    use p
