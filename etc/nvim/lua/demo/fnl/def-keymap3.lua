do
  local ZEST_OPTS_0_ = {noremap = true}
  vim.api.nvim_set_keymap("n", "<ScrollWheelUp>", "<c-y>", ZEST_OPTS_0_)
  vim.api.nvim_set_keymap("n", "<ScrollWheelDown>", "<c-e>", ZEST_OPTS_0_)
end
return 42