--[[
nice case statements: http://lua-users.org/wiki/SwitchStatement
--]]

local M = {}

-- get a fresh table with callable keys,
-- the key is passed as the first argument to the callback
function Keyring(callback)
  return setmetatable({}, {
    __index = function(self, key)
      self[key] = function(...)
        callback(key, ...)
      end
      return rawget(self, key)
    end
  })
end

M.keymap = Keyring(function(modes, lhs, rhs, ...)
  print(modes)
  print(...)
end)

local ki = M.keymap

ki.nvo('k', function()
  if vim.v.count > 0 then return 'k' else return 'gk' end
end, { 'silent' })

-- TODO run with env to get silent notsilent etc working? bake them into the callback?

--[[
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
