--        .
--  __   __)
-- (. | /o ______  __  _.
--    |/<_/ / / <_/ (_(__
--    |
--

-- TODO fix this
-- initialise zest
_G.zest = {
  ["#"] = 1,
  keymap = {},
  autocmd = {},
  user = {}
}

-- TODO remove old deps
_G._zest = {
  v = {["#"] = 1}
}

-- setup automagic fennel compilation
-- TODO os.getenv("DOTFILES") or something
vim.cmd([[
augroup bayleaf
  autocmd!
  autocmd BufWritePost /home/sean/.garden/etc/nvim/config/*.fnl :silent !bayleaf "%:p"
  autocmd BufWritePost /home/sean/.garden/etc/nvim/config/*.lua :silent !bayleaf "%:p"
augroup END]])

-- load the config
-- TODO i'm still thinking about lazyloading everything
-- like loading keymaps on the first keypress
local modules = {
  "plugins",
  "core.options",
  "core.keymaps",
  "core.autocmds",
  "core.statusline",
  "core.textobjects",
  "core.operators",
}

for _, m in ipairs(modules) do
  local ok, out = pcall(require, m)
  if not ok then
    print("Error while loading '" .. m .. "':\n" .. out)
  end
end
