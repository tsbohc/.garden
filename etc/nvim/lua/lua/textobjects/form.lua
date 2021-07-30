local b = require("rc.textobjects.base")
local M = {}
local p = {["("] = {d = {["("] = ")"}, k = "r", v = -1}, [")"] = {d = {["("] = ")"}, k = "r", v = 1}, ["["] = {d = {["["] = "]"}, k = "s", v = -1}, ["]"] = {d = {["["] = "]"}, k = "s", v = 1}, ["{"] = {d = {["{"] = "}"}, k = "c", v = -1}, ["}"] = {d = {["{"] = "}"}, k = "c", v = 1}}
local function re(xt, only_open_3f)
  local acc = {}
  for k, v in pairs(xt) do
    table.insert(acc, k)
    if not only_open_3f then
      table.insert(acc, v)
    end
  end
  return ("\\V" .. table.concat(acc, "\\|"))
end
local function parsearch_counts(xt, v)
  local counts = {}
  for q, _ in pairs(xt) do
    counts[p[q].k] = (-1 * v)
  end
  return counts
end
local function par_oncu(xt)
  local c = b.char()
  for k, v in pairs(xt) do
    if ((c == k) or (c == v)) then
      local d = {c = c, p = b["get-cu"]()}
      return d
    end
  end
  return nil
end
local function parsearch(xt, v, ...)
  local cpos = b["get-cu"]()
  local counts = parsearch_counts(xt, v)
  local r = ""
  while (r == "") do
    print(r)
    local d = b.search(re(xt), ...)
    if d then
      local k = p[d.c].k
      local count = counts[k]
      local delta = p[d.c].v
      local sum = (count + delta)
      if (sum == 0) then
        r = d
      else
        counts[k] = sum
      end
    else
      r = false
    end
  end
  if not r then
    return b["set-cu"](cpos)
  else
    return r
  end
end
M.form = function(xt)
  local xt0 = (xt or {["("] = ")", ["["] = "]", ["{"] = "}"})
  local cpos = b["get-cu"]()
  local d1 = (par_oncu(xt0) or parsearch(xt0, -1, "bW") or b.search(re(xt0, "only-open"), "zW", vim.fn.line(".")))
  if d1 then
    local xt2 = p[d1.c].d
    local v2 = (-1 * p[d1.c].v)
    local f2
    if (-1 == v2) then
      f2 = "bW"
    else
      f2 = "zW"
    end
    local d2 = parsearch(xt2, v2, f2)
    if d2 then
      local x, y = nil, nil
      if (-1 == v2) then
        x, y = d2.p, d1.p
      else
        x, y = d1.p, d2.p
      end
      b["set-cu"](cpos)
      return {x = x, y = y}
    else
      return b["set-cu"](cpos)
    end
  else
    return b["set-cu"](cpos)
  end
end
local function _0_(_, ...)
  return M.form(...)
end
setmetatable(M, {__call = _0_})
return M