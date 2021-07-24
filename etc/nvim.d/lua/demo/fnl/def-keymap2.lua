for _, k in ipairs({"h", "j", "k", "l"}) do
  vim.api.nvim_set_keymap("n", ("<c-" .. k .. ">"), ("<c-w>" .. k), {noremap = true})
end
return 42