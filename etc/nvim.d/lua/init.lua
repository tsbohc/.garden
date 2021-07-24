do
  local ZEST_CONF_0_ = {source = (vim.env.HOME .. "/.garden/etc/nvim.d/fnl"), target = (vim.env.HOME .. "/.garden/etc/nvim.d/lua")}
  local ZEST_DEFAULT_CONF_0_ = {["disable-compiler"] = false, ["verbose-compiler"] = true, source = vim.fn.resolve((vim.fn.stdpath("config") .. "/fnl")), target = vim.fn.resolve((vim.fn.stdpath("config") .. "/lua"))}
  if ZEST_CONF_0_ then
    for ZEST_K_0_, ZEST_V_0_ in pairs(ZEST_CONF_0_) do
      ZEST_DEFAULT_CONF_0_[ZEST_K_0_] = ZEST_V_0_
    end
  end
  _G["_zest"] = {autocmd = {["#"] = 1}, config = ZEST_DEFAULT_CONF_0_, keymap = {}, v = {["#"] = 1}}
end
local modules = {"options", "keymaps", "autocmds", "statusline", "textobjects", "operators", "plugins"}
for _, m in ipairs(modules) do
  local ok_3f, out = pcall(require, m)
  if not ok_3f then
    print(("error while loading '" .. m .. "' module:\n" .. out))
  end
end
local function my_fn()
  return print("dinosaurs")
end
return nil