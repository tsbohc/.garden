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

require('settings')
require('paq')
require('keymaps')

local sl = require('lib.sl')

local function generator()
  local xs = { }
  local f = sl.format

  local function add(data)
    table.insert(xs, data)
  end

  add(sl.helper.au(
    function()
      local file = vim.fn.expand('%:t')
      if file == '' then
        file = '‹ new ›'
      end
      return f(file, 'CursorLine', { 0, 1, 1, 1 })
    end, { 'BufEnter', 'BufWritePost' }
  ))

  add(sl.helper.au(
    function()
      if vim.fn.expand('%:t') ~= '' then
        return "%{&modified?'':'saved'}"
      end
    end, { 'BufEnter', 'BufWritePost' }
  ))

  add(sl.helper.au(
    function()
      if vim.bo.readonly then
        return f('readonly', 'Search', { 1, 1, 1, 0 })
      end
    end, { 'BufEnter' }
  ))

  -- last time in insert in a buffer
  --add(sl.helper.au(function(w, b)
  --  return f(os.time() .. ' in buf #' .. b, 'Error')
  --end, { 'InsertEnter' }))

  add('%=%<')

  add(sl.helper.au(
    function()
      return f(vim.fn.expand('%:p:~:h') .. '/', { 1, 0, 0, 0 })
    end, { 'BufEnter', 'BufWritePost' }
  ))

  add(sl.helper.au(
    function()
      return f(vim.bo.filetype, { 1, 0, 0, 0 })
    end, { 'BufEnter', 'BufReadPost', 'BufWritePost' }
  ))

  add(f('%2p%%', 'CursorLine', { 1, 1, 1, 0 }))

  return xs
end

sl.setup {
  hl_reset = 'LineNr',
  generator = generator,
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
