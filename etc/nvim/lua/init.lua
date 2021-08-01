do
  local zest = require("zest")
  local h = vim.env.HOME
  zest.setup({source = (h .. "/.garden/etc/nvim/fnl"), target = (h .. "/.garden/etc/nvim/lua")})
end
local modules = {"options", "keymaps", "autocmds", "statusline", "textobjects", "operators", "plugins"}
for _, m in ipairs(modules) do
  local ok_3f, out = pcall(require, m)
  if not ok_3f then
    print(("error while loading '" .. m .. "':\n" .. out))
  end
end
return 42