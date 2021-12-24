local M = {}

function Keyring(callback)
  -- get a fresh table with callable keys,
  -- the key is passed as the first argument to the callback
  return setmetatable({}, {
    __index = function(self, key)
      self[key] = function(...)
        callback(key, ...)
      end
      return rawget(self, key)
    end
  })
end

-- TODO clean up this mess
-- need a way to clear everything on reload

lime = {}

local n = 0
local function idx()
  n = n + 1
  return '_' .. n
end

local function bind(kind, data)
  local id = idx()
  if type(data.rhs) == 'function' then
    local vlua = 'v:lua.lime.' .. id .. '.fn'
    if kind == 'autocmd' then
      vlua = ':call ' .. vlua '()'
    elseif kind == 'keymap' then
      if data.opt.expr then
        vlua = vlua .. '()'
      else
        vlua = ':call ' .. vlua .. '()<cr>'
      end
    end
    data.fn = data.rhs
    data.rhs = vlua
  end
  lime[id] = data
  return data
end

-- colemak stuff

local colemak = {}

local adjustments = {
  n = 'j', e = 'k', i = 'l',
  j = 'f', k = 'n', l = 'i',
  f = 'e',
}

for k, v in pairs(adjustments) do
  local K, V = k:upper(), v:upper()
  vim.api.nvim_set_keymap('', k, v, { noremap = true })
  vim.api.nvim_set_keymap('', K, V, { noremap = true })
  colemak[v] = k
  colemak[V] = K
end

local function colemak_adjust(s)
  s = s .. '<>'
  s = s:gsub('(.-)(%b<>)', function(outside, inside)
    outside = outside:gsub('.', colemak)
    local _, _, mod, key = inside:find('<(%a)%-(%a)>')
    if key and colemak[key] then
      inside = '<' .. mod .. '-' .. colemak[key] .. '>'
    end
    return outside .. inside
  end)
  return s:sub(1, -3)
end

-- keymap

M.keymap = Keyring(function(modes, lhs, rhs, opt)
  local _opt = { noremap = true, expr = false }
  if opt then
    for _, o in ipairs(opt) do
      if o == 'remap' then _opt.noremap = false else _opt[o] = true end
    end
  end

  local data = bind('keymap', { modes = modes, lhs = lhs, rhs = rhs, opt = _opt })

  --print(data.lhs, data.rhs)
  data.lhs = colemak_adjust(data.lhs)
  --print(data.lhs, data.rhs)

  for m in modes:gmatch('.') do
    vim.api.nvim_set_keymap(m, data.lhs, data.rhs, data.opt)
  end
end)

local ki = M.keymap

--print(vim.inspect(colemak))
-- nb: ';' is free in normal (i think)

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




--[[
-- TODO make ki a callable table and implement this?
ki('e', {
  nv = function()
    if vim.v.count > 0 then return 'k' else return 'gk' end
  end,
  o = 'k'
}

au.my_group(function()
  au.cmd({'BufLeave', 'BufEnter'}, '*', function()
    print("hello")
  end)
end)

vf.ex(':com -nargs=* Mycmd :call %s(<f-args>)', function(a)
  print('hello, ' .. a)
end, 'my special cmd') -- accept docstring because it's nice
--]]

---
