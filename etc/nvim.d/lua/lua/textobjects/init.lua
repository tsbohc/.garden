local textobject = require("misc.textobject")
local cursor = require("misc.cursor")
local function _quote(xs)
  local cpos = cursor.get()
  local re = ("\\V" .. table.concat({"\""}, "\\|"))
  local d1 = cursor.search(re, "cbW")
  local d2 = cursor.search(("\\V" .. d1.c), "zW")
  if (d1 and d2) then
    local x = d1.p
    local y = d2.p
    cursor.set(cpos)
    return x, y
  end
end
do
  local ZEST_VLUA_0_
  do
    local ZEST_ID_0_ = "_105_113_"
    local function _0_()
      return textobject("inside", _quote())
    end
    _G._zest["textobject"][ZEST_ID_0_] = _0_
    ZEST_VLUA_0_ = ("v:lua._zest.textobject." .. ZEST_ID_0_)
  end
  local ZEST_RHS_0_ = string.format(":<c-u>call %s()<cr>", ZEST_VLUA_0_)
  vim.api.nvim_set_keymap("x", "iq", ZEST_RHS_0_, {noremap = true, silent = true})
  vim.api.nvim_set_keymap("o", "iq", ZEST_RHS_0_, {noremap = true, silent = true})
end
do
  local ZEST_VLUA_0_
  do
    local ZEST_ID_0_ = "_97_113_"
    local function _0_()
      return textobject("around", _quote())
    end
    _G._zest["textobject"][ZEST_ID_0_] = _0_
    ZEST_VLUA_0_ = ("v:lua._zest.textobject." .. ZEST_ID_0_)
  end
  local ZEST_RHS_0_ = string.format(":<c-u>call %s()<cr>", ZEST_VLUA_0_)
  vim.api.nvim_set_keymap("x", "aq", ZEST_RHS_0_, {noremap = true, silent = true})
  vim.api.nvim_set_keymap("o", "aq", ZEST_RHS_0_, {noremap = true, silent = true})
end
local ZEST_VLUA_0_
do
  local ZEST_ID_0_ = "_113_"
  local function _0_()
    return textobject("inner", _quote())
  end
  _G._zest["textobject"][ZEST_ID_0_] = _0_
  ZEST_VLUA_0_ = ("v:lua._zest.textobject." .. ZEST_ID_0_)
end
local ZEST_RHS_0_ = string.format(":<c-u>call %s()<cr>", ZEST_VLUA_0_)
vim.api.nvim_set_keymap("x", "q", ZEST_RHS_0_, {noremap = true, silent = true})
return vim.api.nvim_set_keymap("o", "q", ZEST_RHS_0_, {noremap = true, silent = true})