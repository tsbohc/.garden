do
  local ZEST_VLUA_0_
  do
    local ZEST_ID_0_ = "_107_110_118_"
    local function _0_()
      if (vim.v.count > 0) then
        return "k"
      else
        return "gk"
      end
    end
    _G._zest["keymap"][ZEST_ID_0_] = _0_
    ZEST_VLUA_0_ = ("v:lua._zest.keymap." .. ZEST_ID_0_)
  end
  local ZEST_RHS_0_ = (ZEST_VLUA_0_ .. "()")
  local ZEST_OPTS_0_ = {expr = true, noremap = true}
  vim.api.nvim_set_keymap("n", "k", ZEST_RHS_0_, ZEST_OPTS_0_)
  vim.api.nvim_set_keymap("v", "k", ZEST_RHS_0_, ZEST_OPTS_0_)
end
return 42