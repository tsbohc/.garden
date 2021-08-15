--        .
--  __   __)
-- (. | /o ______  __  _.
--    |/<_/ / / <_/ (_(__
--    |
--

local cmd, fn = vim.cmd, vim.fn

-- ensure packer is installed
-- TODO move this to misc.packer? it will compile without this anyway
local packer_path = fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"
if fn.empty(fn.glob(packer_path)) > 0 then
  cmd("!git clone https://github.com/wbthomason/packer.nvim " .. packer_path)
  cmd("packadd packer.nvim")
end

-- i should move zest.setup to a macro maybe

-- initialise zest
_G.zest = {
  ["#"] = 1,
  keymap = {},
  autocmd = {},
  user = {}
}

-- TODO old deps
_G._zest = {
  v = {["#"] = 1}
}

-- setup automagic fennel compilation
-- TODO os.getenv("DOTFILES") or something
cmd([[
augroup bayleaf
  autocmd!
  autocmd BufWritePost /home/sean/.garden/etc/nvim/fnl/*.fnl :silent !bayleaf "%:p"
  autocmd BufWritePost /home/sean/.garden/etc/nvim/fnl/*.lua :silent !bayleaf "%:p"
augroup END]])

-- load the config
local modules = {
  "core.options",
  "core.keymaps",
  "core.autocmds",
  "core.statusline",
  "core.textobjects",
  "core.operators",
  "misc.packer"
}

for _, m in ipairs(modules) do
  local ok, out = pcall(require, m)
  if not ok then
    print("Error while loading '" .. m .. "':\n" .. out)
  end
end


--local packer_path = fn.stdpath("data") .. "/site/pack/packer"
--function install(kind, user, repo)
--  local path = packer_path .. "/" .. kind .. "/" .. repo
--  if fn.empty(fn.glob(path)) > 0 then
--    cmd("!git clone https://github.com/" .. user .. "/" .. repo .. " " .. path)
--    cmd("packadd " .. repo)
--  end
--end
--
--install("opt", "wbthomason", "packer.nvim")
--install("start", "tsbohc", "zest.nvim")

