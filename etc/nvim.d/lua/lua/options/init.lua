vim.cmd(":syntax enable")
vim.cmd(":colo limestone")
vim.opt["encoding"] = "utf-8"
vim.opt["synmaxcol"] = 256
vim.opt["termguicolors"] = true
vim.opt["number"] = true
vim.opt["relativenumber"] = true
vim.opt["cursorline"] = true
vim.opt["showmatch"] = true
vim.opt["matchtime"] = 2
do end (vim.opt.shortmess):append("IcT")
vim.opt["scrolloff"] = 10
vim.opt["wrap"] = false
vim.opt["virtualedit"] = "block"
vim.opt["undofile"] = true
vim.opt["autoread"] = true
vim.opt["clipboard"] = "unnamedplus"
vim.opt["mouse"] = "a"
do end (vim.opt.completeopt):append({"menuone", "noselect"})
vim.opt["showmode"] = false
vim.opt["laststatus"] = 2
vim.opt["incsearch"] = true
vim.opt["inccommand"] = "nosplit"
vim.opt["hlsearch"] = true
vim.opt["ignorecase"] = true
vim.opt["smartcase"] = true
vim.opt["foldenable"] = true
vim.opt["foldmethod"] = "marker"
vim.opt["tabstop"] = 2
vim.opt["shiftwidth"] = 2
vim.opt["softtabstop"] = 2
vim.opt["expandtab"] = true
vim.opt["listchars"] = {trail = "\226\144\163"}
vim.opt["list"] = true
local built_ins = {getscriptPlugin = "vimball", gzip = "zip", logipat = "rrhelper", netrw = "netrwPlugin", netrwSettings = "netrwFileHandlers", spellfile_plugin = "matchit", tarPlugin = "getscript", vimballPlugin = "2html_plugin", zipPlugin = "tar"}
for _, p in ipairs(built_ins) do
  vim.g[("loaded_" .. p)] = 1
end
return nil