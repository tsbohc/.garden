do
  local ZEST_VLUA_0_
  do
    local ZEST_ID_0_ = "_107_"
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
  local ZEST_RHS_0_ = string.format("%s()", ZEST_VLUA_0_)
  for ZEST_M_0_ in string.gmatch("nv", ".") do
    vim.api.nvim_set_keymap(ZEST_M_0_, "k", ZEST_RHS_0_, {expr = true, noremap = true})
  end
end
return 42