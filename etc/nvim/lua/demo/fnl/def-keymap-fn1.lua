do
  local ZEST_VLUA_0_
  do
    local ZEST_ID_0_ = "_60_99_45_109_62_110_"
    local function _0_()
      return print("hello from fennel!")
    end
    _G._zest["keymap"][ZEST_ID_0_] = _0_
    ZEST_VLUA_0_ = ("v:lua._zest.keymap." .. ZEST_ID_0_)
  end
  local ZEST_RHS_0_ = (":call " .. ZEST_VLUA_0_ .. "()<cr>")
  vim.api.nvim_set_keymap("n", "<c-m>", ZEST_RHS_0_, {noremap = true})
end
return 42