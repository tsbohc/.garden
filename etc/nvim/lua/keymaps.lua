local ki = require 'lib.ki'

--  land of opinionated navigation  --
--------------  --/-<@  --------------

-- i need more space :>
vim.g.mapleader = ' ' -- (sorry)

-- smart v-line movement
ki.nvs('k', function()
  if vim.v.count > 0 then return 'k' else return 'gk' end
end, { 'expr' })

ki.nvs('j', function()
  if vim.v.count > 0 then return 'j' else return 'gj' end
end, { 'expr' })

-- simple split switching
for _, k in ipairs({ 'h', 'j', 'k', 'l' }) do
  ki.n('<c-' .. k .. '>', '<c-w>' .. k)
end

-- screen and line movement
ki.nvs('H', '0')
ki.nvs('J', '<c-d>')
ki.nvs('K', '<c-u>')
ki.nvs('L', '$')

--        search and replace        --
--------------  --/-<@  --------------

ki.nvs('//', ':nohlsearch<cr>', { 'silent' })

-- keep cursor position when norm! *
ki.n('*', function()
  local p = vim.fn.getpos '.'
  vim.cmd 'norm! *'
  vim.fn.setpos('.', p)
end)

-- search literally for visually selected text
ki.x('*', function()
  local p = vim.fn.getpos '.'
  local yank_reg = vim.fn.getreg('"')
  vim.cmd 'norm! gvy'
  vim.fn.setreg('/', [[\V]] .. vim.fn.escape(vim.fn.getreg('"'), [[\]]))
  vim.cmd 'set hlsearch'
  vim.fn.setreg('"', yank_reg)
  vim.fn.setpos('.', p)
end, { 'silent' })

-- replace search matches
ki.n('<leader>r', ':%s///g<left><left>')
ki.x('<leader>r', ':s///g<left><left>')

--               misc               --
--------------  --/-<@  --------------

-- stay in visual mode when indenting
ki.x('<', '<gv')
ki.x('>', '>gv')

-- consistency
ki.n('U', '<c-r>')
ki.n('Y', 'y$')

-- fixes
ki.n('<c-f>', 'J', { 'verbose' } )


-- my special comment line function, heading, total width=79 (80?) =====s
-- fold function with preview
-- nb: ';' is free in normal (i think)
