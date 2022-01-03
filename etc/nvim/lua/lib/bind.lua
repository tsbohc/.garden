local M = {}
local bindtable = {}

function M.bind(kind, data)
   if type(data.rhs) == 'function' then
      local vlua = "v:lua.require'lib.bind'.exec(" .. #bindtable + 1 .. ')'
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
   table.insert(bindtable, data)
   return data
end

function M.vlua(fn)
   local data = M.bind('user', { rhs = fn })
   return data.rhs
end

function M.exec(n, ...)
   return bindtable[n].fn(...)
end

-- TODO make it return a callable metatable that calls the bind function to
-- avoid local bind = require('lib.bind').bind
return M
