--[[      .
'  __   __)
' (. | /o ______  __  _.
'    |/<_/ / / <_/ (_(__
'    |
'
'           luautism~  ]]

-- remember to change reload_vimrc to unload new requires
-- or maybe even wrap require and store a dict somewhere

-- lua assert?

require('vimp')
require('utils')

-- TODO
-- create my own bind.n etc functions with lua hooks

-- {{{
-- coc-word
-- abbreviations!!!
-- N E in visual
-- chage gruvbox visual mode to the same hl group as cursorline
-- bring back from the dead mouse scrolling and mouse generally
-- add nocul on focuslost

-- ice needs to check if packer options are passed
-- eventually move this into a separate file w/ require

-- make <c-c> same as c in vblock

-- filetype = vim.bo.filetype
-- }}}

Command = vim.cmd

Normal = (command) ->
  Command 'norm! ' .. command

autocmd = (callback) ->
  Command 'autocmd ' .. callback

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

-- {{{
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
-- }}}

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

bind.n '<C-Space>', -> print 'arst'

-- opinionated
bind.n 'zC', 'zM'
bind.n 'Y', 'y$'
bind.n ';', ':'
--bind.n 'U', '<c-r>'

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
  unload_lua_namespace('utils')
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
-- flag formatting?

_G.update_statusline = () ->
  vim.wo.statusline = statusline(vim.fn.bufnr())

undoredo = ''

relative_undo = (action) ->
  time = {
    second: 1
    minute: 60
    hour: 60 * 60
    day: 24 * 60 * 60
    week: 7 * 24 * 60 * 60
    month: 30.5 * 24 * 60 * 60
    year: 365 * 24 * 60 * 60
  }


  get_undo_time = (undotree) ->
    idx = undotree.seq_cur
    --for i=1, #undotree.entries
    --  if undotree.entries[i].seq == idx
    --    return undotree.entries[i].time
    for _, entry in pairs undotree.entries
      if entry.seq == idx
        return entry.time
    return vim.fn.localtime()

  get_relative_undo_time = ->
    undotree = vim.fn.undotree()
    if undotree.seq_cur == undotree.seq_last
      return ''

    plural = ''
    d = vim.fn.localtime! - get_undo_time(undotree)
    w = false

    if d <= time.second
      return 'moments ago'
    elseif d < time.minute
      return d .. ' seconds ago'
    elseif d < time.hour
      w = 'minute'
    elseif d < time.day
      w = 'hour'
    elseif d < time.week
      w = 'day'
    elseif d < time.month
      w = 'week'
    elseif d < time.year
      w = 'month'
    else
      return 'more than a year ago'

    if w
      n = math.floor(d / time[w])
      if n > 1 then plural = 's' else plural = ''
      return n .. ' ' .. w .. plural .. ' ago'

  lplural = ''
  lines_before = vim.fn.line('$')
  vim.cmd ':silent ' .. action
  lines_after = vim.fn.line('$')

  d_lines = lines_after - lines_before
  if math.abs(d_lines) > 1 lplural = 's' else lplural = ''

  if d_lines > 0
    --d_lines = ', ' .. d_lines .. ' line' .. lplural .. ' more'
    d_lines = ', +' .. d_lines .. ' line' .. lplural
  elseif d_lines < 0
    --d_lines = ', ' .. math.abs(d_lines) .. ' line' .. lplural .. ' less'
    d_lines = ', ' .. d_lines .. ' line' .. lplural
  else
    d_lines = ''

  rel_time = get_relative_undo_time!

  undoredo = rel_time .. d_lines
  update_statusline!

bind.n 'u', ->
  relative_undo 'undo'

bind.n 'U', ->
  relative_undo 'redo'

-- {{{
_G.statusline = (bufnr, inactive) ->
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
  -- }}}

  -- just in case
  --if vim.w.aaa != nil
  --  bufnr = vim.w.aaa
  --else
  --  vim.w.aaa = bufnr

  info = vim.fn.getbufinfo()[bufnr]
  info.readonly = vim.api.nvim_buf_get_option(bufnr, 'readonly')

  modified = ->
    if info.name != ''
      --if info.changed == 1 then 'modified' else ''
      return [[%{&modified?'modified':''}]]

  readonly = ->
    --r = vim.api.nvim_buf_get_option(bufnr, 'readonly')
    --if r then ' readonly ' else ''
    return [[%{&readonly?' readonly ':''}]]

  dimmer = ->
    if not inactive
      return '%#CursorLine#'
    else
      return '%#LineNr#'

  filetype = ->
    return vim.bo.filetype

  fpath = ->
    if info.name == ''
      return 'unsaved'
    else
      -- FIXME
      home = '/home/sean'
      return string.match(string.gsub(info.name, home, '~'), "(.*[/\\])")

  fname = ->
    if info.name == ''
      return ''
    else
      name = string.match(info.name, "^.+/(.+)$")
      --if info.changed == 0
      return '‹‹ ' .. name .. ' ››'
      --else
      --  return '›› ' .. name .. ' ‹‹'

  if vim.bo.filetype == 'help'
    --return dimmer! .. '‹‹ help ››' .. '%#LineNr#' .. '%=' .. dimmer! .. ' %p%% '
    return '%#CursorLine#' .. ' help ' .. '%#LineNr#' .. '%=' .. '%#CursorLine#' .. ' %p%% '

  out {
    '%#CursorLine#'
    '%L'
    _
    fname!
    _
    '%#LineNr#'
    _
    undoredo
    _
    --modified!
    --_
    '%#Search#'
    readonly!
    '%#LineNr#'
    _
    '%='
    '%<'
    fpath!
    _

    '%#CursorLine#'
    _
    __prev_layout
    _
    '%2p%%'
    _
    '%#LineNr#'
  }
-- }}}

au { 'BufEnter', 'BufLeave', 'CursorMoved', 'CursorMovedI' }, '*', ->
  vim.wo.statusline = statusline(fn.bufnr())

-- writing mode
bind.n '<leader>1', ->
  print 'a'

--------------------------------
--          autocmd           --
--------------------------------

-- TODO: redo when proper api support

au { 'InsertEnter', 'InsertLeave', 'BufLeave', 'FocusLost' }, '*', 'set nocul'

au 'BufEnter', '*', ->
  if fn.mode! != 'i'
    cmd 'set cul'

au 'FocusGained', '*', ->
  if fn.mode! != 'i'
    cmd 'set cul'

-- briefly flash yanked text
autocmd 'TextYankPost * silent! lua vim.highlight.on_yank { higroup = "Search", timeout = 100 }'

-- recompile config
autocmd 'BufWritePost ~/.config/nvim/lua/*.mp silent !moonp %'
--autocmd 'BufWritePost ~/.config/nvim/lua/*.mp silent :PackerCompile'

-- layout switcher
-- TODO:
-- save language separately for each buffer? may be confusing
-- intert mode mappings?
global __prev_layout = 'us'

au 'InsertLeave', '*', ->
  __prev_layout = os.capture([[setxkbmap -query | awk '/layout/ { print $2 }']])
  if __prev_layout == 'ru'
    os.execute [[ setxkbmap us -variant colemak ]]

au 'InsertEnter', '*', ->
  if __prev_layout == 'ru'
    os.execute [[ setxkbmap ru ]]

--------------------------------
--          plugins           --
--------------------------------

Command "packadd packer.nvim"
return require('packer').startup ->
  use 'wbthomason/packer.nvim'
  for p, h in pairs ice_before
    use p


-- {{{
--statusline_au = (events) ->
--  api.nvim_command 'augroup statusline_events'
--  api.nvim_command 'autocmd!'
--  for _, k in ipairs events
--    api.nvim_command 'autocmd ' .. k .. ' * lua vim.wo.statusline = statusline(vim.fn.bufnr())'
--  api.nvim_command 'augroup END'
--
--statusline_au {
--  'BufEnter'
--  'BufLeave'
--  --'BufDelete','SessionLoadPost','FileChangedShellPost',
--  'CursorMoved'
--  'CursorMovedI'
--  --'InsertEnter'
--  --'InsertChange'
--  --'InsertLeave'
--}

--api.nvim_command 'autocmd WinLeave * lua vim.wo.statusline = statusline(vim.fn.bufnr(), true)'
--api.nvim_command 'autocmd WinEnter * lua vim.wo.statusline = statusline(vim.fn.bufnr())'
-- }}}
