set = require('IndexAsMethod') (index, value) ->
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

      vim[t][index] = false
      return
    else
      print 'option not found', t, index
      return

  if value
    vim[t][index] = value
  else
    vim[t][index] = true --not vim[t][index]


-- rendering --
set.encoding 'utf-8'               -- self-explanatory
set.nocompatible!                  -- allow vim -u vimc
set.synmaxcol 256                  -- max colums to use highlighting on
set.termguicolors!                 -- true color support

-- ui --
set.number!                        -- current line number
set.relativenumber!                -- relative ruler
set.cursorline!                    -- highlight current line
set.showmatch!                     -- blink matching brace when a new one is inserted
set.matchtime 2                    -- return quicker

-- behaviour --
set.scrolloff 10                   -- cursor padding in window
set.wrap!                          -- wrap at the end of a line
set.virtualedit 'block'            -- do not restrict v-block to characters
set.undofile!                      -- persistent undo/redo
set.clipboard 'unnamedplus'        -- don't forget xsel!
set.mouse 'a'                      -- blasphemy!

-- invisibles --
set.listchars 'trail:␣'
set.list!
--set.fillchars 'eob:~'              -- do not set those to fileseparator etc, trust me

-- search --
set.incsearch!                     -- search as characters are typed
set.inccommand 'nosplit'           -- show substitute effects as characters are typed
set.hlsearch!                      -- highlight matches
set.ignorecase!                    -- case-insensitive search
set.smartcase!                     -- case-sensitive if search contains uppercase

-- spacing --
set.tabstop 2
set.shiftwidth 2
set.softtabstop 2
set.expandtab!
set.noshiftround!                  -- FIXME: what even is this

-- status lines --
set.noshowmode!                    -- do not show -- INSERT --, etc on lastline
set.laststatus 2                   -- always show statusline

-- folding --
set.foldtext 'v:lua.folding()'
