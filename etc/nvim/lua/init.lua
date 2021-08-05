do
  local zest = require("zest")
  local h = vim.env.HOME
  zest.setup({source = (h .. "/.garden/etc/nvim/fnl"), target = (h .. "/.garden/etc/nvim/lua")})
end
local modules = {"options", "keymaps", "autocmds", "statusline", "textobjects", "operators", "plugins", "sandbox"}
vim.fn.sign_define("LspDiagnosticsSignError", {text = "\226\150\145", texthl = "LspDiagnosticsSignError"})
vim.fn.sign_define("LspDiagnosticsSignWarning", {text = "\226\150\145", texthl = "LspDiagnosticsSignWarning"})
vim.fn.sign_define("LspDiagnosticsSignInformation", {text = "\226\150\145", texthl = "LspDiagnosticsSignInformation"})
vim.fn.sign_define("LspDiagnosticsSignHint", {text = "\226\150\145", texthl = "LspDiagnosticsSignHint"})
for _, m in ipairs(modules) do
  local ok_3f, out = pcall(require, m)
  if not ok_3f then
    print(("error while loading '" .. m .. "':\n" .. out))
  end
end
vim.api.nvim_exec("\n  fun! Runcmd(cmd)\n  silent! exe 'topleft vertical pedit previewwindow '.a:cmd\n  noautocmd wincmd P\n  set buftype=nofile\n  set ft=lua\n  exe 'noautocmd r! '.a:cmd\n  noautocmd wincmd p\n  endfun\n  com! -nargs=1 Runcmd :call Runcmd('<args>')\n\n  fun! MyRun()\n  exe 'w'\n  :silent call Runcmd(\"fennel --correlate --add-package-path '/home/sean/code/zest/lua/?.lua' --add-fennel-path '/home/sean/code/zest/fnl/?.fnl' --metadata \" . expand('%:p'))\n  endfun\n\n  fun! Zct()\n  exe 'w'\n  :silent call Runcmd(\"fennel --compile --add-package-path '/home/sean/code/zest/lua/?.lua' --add-fennel-path '/home/sean/code/zest/fnl/?.fnl' --metadata \" . expand('%:p'))\n  endfun\n\n  nnoremap <c-c> :call MyRun()<cr>\n  nnoremap <c-t> :call Zct()<cr>", false)
return 42