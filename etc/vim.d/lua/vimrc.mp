--[[      .
'  __   __)
' (. | /o ______  __  _.
'    |/<_/ / / <_/ (_(__
'    |
'
'           luautism~  ]]

require('utils')
require('ss')

-- map ctrl-backspace to db ??

-- dump internal vim command into current buffer
-- :silent put =execute('autocmd')

-- remember to change reload_vimrc to unload new requires
-- or maybe even wrap require and store a dict somewhere

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

o = setmetatable({}, {
  __call: (options) =>
    for k, v in pairs options
      if type(k) == 'number'
        V.exec 'set ' .. v
      else
        V.exec 'set ' .. k .. '=' .. v

  __index: (k) =>
    api.nvim_get_option(k)

  __newindex: (k, v) =>
    api.nvim_set_option(k, v)
})

--------------------------------
--          plugins           --
--------------------------------

---- {{{
--ice_before = {}
--ice = (name, hook) ->
--  if hook == nil
--    hook = () ->
--  ice_before[name] = hook
--
--plugins = (init) ->
--  init!
--  for p, h in pairs ice_before
--    h!
---- }}}

-- {{{
--plugins ->
--
--  -- code --
--  ice 'neoclide/coc.nvim'
--  ice 'SirVer/ultisnips', ->
--    g.UltiSnipsExpandTrigger = '<s-tab>'
--    g.UltiSnipsJumpForwardTrigger = '<c-b>'
--    g.UltiSnipsJumpBackwardTrigger = '<c-z>'
--
--  ice 'honza/vim-snippets'
--  ice 'svermeulen/vimpeccable'
--
--  ice 'pigpigyyy/moonplus-vim'
--  ice 'habamax/vim-godot'
--
--  ice 'Yggdroot/indentline', ->
--    g.indentLine_char = '│'
--
--  -- write --
--  ice 'dbmrq/vim-ditto'
--  ice 'ron89/thesaurus_query.vim'
--  ice 'reedes/vim-lexical'
--
--  -- latex --
--  ice 'lervag/vimtex', ->
--    g.tex_flavor = 'latex'
--    g.tex_conceal = ''
--    g.vimtex_latexmk_continuous = 1
--    g.vimtex_view_method = 'zathura'
--    g.vimtex_quickfix_latexlog = { 'default': 0 }
--
--  -- style --
--  ice 'morhetz/gruvbox', ->
--    g.gruvbox_contrast_dark = 'hard'
--    g.gruvbox_italicize_comments = 1
--    --g.gruvbox_italic = 1
--    g.gruvbox_bold = 0
--
--  ice 'adigitoleo/vim-mellow'
--
--  ice 'sainnhe/sonokai'
--  ice 'ayu-theme/ayu-vim'
--
--  -- general --
--  ice 'junegunn/fzf.vim'
---- }}}

--------------------------------
--          options           --
--------------------------------

-- {{{
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
  'mouse':         'a'           -- blasphemy!

  -- invisibles --
  'listchars':     'trail:␣'
  'list'
  --'fillchars':     'eob:·'     -- do not set those to fileseparator etc, trust me

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

  'foldtext':      'v:lua.folding()'
}
-- }}}

-- TODO add check if file exists or try expect
V.colorscheme 'gruvbox'

-- remove '~'s
V.exec [[ highlight EndOfBuffer ctermfg=bg guifg=bg ]]

--------------------------------
--          keybinds          --
--------------------------------

g.mapleader = ' '

-- colemak remap
-- {{{
keyremap = (mode, data) ->
  for k, v in pairs data
    -- operator mode is what makes d5e and etc work properly!
    V.map mode, k, v
    V.map mode, string.upper(k), string.upper(v)

keyremap 'nvo', {
  'n': 'j'
  'e': 'k'
  'i': 'l'

  'l': 'i'
  'k': 'n'

  'j': 'f'
  'f': 'e'
}
-- }}}

-- testing
V.map '<C-Space>', -> print 'arst'

-- opinionated
V.map.n 'zC', 'zM'
V.map.n 'Y', 'y$'
V.map.n ';', ':'

-- stay visual when indenting
V.map.x '<', '<gv'
V.map.x '>', '>gv'

-- search
V.map.n { 'silent' }, '//', ':noh<cr>'
V.map.n { 'silent' }, '*', '*N'

-- smart replace
V.map.n '<leader>r', ':%s///g<left><left>'
V.map.x '<leader>r', ':s///g<left><left>'

-- seach for selected text
V.map.x '*', ->
  V.norm 'gvy'
  V.exec '/' .. V.eval '@"'
  V.norm '<c-o>'

-- undo with relative time
V.map.n 'u', ->
  V.exec ':silent undo'
  V.exec ':doautocmd User UndoRedo'

V.map.n 'U', ->
  V.exec ':silent redo'
  V.exec ':doautocmd User UndoRedo'

-- smart line movement
V.map.n { 'override', 'expr' }, 'n', ->
  if v.count > 0 then 'j' else 'gj'

V.map.n { 'override', 'expr' }, 'e', ->
  if v.count > 0 then 'k' else 'gk'

-- move J
V.map.n 'H', 'J'

-- scrolling
-- {{{
V.map 'nv', { 'override' }, 'N',   '<c-d>'
V.map 'nv', { 'override' }, 'E',   '<c-u>'
V.map 'nv', '<ScrollWheelUp>',     '<c-y>'
V.map 'nv', '<ScrollWheelDown>',   '<c-e>'
-- }}}

-- split movement
-- {{{
V.map.n '<c-h>',    '<c-w>h'
V.map.n '<c-n>',    '<c-w>j'
V.map.n '<c-e>',    '<c-w>k'
V.map.n '<c-i>',    '<c-w>l'
-- }}}

-- useful arrowkeys
-- {{{
V.map.n '<left>',   '<c-w>h'
V.map.n '<down>',   '<c-w>j'
V.map.n '<up>',     '<c-w>k'
V.map.n '<right>',  '<c-w>l'
-- }}}

-- easy umlauts
-- {{{
V.map.i '<c-o>', 'ö'
V.map.i '<c-a>', 'ä'
V.map.i '<c-u>', 'ü'
V.map.i '<c-s>', 'ß'
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
  unload_lua_namespace('ss')
  V.exec 'silent wa'
  require('vimrc')
  print 'reloaded vimrc'
  V.exec 'silent noh'
-- }}}

--------------------------------
--         vim magic          --
--------------------------------

global dump = (...) ->
  objects = vim.tbl_map(vim.inspect, {...})
  print(unpack(objects))

-- custom folding
-- {{{
global folding = () ->
  fold_size = v.foldend - v.foldstart - 1

  --line = fn.getline v.foldstart
  --if string.len(line) <= 6

  line = fn.getline v.foldstart + 1
  indent = line\match("^%s*")
  line = line\match("^%s*(.-)%s*$")

  window_width = tonumber(fn.winwidth(0)) - tonumber(api.nvim_eval '&number') * tonumber(api.nvim_eval '&numberwidth') - tonumber(api.nvim_eval '&foldcolumn')

  l = indent .. '+ ' .. line
  r= '' .. fold_size .. '+     '

  txt_len = window_width - (l .. r)\len! + 1

  return l .. ' '\rep(txt_len) .. r
-- }}}

StatusLine {
  '%#CursorLine#'
  '%L '

  { 'BufEnter, BufWritePost', ->
    name = fn.expand('%:t')
    if name != ''
      return '‹‹ ' .. name .. ' ›› '
  }

  '%#LineNr#'

  { 'User UndoRedo, BufEnter, BufLeave, FocusLost, FocusGained, BufWritePost', ->
    ' ' ..  V.getundotime!
  }

  -- TODO move to getundotime
  { 'User UndoRedo, BufEnter, BufWritePost', ->
    name = fn.expand('%:t')
    -- find a better way to check if file exists
    if name != '' --and file_exists name
      return [[%{&modified?'':',, saved '}]]
  }

  '%#Search#'
  { 'BufEnter', -> [[%{&readonly?'  readonly ':''}]] }
  '%#LineNr#'

  '%=%<'

  { 'BufEnter, BufWritePost', ->
    fn.expand('%:p:~:h') .. ' ' --.. '/'
  }

  '%#CursorLine# '

  { 'InsertEnter, InsertLeave', ->
    if G.previous_layout == 'ru'
      return 'ru '
  }

  '%2p%% '
}


-- writing mode
V.map.n '<leader>1', ->
  print 'a'

--------------------------------
--          autocmd           --
--------------------------------

-- use cursorline to show active windows and current mode
V.au { 'InsertEnter', 'InsertLeave', 'BufLeave', 'FocusLost' }, '*', 'set nocul'
V.au { 'BufEnter', 'FocusGained' }, '*', ->
  if V.mode! != 'i'
    V.exec 'set cul'

-- briefly flash yanked text
V.au 'TextYankPost', '*', ->
  vim.highlight.on_yank { higroup: "Search", timeout: 100 }

-- recompile config, suppress output unless the compilation failed
V.au 'BufWritePost', '~/.config/nvim/lua/*.mp', ->
  out = V.capture '!moonp %'
  if V.eval('v:shell_error') == 1
    print out

-- switch keyboard layout to us when in normal mode
-- TODO: insert mode mappings?
V.au 'InsertLeave', '*', ->
  G.previous_layout = os.capture [[ setxkbmap -query | awk '/layout/ { print $2 }' ]]
  if G.previous_layout == 'ru'
    os.execute [[ setxkbmap us -variant colemak ]]

V.au 'InsertEnter', '*', ->
  if G.previous_layout == 'ru'
    os.execute [[ setxkbmap ru ]]

-- open help in a vertical split
V.au 'Filetype', 'help', ->
  V.exec 'wincmd L'

--------------------------------
--          plugins           --
--------------------------------

--V.exec 'packadd packer.nvim'
--return require('packer').startup ->
--  use 'wbthomason/packer.nvim'
--  for p, h in pairs ice_before
--    use p
