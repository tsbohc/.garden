local ki = require 'lib.ki'

-- keymaps
-- ════════════════════════════════════════════════════════════════════

-- i need more space :>
vim.g.mapleader = ' ' -- (sorry)

-- ..................................... land of opinionated navigation

-- smart v-line movement
ki.nx('n', function()
  if vim.v.count > 0 then return 'j' else return 'gj' end
end, { 'expr' })

ki.nx('e', function()
  if vim.v.count > 0 then return 'k' else return 'gk' end
end, { 'expr' })

-- simple split switching
-- considering how i don't rely too much on splits, maybe
-- tab-something would be better?
for _, k in ipairs({ 'h', 'j', 'k', 'l' }) do
  ki.n('<c-' .. k .. '>', '<c-w>' .. k)
end

-- screen and line movement
ki.nx('H', '0')
ki.nx('N', '<c-d>')
ki.nx('E', '<c-u>')
ki.nx('I', '$')

-- ........................................... direct text manipulation

-- shimmy the current line up and down
ki.i('<c-n>', '<Esc>:m .+1<CR>==gi')
ki.i('<c-e>', '<Esc>:m .-2<CR>==gi')

-- same for visualy selected text
ki.x('<c-n>', [[:m '>+1<cr>gv=gv]])
ki.x('<c-e>', [[:m '<-2<cr>gv=gv]])

-- stay in visual mode when indenting
ki.x('<', '<gv')
ki.x('>', '>gv')

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
  vim.fn.setreg('/', '\\V' .. vim.fn.escape(vim.fn.getreg('"'), '\\'))
  vim.cmd 'set hlsearch'
  vim.fn.setreg('"', yank_reg)
  vim.fn.setpos('.', p)
end, { 'silent' })

-- replace search matches
ki.n('<leader>r', ':%s///g<left><left>')
ki.x('<leader>r', ':s///g<left><left>')

-- ...................................................... miscellaneous

-- consistency
ki.n('U', '<c-r>')
ki.n('Y', 'y$')

-- fixes
ki.n('<c-j>', 'J')



-- my special comment line function, heading, total width=71 (80?) =s
-- fold function with preview
-- nb: ';' is free in normal (i think)




--

--local cmp = require 'cmp'
--
--local function t(str)
--  return vim.api.nvim_replace_termcodes(str, true, true, true)
--end
--
--local check_back_space = function()
--  local col = vim.fn.col('.') - 1
--  if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
--    return true
--  else
--    return false
--  end
--end
--
--ki.is('<cr>', function()
--  if cmp.visible() then
--    cmp.mapping.confirm({ select = false })
--  end
--  return ''
--end, { 'expr' })
--
--ki.is('<tab>', function()
--  if cmp.visible() then
--    return t "<C-n>"
--  elseif check_back_space() then
--    return t "<Tab>"
--  else
--    cmp.complete()
--  end
--  return ''
--end, { 'expr' })
