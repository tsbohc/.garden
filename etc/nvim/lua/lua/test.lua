local zest = require("zest")
local KEY = "<F4>"
local CMD = ":lua vim.g.zest_received = true<cr>"
local EVENT = "User"
local SELECTOR = "ZestTestUserEvent"
local function clear()
  return zest.setup()
end
clear()
_G.zest_tests = {}
local t = {}
t["="] = function(x, y, description)
  if (x == y) then
    return print(("  + " .. description))
  else
    return print((">>>>>>>>>>>>>>> YOU SUCK! " .. description .. "\n" .. "    " .. vim.inspect(x) .. " != " .. vim.inspect(y)))
  end
end
t["?"] = function(x, description)
  if x then
    return print(("  + " .. description))
  else
    return print((">>>>>>>>>>>>>>> YOU SUCK! " .. description .. "\n" .. "    " .. vim.inspect(x)))
  end
end
local function rinput(keys)
  print("\n")
  local raw_keys = vim.api.nvim_replace_termcodes(keys, true, false, true)
  return vim.api.nvim_feedkeys(raw_keys, "mx", false)
end
t.k = function(description)
  rinput(KEY)
  t["?"](vim.g.zest_received, description)
  vim.g["zest_received"] = false
  return clear()
end
local function t_def_keymap()
  do
    local zest_keymap_0_ = {lhs = KEY, modes = "n", opts = {noremap = true}, rhs = ":lua vim.g.zest_received = true<cr>"}
    _G._zest["_1_1628361757"] = zest_keymap_0_
    vim.api.nvim_set_keymap("n", zest_keymap_0_.lhs, zest_keymap_0_.rhs, zest_keymap_0_.opts)
  end
  t.k("var -> str")
  do
    local cmd = CMD
    local zest_keymap_0_ = {lhs = "<F4>", modes = "n", opts = {noremap = true}, rhs = cmd}
    _G._zest["_2_1628361757"] = zest_keymap_0_
    vim.api.nvim_set_keymap("n", zest_keymap_0_.lhs, zest_keymap_0_.rhs, zest_keymap_0_.opts)
  end
  t.k("str -> lowercase var")
  do
    local zest_keymap_0_
    local function _0_()
      vim.g.zest_received = true
      return nil
    end
    zest_keymap_0_ = {f = _0_, lhs = KEY, modes = "n", opts = {noremap = true}, rhs = ":call v:lua._zest._3_1628361757.f()<cr>"}
    _G._zest["_3_1628361757"] = zest_keymap_0_
    vim.api.nvim_set_keymap("n", zest_keymap_0_.lhs, zest_keymap_0_.rhs, zest_keymap_0_.opts)
  end
  t.k("fn")
  do
    local zest_keymap_0_
    local function _0_()
      vim.g.zest_received = true
      return nil
    end
    zest_keymap_0_ = {f = _0_, lhs = KEY, modes = "n", opts = {noremap = true}, rhs = ":call v:lua._zest._4_1628361757.f()<cr>"}
    _G._zest["_4_1628361757"] = zest_keymap_0_
    vim.api.nvim_set_keymap("n", zest_keymap_0_.lhs, zest_keymap_0_.rhs, zest_keymap_0_.opts)
  end
  t.k("hash fn")
  do
    local zest_keymap_0_
    local function _0_(...)
      local function _1_(x)
        vim.g.zest_received = x
        return nil
      end
      return _1_(true, ...)
    end
    zest_keymap_0_ = {f = _0_, lhs = KEY, modes = "n", opts = {noremap = true}, rhs = ":call v:lua._zest._5_1628361757.f()<cr>"}
    _G._zest["_5_1628361757"] = zest_keymap_0_
    vim.api.nvim_set_keymap("n", zest_keymap_0_.lhs, zest_keymap_0_.rhs, zest_keymap_0_.opts)
  end
  t.k("partial fn")
  do
    local zest_keymap_0_
    local function _0_()
      vim.g.zest_received = true
      return nil
    end
    zest_keymap_0_ = {f = _0_, lhs = KEY, modes = "n", opts = {noremap = true}, rhs = ":call v:lua._zest._6_1628361757.f()<cr>"}
    _G._zest["_6_1628361757"] = zest_keymap_0_
    vim.api.nvim_set_keymap("n", zest_keymap_0_.lhs, zest_keymap_0_.rhs, zest_keymap_0_.opts)
  end
  t.k("seq fn")
  local function Testfn()
    vim.g.zest_received = true
    return nil
  end
  do
    local zest_keymap_0_ = {f = Testfn, lhs = KEY, modes = "n", opts = {noremap = true}, rhs = ":call v:lua._zest._7_1628361757.f()<cr>"}
    _G._zest["_7_1628361757"] = zest_keymap_0_
    vim.api.nvim_set_keymap("n", zest_keymap_0_.lhs, zest_keymap_0_.rhs, zest_keymap_0_.opts)
  end
  return t.k("capitalised var")
end
_G["zest_tests"]["t_def-keymap"] = t_def_keymap
for k, v in pairs(_G.zest_tests) do
  print(("" .. k))
  v()
end
return clear()