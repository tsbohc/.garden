local ki = require 'lib.ki'

-- keymaps
-- ════════════════════════════════════════════════════════════════

-- i need more space :>
vim.g.mapleader = ' ' -- (sorry)

-- ................................. land of opinionated navigation

-- smart v-line movement
ki.nx('n', function()
  if vim.v.count > 0 then return 'j' else return 'gj' end
end, { 'expr' })

ki.nx('e', function()
  if vim.v.count > 0 then return 'k' else return 'gk' end
end, { 'expr' })

-- NOTE: terminal has to send different codes for <c-i> and tab
for k, v in pairs({ h = 'h', n = 'j', e = 'k', i = 'l' }) do
  ki.n('<c-' .. k .. '>', '<c-w>' .. v)
  ki.n('<c-w>' .. k, '<c-w>' .. v:upper())
end

-- screen and line movement
ki.nx('H', '0')
ki.nx('N', '<c-d>')
ki.nx('E', '<c-u>')
ki.nx('I', '$')

-- ....................................... direct text manipulation

-- shimmy the current line up and down
ki.i('<c-s-n>', '<Esc>:m .+1<CR>==gi')
ki.i('<c-s-e>', '<Esc>:m .-2<CR>==gi')

-- same for visualy selected text
ki.x('<c-s-n>', [[:m '>+1<cr>gv=gv]])
ki.x('<c-s-e>', [[:m '<-2<cr>gv=gv]])

-- stay in visual mode when indenting
ki.x('<', '<gv')
ki.x('>', '>gv')

-- ............................................. search and replace

ki.nx('//', ':nohlsearch<cr>', { 'silent' })

-- keep cursor position when norm! *
ki.n('*', function()
  local p = vim.fn.getpos '.'
  vim.cmd 'norm! *'
  vim.fn.setpos('.', p)
end)

-- search for visually selected text non-magically
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
ki.n('<leader>rr', ':%s///g<left><left>')
ki.x('<leader>rr', ':s///g<left><left>')

-- .................................................. miscellaneous

ki.n('<leader>rs', function() vim.lsp.buf.rename() end)

-- consistency
ki.n('U', '<c-r>')
ki.n('Y', 'y$')

-- fixes
ki.n('<c-j>', 'J')

ki.n('<leader>f', '<Plug>(cokeline-pick-focus)', { 'silent', 'remap' })

-- my special comment line function, heading, total width=71 (80?) =s
-- fold function with preview
-- nb: ';' is free in normal (i think)

-- local function shell(cmd)
--    local handle = io.popen(cmd)
--    local result = handle:read('*a')
--    handle:close()
--    return (result ~= '' and result)
-- end

-- AsyncRun auto qf open instead of doing it ourselves
-- vim.g.asyncrun_open = 4
function _G.myasyncrunexit()
   local qf = vim.fn.getqflist()

   if #qf > 0 then
      vim.cmd[[botright cwin]]
      vim.cmd[[cc]]

      if vim.w.quickfix_title then
         vim.cmd[[wincmd p]]
      end
   end
end

vim.g.asyncrun_exit = 'lua _G.myasyncrunexit()'

ki.n('<leader>m', function()
   vim.cmd[[compiler lua]]
   vim.cmd[[AsyncRun -strip love .]]
   vim.cmd[[cclose]]
   -- vim.cmd[[botright cwin]] -- make quickfix list span the whole window
   -- vim.cmd[[cc]] -- focus next error

   -- return back to prev buffer if we end up in the qf window
   -- if vim.w.quickfix_title then
   --    vim.cmd[[wincmd p]]
   -- end
end, { 'silent' })

-- quickfix keymaps
ki.n('<leader>qn', ':cnext<cr>')
ki.n('<leader>qe', ':cprev<cr>')

vim.cmd[[
   augroup QuickFix
        au FileType qf map <buffer> o <cr><c-w>p
   augroup END
]]

-- comment styles are greatly inspired by thedarnedestthing.com

vim.api.nvim_create_user_command(
   'H1',
   function(opts)
      local c = vim.o.commentstring:match('(.+)%%s'):gsub('%s+', '') .. ' '
      local s = opts.args
      local out = c .. string.rep('═', 67 - c:len())
      vim.fn.setline('.', c .. s)
      vim.fn.append('.', out)
   end,
   { nargs = 1 }
)

vim.api.nvim_create_user_command(
   'H2',
   function(opts)
      local c = vim.o.commentstring:match('(.+)%%s') .. ' '
      local s = ' ' .. opts.args
      local out = c .. string.rep('.', 67 - c:len() - s:len()) .. s
      vim.fn.setline('.', out)
   end,
   { nargs = 1 }
)


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
