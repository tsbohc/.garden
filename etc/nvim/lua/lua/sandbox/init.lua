do
  local zest_keymap_0_
  local function _0_()
    return print("m")
  end
  zest_keymap_0_ = {f = _0_, lhs = "<c-m>", modes = "nvo", opts = {noremap = true}, rhs = ":call v:lua._zest.keymap.iJkBsYGp.f()<cr>"}
  _G._zest.keymap["iJkBsYGp"] = zest_keymap_0_
  vim.api.nvim_set_keymap("n", zest_keymap_0_.lhs, zest_keymap_0_.rhs, zest_keymap_0_.opts)
  vim.api.nvim_set_keymap("v", zest_keymap_0_.lhs, zest_keymap_0_.rhs, zest_keymap_0_.opts)
  vim.api.nvim_set_keymap("o", zest_keymap_0_.lhs, zest_keymap_0_.rhs, zest_keymap_0_.opts)
end
return 42