local g = vim.g

-- ensure packer is installed
local packer_path = vim.fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'
if vim.fn.empty(vim.fn.glob(packer_path)) > 0 then
  vim.fn.system({ 'git', 'clone', 'https://github.com/wbthomason/packer.nvim', packer_path })
end

-- initialise packer
vim.cmd('packadd packer.nvim')
local packer = require('packer')

packer.startup({function(use)
  use { 'wbthomason/packer.nvim', opt = true }

  use { vim.env.HOME .. '/code/zest.nvim/pure' }
  use { vim.env.HOME .. '/code/lime' }

  use { vim.env.HOME .. '/code/limestone',
    requires = 'rktjmp/lush.nvim' }

  -- treesitter
  use { 'nvim-treesitter/nvim-treesitter',
    opt = true,
    event = { 'BufRead', 'BufWritePost' },
    branch = '0.5-compat',
    run = ':TSUpdate',
    config = require('plug.nvim-treesitter') }

  -- lsp
  use { 'jose-elias-alvarez/null-ls.nvim',
    config = require('plug.null-ls'),
    requires = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' } }

  -- completion
  use { 'hrsh7th/nvim-compe',
    opt = true,
    event = 'InsertEnter',
    config = require('plug.nvim-compe') }

  -- code
  use { 'Yggdroot/indentLine',
    config = function()
      vim.g.indentLine_setColors = 0
      vim.g.indentLine_char = '·'
      vim.g.indentLine_fileTypeExclude = { 'markdown' }
    end }

  -- lisp
  use { 'guns/vim-sexp',
    ft = { 'fennel' } }
  require('plug.vim-sexp')()

  -- fennel
  use { 'bakpakin/fennel.vim',
    ft = { 'fennel' } }

  -- profile
  use { 'tweekmonster/startuptime.vim',
    cmd = 'StartupTime' }

end,
config = {
  display = {
    open_fn = require('packer.util').float,
  }
}})

-- yes, i am formatting that lisp-style and you can't stop me
