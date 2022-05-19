local bind = require('lib.bind').bind

local M = {}

-- a very brief and mediocre explanation
--
-- I use colemak. This essentially means:
--
-- - 'hjkl' are no longer where they should be, so some stuff needs to be
--   moved around.
-- - further keymaps get confusing, e.g having to map '<c-w>j' to '<c-n>'
--   instead of '<c-j>'.
--
-- The following code allows me to map keys after the adjustments have been
-- made, but as if they haven't. Simply put, this makes them instantly
-- portable to qwerty.

-- apply colemak fixes

-- local colemak = {}

local adjustments = {
  n = 'j', e = 'k', i = 'l',
  j = 'f', k = 'n', l = 'i',
  f = 'e',
}

for k, v in pairs(adjustments) do
  local K, V = k:upper(), v:upper()
  -- we do not won't to touch '' (== nvo == nxso) as that'll mess up select mode
  -- and hence snippets too
  vim.api.nvim_set_keymap('n', k, v, { noremap = true })
  vim.api.nvim_set_keymap('n', K, V, { noremap = true })
  vim.api.nvim_set_keymap('x', k, v, { noremap = true })
  vim.api.nvim_set_keymap('x', K, V, { noremap = true })
  vim.api.nvim_set_keymap('o', k, v, { noremap = true })
  vim.api.nvim_set_keymap('o', K, V, { noremap = true })
  -- colemak[v] = k
  -- colemak[V] = K
end

-- switch 'i' to 'm'. nb: plugin mappings need to be adjusted too
vim.api.nvim_set_keymap('o', 'm', 'i', { noremap = true })
vim.api.nvim_set_keymap('o', 'M', 'I', { noremap = true })
vim.api.nvim_set_keymap('x', 'm', 'i', { noremap = true })
vim.api.nvim_set_keymap('x', 'M', 'I', { noremap = true })

-- translate qwerty lhs to colemak lhs based on the applied fixes

-- local function colemak_adjust(s)
--   s = s .. '<>'
--   s = s:gsub('(.-)(%b<>)', function(outside, inside)
--     outside = outside:gsub('.', colemak)
--     local _, _, mod, key = inside:find('<(%a)%-(%a)>')
--     if key and colemak[key] then
--       inside = '<' .. mod .. '-' .. colemak[key] .. '>'
--     end
--     return outside .. inside
--   end)
--   return s:sub(1, -3)
-- end

-- map stuff

M.ki = setmetatable({}, {
  __index = function(self, modes)
    self[modes] = function(lhs, rhs, opt)
      --print(modes, lhs, rhs, opt)
      local _opt = { noremap = true, expr = false }
      local is_verbose = false
      if opt then
        for _, o in ipairs(opt) do
          if o == 'remap' then
            _opt.noremap = false
          elseif o == 'verbose' then
            is_verbose = true
          else
            _opt[o] = true
          end
        end
      end

      local data = bind('keymap', { modes = modes, lhs = lhs, rhs = rhs, opt = _opt })
      --data.lhs = colemak_adjust(data.lhs)

      for m in modes:gmatch('.') do
        if is_verbose then
          print(m, data.lhs, data.rhs, vim.inspect(data.opt))
        end
        vim.api.nvim_set_keymap(m, data.lhs, data.rhs, data.opt)
      end
    end
    return rawget(self, modes)
  end
})

return M.ki

-- -- wishlist
-- -- unmapping by setting nil
--
-- -- maybe instead of
-- -- ki.n('<leader>r', function() end)
-- -- do
-- -- ki.n['<leader>r'] = function() end
-- -- this is a +1 space but looks cleaner. options will still be ugly though
--
-- -- accept a single option as a string, 'silent' instead of { 'silent' }
--
-- -- same map, different modes
-- ki('<leader>r', {
--   n = ':%s///g<left><left>',
--   x = { ':%s///g<left><left>', { 'silent' } } -- shared option overrides
-- }) -- shared options go here
--
-- -- same mode, different maps
-- ki.x {
--   ['<'] = '<gv',
--   ['>'] = { '>gv', { 'silent' } }
-- }