--        .
--  __   __)
-- (. | /o ______  __  _.
--    |/<_/ / / <_/ (_(__
--    |
--

-- TODO os.getenv("DOTGARDEN") or something
-- setup automagic fennel compilation
vim.cmd([[
augroup bayleaf
  autocmd!
  autocmd BufWritePost /home/sean/.garden/etc/nvim/config/*.fnl :silent !bayleaf "%:p"
  autocmd BufWritePost /home/sean/.garden/etc/nvim/config/*.lua :silent !bayleaf "%:p"
augroup END]])

---- initialise zest
require('zest')

-- compatible with pure
--_G.zest = (_G.zest or {["#"] = 1, autocmd = {}, impure = {}, keymap = {}, user = {}})

local modules = {
  "plugins",
  "core.options",
  "core.keymaps",
  "core.autocmds",
  "core.statusline",
  "core.textobjects",
  "core.operators",
  "test"
}

-- should be a separate module that's loaded if something goes wrong
local function rescue()
  local keys = {
    F = 'E', f = 'e',
    J = 'F', j = 'f',
    L = 'L', l = 'l',
    N = '<c-u>', n = 'j',
    E = '<c-d>', e = 'k',
    I = 'L', i = 'l',
    K = 'N', k = 'n',
    H = '0', I = '$'
  }
end

for _, m in ipairs(modules) do
  local ok, out = pcall(require, m)
  if not ok then
    print("Error while loading '" .. m .. "':\n" .. out)
  end
end

--local lime = require('lime')
--
--lime.def_keymap('n', { noremap = true }, '<c-m>', ':echo "keymap-str-r"<cr>')
--
--lime.def_keymap('n', { noremap = true }, '<c-m>', function()
--  print('keymap-fn-r')
--end)
--
--lime.def_augroup('test-r', function()
--  lime.def_autocmd({ 'BufLeave', 'BufEnter' }, '*', function()
--    print('runtime-augroup-1')
--  end)
--  lime.def_autocmd({ 'BufLeave', 'BufEnter' }, '*', function()
--    print('runtime-augroup-2')
--  end)
--end)
