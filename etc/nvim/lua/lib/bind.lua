-- local M = { _n = 0 }
--
-- _bindtable = {}
--
-- function M.bind(kind, data)
--   M._n = M._n + 1
--   local id = '_' .. M._n
--   if type(data.rhs) == 'function' then
--     local vlua = 'v:lua._bindtable.' .. id .. '.fn'
--     if kind == 'autocmd' then
--       vlua = ':call ' .. vlua .. '()'
--     elseif kind == 'keymap' then
--       if data.opt.expr then
--         vlua = vlua .. '()'
--       else
--         vlua = ':call ' .. vlua .. '()<cr>'
--       end
--     end
--     data.fn = data.rhs
--     data.rhs = vlua
--   end
--   _bindtable[id] = data
--   return data
-- end
--
-- return M.bind

local M = {}
local bindtable = {}
--local n = 0

function M.exec(n, ...)
  --print(type(n))
  --print('called ' .. n)
  return bindtable[n].fn(...)
end

function M.bind(kind, data)
  --n = n + 1
  --local id = '_' .. n
  if type(data.rhs) == 'function' then
    local vlua = 'v:lua.require("lib.bind").exec(' .. #bindtable + 1 .. ')'
    if kind == 'autocmd' then
      vlua = ':call ' .. vlua
    elseif kind == 'keymap' then
      if not data.opt.expr then
        vlua = ':call ' .. vlua .. '<cr>'
      end
    end
    data.fn = data.rhs
    data.rhs = vlua
  end
  --M[id] = data
  table.insert(bindtable, data)
  -- if n == 1 then
  --   print(vim.inspect(M))
  -- end
  return data
end


function M.vlua(fn)
  local data = M.bind('user', { rhs = fn })
  return data.rhs
end


-- TODO make it return a callable metatable that calls the bind function to
-- avoid local bind = require('lib.bind').bind
return M
