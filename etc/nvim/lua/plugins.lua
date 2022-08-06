local function plugins(use, auc)
  -- syntax
  auc { '~/code/slate', requires = 'rktjmp/lush.nvim' }
  auc { 'nvim-treesitter/nvim-treesitter' }

  -- completion and snippets
  auc { -- TODO: see about new cmp modules
    'hrsh7th/nvim-cmp',
    requires = {
      { 'hrsh7th/cmp-path' },
      { 'hrsh7th/cmp-cmdline' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-nvim-lua' },
      { 'hrsh7th/cmp-nvim-lsp' },
    }
  }

  auc { 'L3MON4D3/LuaSnip', requires = 'saadparwaiz1/cmp_luasnip' }

  -- parensea
  -- auc { 'eraserhd/parinfer-rust', run = 'cargo build --release' }
  auc { 'guns/vim-sexp' }
  auc { 'bakpakin/fennel.vim' }
  auc { 'janet-lang/janet.vim' }

  -- niceties
  auc { 'numToStr/Comment.nvim' }
  auc { 'lukas-reineke/indent-blankline.nvim' }
  auc { 'svban/YankAssassin.vim' }

  auc { 'dhruvasagar/vim-table-mode' }

  -- fuzzy
  -- use {
  --   'ibhagwan/fzf-lua',
  --   config = function()
  --     require('fzf-lua').setup {
  --       winopts = {
  --         split = "belowright new"
  --       }
  --     }
  --   end
  -- }
  auc {
     'nvim-telescope/telescope.nvim',
     requires = {
        { 'nvim-lua/plenary.nvim' },
        { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
     },
  }

  -- git
  auc {
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' }
  }

  auc {
    'andymass/vim-matchup'
  }

  -- lsp
  auc {
    'neovim/nvim-lspconfig',
    requires = {
      'williamboman/nvim-lsp-installer',
      'ray-x/lsp_signature.nvim'
    },
    config = function() require('lsp') end
  }
  auc {
    'jose-elias-alvarez/null-ls.nvim',
    requires = { 'nvim-lua/plenary.nvim' }
  }

  -- tex
   use {
     'lervag/vimtex',
     config = [[vim.g.vimtex_view_method = 'zathura']]
   }

  -- hmm
  use {
    'rlane/pounce.nvim',
    config = function()
      vim.cmd [[
        nmap t <cmd>Pounce<CR>
        nmap T <cmd>PounceRepeat<CR>
      ]]
      require('pounce').setup {
        accept_keys = "NTESIRKVHDOAMCLPUFYWXZQBGJ",
        accept_best_key = "<enter>",
        multi_window = true,
        debug = false,
      }
    end,
  }
end


-- bootstrapping packer
local fn = vim.fn
local path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(path)) > 0 then
  BOOTSTRAP = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', path })
  print 'packer bootstrapped'
end

vim.cmd 'packadd packer.nvim'

local ok, packer = pcall(require, "packer")
if not ok then return end

packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

vim.cmd([[
  augroup packer_auto_compile
    autocmd!
    autocmd BufWritePost */lua/plugins.lua,*/lua/paq/*.lua source <afile> | PackerCompile
  augroup end
]])

packer.startup(function(use)
  local function auc(package)
    if type(package) == 'string' then package = { package } end
    if not package.config and fn.glob(vim.fn.stdpath('config') .. '/lua/paq/' .. package[1]:gsub('.*/', ''):gsub('-', '_'):gsub('%.', '_') .. '.lua') ~= '' then
      package.config = function(p)
        require('paq.' .. p:gsub('.*/', ''):gsub('-', '_'):gsub('%.', '_'))
      end
    end
    use(package)
  end

  use 'wbthomason/packer.nvim'
  use 'lewis6991/impatient.nvim'
  local ok, impatient = pcall(require, 'impatient')
  if ok then impatient.enable_profile() end

  plugins(use, auc)

  if BOOTSTRAP then packer.sync() end
end)
