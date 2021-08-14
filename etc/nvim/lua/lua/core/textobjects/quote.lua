local b = require("rc.textobjects.base")
local M = {}
local function re(xs)
  return ("\\V" .. table.concat(xs, "\\|"))
end
M.quote = function(xs)
  local cpos = b["get-cu"]()
  local re0 = re(xs)
  local d1 = b.search(re0, "cbW")
  local d2 = b.search(("\\V" .. d1.c), "zW")
  if (d1 and d2) then
    local x = d1.p
    local y = d2.p
    return x, y
  else
    return b["set-cu"](cpos)
  end
end
local function _0_(_, ...)
  return M.quote(...)
end
setmetatable(M, {__call = _0_})
return M