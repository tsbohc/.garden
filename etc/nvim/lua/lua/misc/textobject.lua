local cursor = require("misc.cursor")
local M = {}
local function normal_21(s)
  return vim.api.nvim_command(("normal! " .. s))
end
M.inner = function(key, f)
  local ZEST_VLUA_0_
  do
    local ZEST_ID_0_
    local function _0_(ZEST_C_0_)
      return string.format("%s_", string.byte(ZEST_C_0_))
    end
    ZEST_ID_0_ = ("_" .. string.gsub(key, ".", _0_))
    local function _1_()
      local x, y = f()
      if (x and y) then
        cursor.set(y)
        normal_21("v")
        return cursor.set(x)
      end
    end
    _G._zest["keymap"][ZEST_ID_0_] = _1_
    ZEST_VLUA_0_ = ("v:lua._zest.keymap." .. ZEST_ID_0_)
  end
  local ZEST_RHS_0_ = string.format(":call %s()<cr>", ZEST_VLUA_0_)
  for ZEST_M_0_ in string.gmatch("xo", ".") do
    vim.api.nvim_set_keymap(ZEST_M_0_, key, ZEST_RHS_0_, {noremap = true, silent = true})
  end
  return nil
end
M.around = function(key, f)
  local ZEST_VLUA_0_
  do
    local ZEST_ID_0_
    local function _0_(ZEST_C_0_)
      return string.format("%s_", string.byte(ZEST_C_0_))
    end
    ZEST_ID_0_ = ("_" .. string.gsub(key, ".", _0_))
    local function _1_()
      local x, y = f()
      if (x and y) then
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
    _G._zest["keymap"][ZEST_ID_0_] = _1_
    ZEST_VLUA_0_ = ("v:lua._zest.keymap." .. ZEST_ID_0_)
  end
  local ZEST_RHS_0_ = string.format(":call %s()<cr>", ZEST_VLUA_0_)
  for ZEST_M_0_ in string.gmatch("xo", ".") do
    vim.api.nvim_set_keymap(ZEST_M_0_, key, ZEST_RHS_0_, {noremap = true, silent = true})
  end
  return nil
end
M.inside = function(key, f)
  local ZEST_VLUA_0_
  do
    local ZEST_ID_0_
    local function _0_(ZEST_C_0_)
      return string.format("%s_", string.byte(ZEST_C_0_))
    end
    ZEST_ID_0_ = ("_" .. string.gsub(key, ".", _0_))
    local function _1_()
      local x, y = f()
      if (x and y) then
        cursor.set(y)
        normal_21("hv")
        cursor.set(x)
        return normal_21("l")
      end
    end
    _G._zest["keymap"][ZEST_ID_0_] = _1_
    ZEST_VLUA_0_ = ("v:lua._zest.keymap." .. ZEST_ID_0_)
  end
  local ZEST_RHS_0_ = string.format(":call %s()<cr>", ZEST_VLUA_0_)
  for ZEST_M_0_ in string.gmatch("xo", ".") do
    vim.api.nvim_set_keymap(ZEST_M_0_, key, ZEST_RHS_0_, {noremap = true, silent = true})
  end
  return nil
end
return M