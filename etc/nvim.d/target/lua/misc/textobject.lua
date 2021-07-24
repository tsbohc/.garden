local cursor = require("misc.cursor")
local M = {}
local function normal_21(s)
  return vim.api.nvim_command(("norm! " .. s))
end
M.textobject = function(kind, x, y)
  if (x and y) then
    local _0_ = kind
    if (_0_ == "inner") then
      cursor.set(y)
      normal_21("v")
      return cursor.set(x)
    elseif (_0_ == "inside") then
      cursor.set(y)
      normal_21("hv")
      cursor.set(x)
      return normal_21("l")
    elseif (_0_ == "around") then
      cursor.set(y)
      local line_len = vim.fn.strwidth(vim.fn.getline("."))
      local at_end_3f = ((y[3] == line_len) or (cursor.char(1) ~= " "))
      if (not at_end_3f and (0 ~= vim.fn.search("\\S", "zW", vim.fn.line(".")))) then
        normal_21("h")
      end
      normal_21("v")
      cursor.set(x)
      if (at_end_3f and (0 ~= vim.fn.search("\\S", "bW", vim.fn.line(".")))) then
        return normal_21("l")
      end
    end
  end
end
local function _0_(_, ...)
  return M.textobject(...)
end
setmetatable(M, {__call = _0_})
return M