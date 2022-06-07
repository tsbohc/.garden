-- bootstrapping packer
local fn = vim.fn
local path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(path)) > 0 then
  BOOTSTRAP = fn.system({
    'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', path
  })
  print 'packer bootstrapped'
end

vim.cmd 'packadd packer.nvim'

local ok, packer = pcall(require, "packer")
if not ok then return end

-- packer settings
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- goodies TODO: fix autocmd paths
-- vim.cmd([[
--   augroup packer_auto_compile
--     autocmd!
--     autocmd BufWritePost */nvim/lua/paq/*.lua,*/nvim/lua/lsp/*.lua,*/nvim/lua/plugins.lua source <afile> | PackerCompile
--   augroup end
-- ]])

-- plugins
return packer.startup(function(use)
  use { 'wbthomason/packer.nvim' }
  require('plugins')(use)
  if BOOTSTRAP then packer.sync() end
end)
