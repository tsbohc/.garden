local ZEST_LHS_0_ = "<c-m>"
local ZEST_RHS_0_
local _0_
do
  local ZEST_N_0_ = _G._zest["#"]
  local ZEST_ID_0_ = ("keymap_" .. ZEST_N_0_)
  local function _1_()
    return print("yay_sugar")
  end
  _G._zest[ZEST_ID_0_] = {fn = _1_, info = {kind = "keymap", lhs = "<c-m>", modes = "n"}}
  _G._zest["#"] = (ZEST_N_0_ + 1)
  _0_ = ("v:lua._zest." .. ZEST_ID_0_ .. ".fn")
end
ZEST_RHS_0_ = (":call " .. _0_ .. "()<cr>")
local ZEST_OPT_0_ = {noremap = true}
return vim.api.nvim_set_keymap("n", ZEST_LHS_0_, ZEST_RHS_0_, ZEST_OPT_0_)