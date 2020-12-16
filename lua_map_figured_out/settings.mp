--[[      .
'   __   __)
'  (. | /o ______  __  _.
'     |/<_/ / / <_/ (_(__
'     |
'               setttings
--]]

require 'lib/IndexAsMethod'

-- TODO make debug a table or better pass it during require
debug = false

log = (...) ->
  if debug
    print 'settings -', ...

-- {{{
s = IndexAsMethod (index, value) ->
  get_type = (index) ->
    if pcall(-> return vim.api.nvim_get_option(index))
      return 'o'
    elseif pcall(-> return vim.api.nvim_win_get_option(0, index))
      return 'wo'
    elseif pcall(-> return vim.api.nvim_buf_get_option(0, index))
      return 'bo'
    else
      return 'none'

  t = get_type(index)
  if t == 'none'
    if index\sub(1, 2) == 'no'
      index = index\sub(3)
      t = get_type index

      log 'set:', t, index, '=', false
      vim[t][index] = false
      return
    else
      print 'option not found', t, index
      return

  if value
    log 'set:', t, index, '=', value
    vim[t][index] = value
  else
    log 'set:', t, index, '=', true
    vim[t][index] = true --not vim[t][index]
-- }}}

-- rendering --
s.encoding 'utf-8'               -- self-explanatory
s.nocompatible!                  -- allow vim -u vimc
s.synmaxcol 256                  -- max colums to use highlighting on
s.termguicolors!                 -- true color support

-- ui --
s.number!                        -- show ruler
s.relativenumber!                -- relative ruler
s.cursorline!                    -- highlight current line
s.showmatch!                     -- blink matching brace when a new one is inserted
s.matchtime 2                    -- blink quicker

-- behaviour --
s.scrolloff 10                   -- cursor padding in window
s.nowrap!                        -- do not wrap at the end of a line TODO: filetype au istext iscode
s.virtualedit 'block'            -- do not restrict v-block to characters
s.undofile!                      -- persistent undo/redo
s.clipboard 'unnamedplus'        -- don't forget xsel!
s.mouse 'a'                      -- blasphemy!

-- invisibles --
s.listchars 'trail:␣'
s.list!
--s.fillchars 'eob:~'              -- do not set those to fileseparator etc, trust me

-- search --
s.incsearch!                     -- search as characters are typed
s.inccommand 'nosplit'           -- show substitute effects as characters are typed
s.hlsearch!                      -- highlight matches
s.ignorecase!                    -- case-insensitive search
s.smartcase!                     -- case-sensitive if search contains uppercase

-- spacing --

-- these are buffer options that can be set w/ vim.o, yet do nothing

--s.tabstop 2
--s.shiftwidth 2
--s.softtabstop 2
--s.expandtab!
--s.noshiftround!                  -- round indent to multiples of shiftwidth

vim.cmd [[set tabstop=2]]
vim.cmd [[set shiftwidth=2]]
vim.cmd [[set softtabstop=2]]
vim.cmd [[set expandtab]]
vim.cmd [[set noshiftround]]

-- status lines --
s.noshowmode!                    -- do not show -- INSERT --, etc on lastline
s.laststatus 2                   -- always show statusline

-- folding --
s.foldtext 'v:lua.folding()'
