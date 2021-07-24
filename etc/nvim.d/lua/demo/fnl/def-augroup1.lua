do
  vim.api.nvim_command(("augroup " .. "my-augroup"))
  vim.api.nvim_command("autocmd!")
  do
  end
  vim.api.nvim_command("augroup END")
end
return 42