do
  vim.api.nvim_command(("augroup " .. "my-dirty-augroup"))
  do
  end
  vim.api.nvim_command("augroup END")
end
return 42