--[[
'          _/__/_
'   _   _  /  /  o ____  _,  _
'  /_)_</_<__<__<_/ / <_(_)_/_)_
'                        /|
'                       |/
--]]

set = A.set

-- rendering --
set.encoding 'utf-8'               -- self-explanatory
set.nocompatible!                  -- allow vim -u vimc
set.synmaxcol 256                  -- max colums to use highlighting on
set.termguicolors!                 -- true color support

-- ui --
set.number!                        -- show ruler
set.relativenumber!                -- relative ruler
set.cursorline!                    -- highlight current line
set.showmatch!                     -- blink matching brace when a new one is inserted
set.matchtime 2                    -- blink quicker

-- behaviour --
set.scrolloff 10                   -- cursor padding in window
set.nowrap!                        -- do not wrap at the end of a line TODO: filetype au istext iscode
set.virtualedit 'block'            -- do not restrict v-block to characters

vim.cmd [[set undofile]]
--set.undofile!                      -- persistent undo/redo

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

-- these are buffer options that can be set w/ vim.o, yet do nothing

--set.tabstop 2
--set.shiftwidth 2
--set.softtabstop 2
--set.expandtab!
--set.noshiftround!                  -- round indent to multiples of shiftwidth

vim.cmd [[set tabstop=2]]
vim.cmd [[set shiftwidth=2]]
vim.cmd [[set softtabstop=2]]
vim.cmd [[set expandtab]]
vim.cmd [[set noshiftround]]

-- status lines --
set.noshowmode!                    -- do not show -- INSERT --, etc on lastline
set.laststatus 2                   -- always show statusline

-- folding --
set.foldtext 'v:lua.folding()'

return
