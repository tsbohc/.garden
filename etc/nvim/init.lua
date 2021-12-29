--        .
--  __   __)
-- (. | /o ______  __  _.
--    |/<_/ / / <_/ (_(__
--    |
--

-- {{{
local function rescue()
  local keys = {
    n = 'j',
    e = 'k',
    I = '$',
    H = '0',
    N = '<c-d>',
    E = '<c-u>',
    ['<c-h>'] = '<c-w>h',
    ['<c-n>'] = '<c-w>j',
    ['<c-e>'] = '<c-w>k',
    ['<c-i>'] = '<c-w>l',
    ['//'] = ':nohlsearch<cr>',
    --U = '<c-r>',
    ['<c-j>'] = 'J',
    i = 'l',
    l = 'i',
    L = 'I',
    f = 'e',
    F = 'E',
    j = 'f',
    J = 'F',
    k = 'n',
    K = 'N',
  }
  for k, v in pairs(keys) do
    vim.api.nvim_set_keymap('n', k, v, { noremap = true })
    vim.api.nvim_set_keymap('v', k, v, { noremap = true })
    vim.api.nvim_set_keymap('o', k, v, { noremap = true })
  end
end

--rescue()
-- }}}

-- au.my_group(function()
--   au.cmd({'BufLeave', 'BufEnter'}, '*', function()
--     print("hello")
--   end)
-- end)
--
-- vf.ex(':com -nargs=* Mycmd :call %s(<f-args>)', function(a)
--   print('hello, ' .. a)
-- end, 'my special cmd') -- accept docstring because it's nice

require('settings')
require('paq')
require('keymaps')

local sl = require('lib.sl')


local active = { }
local inactive = { }

local function fname(_, _)
  local f = vim.fn.expand('%:t')
  if f == '' then
    return '< new >'
  else
    return f
  end
end

local function is_saved(_, _)
  if vim.fn.expand('%:t') ~= '' then
    return '%{&modified?"":"saved"}'
  end
end

table.insert(active, {
  fname,
  events = { 'BufEnter' },
  format = { 0, 1, 1, 0, hl = 'CursorLine' }
})

table.insert(inactive, {
  fname,
  events = { 'BufLeave' },
  format = { 0, 1, 1, 0, hl = 'LineNr' }
})

table.insert(active, {
  is_saved,
  events = { 'BufEnter', 'BufWritePost' },
  format = { 1, 0, 0, 0 }
})

table.insert(inactive, {
  is_saved,
  events = { 'BufLeave' },
  format = { 1, 0, 0, 0 }
})

sl.setup {
  hl_reset = 'LineNr',
  generator = {
    i = inactive,
    a = active,
  },
}








--local b = require('lib.bind')
--print(vim.inspect(b))


-- function W.Keyring(callback)
--   -- get a fresh table with callable keys,
--   -- the key is passed as the first argument to the callback
--   return setmetatable({}, {
--     __index = function(self, key)
--       self[key] = function(...)
--         callback(key, ...)
--       end
--       return rawget(self, key)
--     end
--   })
-- end
