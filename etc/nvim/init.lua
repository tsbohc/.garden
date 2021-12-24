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
-- }}}

--rescue()

require('settings')
require('keymaps')
require('packs')
