do
  local ZEST_VLUA_0_
  do
    local ZEST_ID_0_ = "_60_99_45_109_62_"
    local function _0_()
      return print("hello from fennel!")
    end
    _G._zest["keymap"][ZEST_ID_0_] = _0_
    ZEST_VLUA_0_ = ("v:lua._zest.keymap." .. ZEST_ID_0_)
  end
  local ZEST_RHS_0_ = string.format(":call %s()<cr>", ZEST_VLUA_0_)
  for ZEST_M_0_ in string.gmatch("n", ".") do
    vim.api.nvim_set_keymap(ZEST_M_0_, "<c-m>", ZEST_RHS_0_, {noremap = true})
  end
end
return 42