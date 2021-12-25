local ki = require 'lib.ki'

-- keymaps
-- ════════════════════════════════════════════════════════════════════

-- i need more space :>
vim.g.mapleader = ' ' -- (sorry)

-- ..................................... land of opinionated navigation

-- smart v-line movement
ki.nx('k', function()
  if vim.v.count > 0 then return 'k' else return 'gk' end
end, { 'expr' })

ki.nx('j', function()
  if vim.v.count > 0 then return 'j' else return 'gj' end
end, { 'expr' })

-- simple split switching
-- considering how i don't rely too much on splits, maybe
-- tab-something would be better?
for _, k in ipairs({ 'h', 'j', 'k', 'l' }) do
  ki.n('<c-' .. k .. '>', '<c-w>' .. k)
end

-- screen and line movement
ki.nx('H', '0')
ki.nx('J', '<c-d>')
ki.nx('K', '<c-u>')
ki.nx('L', '$')

-- ................................................. search and replace

ki.nx('//', ':nohlsearch<cr>', { 'silent' })

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

-- ...................................................... miscellaneous

-- stay in visual mode when indenting
ki.x('<', '<gv')
ki.x('>', '>gv')

-- consistency
ki.n('U', '<c-r>')
ki.n('Y', 'y$')

-- fixes
ki.n('<c-f>', 'J')


-- my special comment line function, heading, total width=71 (80?) =s
-- fold function with preview
-- nb: ';' is free in normal (i think)
