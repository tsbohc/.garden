local def_to = require("misc.textobject")
local cursor = require("misc.cursor")
local function _quote()
  local cpos = cursor.get()
  local re = ("\\V" .. table.concat({"\""}, "\\|"))
  local d1 = cursor.search(re, "cbW")
  local d2
  if d1 then
    d2 = cursor.search(("\\V" .. d1.c), "zW")
  else
  d2 = nil
  end
  if (d1 and d2) then
    local x = d1.p
    local y = d2.p
    cursor.set(cpos)
    return x, y
  end
end
def_to.inner("a\"", _quote)
def_to.around("A\"", _quote)
def_to.inside("m\"", _quote)
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
  local c = cursor.char()
  for k, v in pairs(xt) do
    if ((c == k) or (c == v)) then
      local d = {c = c, p = cursor.get()}
      return d
    end
  end
  return nil
end
local function parsearch(xt, v, ...)
  local cpos = cursor.get()
  local counts = parsearch_counts(xt, v)
  local r = ""
  while (r == "") do
    print(r)
    local d = cursor.search(re(xt), ...)
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
    return cursor.set(cpos)
  else
    return r
  end
end
local function form(xt)
  local xt0 = (xt or {["("] = ")", ["["] = "]", ["{"] = "}"})
  local cpos = cursor.get()
  local d1 = (par_oncu(xt0) or parsearch(xt0, -1, "bW") or cursor.search(re(xt0, "only-open"), "zW", vim.fn.line(".")))
  if d1 then
    local xt2 = p[d1.c].d
    local v2 = (-1 * p[d1.c].v)
    local f2
    if (-1 == v2) then
      f2 = "bw"
    else
      f2 = "zw"
    end
    local d2 = parsearch(xt2, v2, f2)
    if d2 then
      local x, y = nil, nil
      if (-1 == v2) then
        x, y = d2.p, d1.p
      else
        x, y = d1.p, d2.p
      end
      cursor.set(cpos)
      return x, y
    else
      return cursor.set(cpos)
    end
  else
    return cursor.set(cpos)
  end
end
def_to.inner("af", form)
def_to.around("Af", form)
return def_to.inside("mf", form)