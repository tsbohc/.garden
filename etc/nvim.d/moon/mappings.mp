--[[
'   ______  __.  _   _   o ____  _,  _
'  / / / <_(_/|_/_)_/_)_<_/ / <_(_)_/_)_
'              /   /             /|
'             '   '             |/
--]]

--[[ TODO
arrowkeys? move current line/indent?
--]]

map = A.map

Expr = 'expr'
Remap = 'remap'
Silent = 'silent'

vim.g.mapleader = ' '

-- colemak stuff --
-- {{{
map.nvo 'n', 'j'
map.nvo 'N', 'J'

map.nvo 'e', 'k'
map.nvo 'E', 'K'

map.nvo 'i', 'l'
map.nvo 'I', 'L'

map.nvo 'l', 'i'
map.nvo 'L', 'I'
map.nvo 'k', 'n'
map.nvo 'K', 'N'

map.nvo 'j', 'f'
map.nvo 'J', 'F'
map.nvo 'f', 'e'
map.nvo 'F', 'E'
-- }}}

------------------------------------
-- land of opinionated navigation --
------------  --/-<@  --------------

-- smart v-line movement
map.n Expr, 'n', ->
  if vim.v.count > 0 then 'j' else 'gj'

map.n Expr, 'e', ->
  if vim.v.count > 0 then 'k' else 'gk'

-- vertical
map.nv 'N', '<c-d>'
map.nv 'E', '<c-u>'

-- horizontal
map.nvo 'H', '0'
map.nvo 'I', '$'
map.nv '<ScrollWheelUp>', '<c-y>'
map.nv '<ScrollWheelDown>', '<c-e>'

-- split movement
map.n '<c-h>', '<c-w>h'
map.n '<c-n>', '<c-w>j'
map.n '<c-e>', '<c-w>k'
map.n '<c-i>', '<c-w>l'

-- consistency improvements --
map.n 'Y', 'y$'

------------------------------------
--      search and replace        --
------------  --/-<@  --------------

-- general --
map.n Silent, '//', ':noh<cr>'
map.n Silent, '*', '*N' -- check if there's an entry above?

-- smart replace
map.n '<leader>r', ':%s///g<left><left>'
map.x '<leader>r', ':s///g<left><left>'

-- seach for selected text
map.x '*', ->
  A.norm 'gvy'
  A.exec '/' .. A.eval '@"'
  A.norm '<c-o>'

-------------

-- undo with relative time
map.n 'u', ->
  A.exec ':silent undo'
  --A.exec ':doautocmd User UndoRedo'

map.n 'U', ->
  A.exec ':silent redo'
  --A.exec ':doautocmd User UndoRedo'

-- stay visual when indenting
map.x '<', '<gv'
map.x '>', '>gv'

return
