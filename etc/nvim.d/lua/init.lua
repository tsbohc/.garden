do
  local z = require("zest")
  z.setup({source = (vim.env.HOME .. "/.garden/etc/nvim.d/fnl"), target = (vim.env.HOME .. "/.garden/etc/nvim.d/lua")})
end
local modules = {"options", "keymaps", "autocmds", "statusline", "textobjects", "operators", "plugins"}
for _, m in ipairs(modules) do
  local ok_3f, out = pcall(require, m)
  if not ok_3f then
    print(("error while loading '" .. m .. "' module:\n" .. out))
  end
end
local function compiled_fennel(path)
  if path then
    local handle = assert(io.popen(("fennel --compile " .. path)))
    local function close_handlers_0_(ok_0_, ...)
      handle:close()
      if ok_0_ then
        return ...
      else
        return error(..., 0)
      end
    end
    local function _0_()
      return handle:read("*a")
    end
    return close_handlers_0_(xpcall(_0_, (package.loaded.fennel or debug).traceback))
  end
end
local function put(s)
  vim.fn.setreg("a", s, "l")
  return vim.cmd("norm! \"ap")
end
local function _0_(...)
  local ZEST_ID_0_ = ("_" .. _G._zest.v["#"])
  local function _1_()
    local code = compiled_fennel(vim.fn.expand("%:p"))
    if (vim.fn.bufnr("compiled") == -1) then
      vim.cmd(":vs compiled")
      vim.cmd("setlocal buftype=nofile")
      vim.cmd("setlocal noswapfile")
      vim.cmd("setlocal ft=lua")
      put(code)
      return vim.cmd("noautocmd wincmd p")
    else
      vim.cmd("noautocmd wincmd p")
      vim.cmd("norm! ggVGd")
      put(code)
      return vim.cmd("noautocmd wincmd p")
    end
  end
  _G._zest["v"][ZEST_ID_0_] = _1_
  _G._zest["v"]["#"] = (_G._zest.v["#"] + 1)
  return ("v:lua._zest.v." .. ZEST_ID_0_)
end
return vim.cmd(string.format(":command FennelToLua :call %s()", _0_(...)))