do
  local zest = require("zest")
  local h = vim.env.HOME
  zest.setup({source = (h .. "/.garden/etc/nvim/fnl"), target = (h .. "/.garden/etc/nvim/lua")})
end
local modules = {"core.options", "core.keymaps", "core.autocmds", "core.statusline", "core.textobjects", "core.operators", "misc.packer"}
for _, m in ipairs(modules) do
  local ok_3f, out = pcall(require, m)
  if not ok_3f then
    print(("error while loading '" .. m .. "':\n" .. out))
  end
end
vim.api.nvim_exec("\n  fun! Runcmd(cmd)\n  silent! exe 'topleft vertical pedit previewwindow '.a:cmd\n  noautocmd wincmd P\n  set buftype=nofile\n  set ft=lua\n  exe 'noautocmd r! '.a:cmd\n  noautocmd wincmd p\n  endfun\n  com! -nargs=1 Runcmd :call Runcmd('<args>')\n  fun! MyRun()\n  exe 'w'\n  :silent call Runcmd(\"fennel --correlate --no-compiler-sandbox --add-package-path '/home/sean/code/zest/lua/?.lua' --add-fennel-path '/home/sean/code/zest/fnl/?.fnl' --metadata \" . expand('%:p'))\n  endfun\n  fun! Zct()\n  exe 'w'\n  :silent call Runcmd(\"fennel --compile --no-compiler-sandbox --add-package-path '/home/sean/code/zest/lua/?.lua' --add-fennel-path '/home/sean/code/zest/fnl/?.fnl' --metadata \" . expand('%:p'))\n  endfun\n  nnoremap <c-c> :call MyRun()<cr>\n  nnoremap <c-t> :call Zct()<cr>", false)
return 42