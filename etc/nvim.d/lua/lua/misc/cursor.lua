local M = {}
M.get = function()
  return vim.fn.getpos(".")
end
M.set = function(p)
  vim.fn.setpos(".", p)
  return nil
end
M.char = function(d)
  local d0 = (d or 0)
  local l = vim.fn.getline(".")
  local n = (d0 + vim.fn.col("."))
  return vim.fn.strcharpart(l:sub(n, n), 0, 1)
end
M.search = function(re, ...)
  local p = vim.fn.searchpos(re, ...)
  local _0_ = p
  if ((type(_0_) == "table") and ((_0_)[1] == 0) and ((_0_)[2] == 0)) then
    return nil
  else
    local _ = _0_
    return {c = M.char(), p = {0, p[1], p[2], 0}}
  end
end
return M