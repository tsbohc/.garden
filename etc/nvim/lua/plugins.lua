return function(use)
  -- personal
  use { '~/code/slate', requires = 'rktjmp/lush.nvim' }
  use { '~/code/limestone', requires = 'rktjmp/lush.nvim' }

  -- treesitter
  use { 'nvim-treesitter/nvim-treesitter',
    config = function() require('paq.treesitter_') end
  }

  -- lsp
  use { 'neovim/nvim-lspconfig',
    requires = 'williamboman/nvim-lsp-installer',
    config = function() require('lsp') end
  }

  -- completion & snippets
  use { 'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-nvim-lsp',
      -- nb: nvim-cmp requires a snippet engine
      { 'L3MON4D3/LuaSnip', requires = { 'saadparwaiz1/cmp_luasnip' } }
    },
    config = function() require('paq.cmp_') end
  }

  -- code
  use { 'lukas-reineke/indent-blankline.nvim',
    config = function() require('paq.indent_blankline_') end
  }

  use { 'lewis6991/gitsigns.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function() require('paq.gitsigns_') end
  }

  -- goodies
  use { 'echasnovski/mini.nvim', branch = 'stable' }
  require('mini.comment').setup {
    mappings = {
      comment = 'mc',
      comment_line = 'mcc',
      textobject = 'mc'
    }
  }

  -- themedev
  use 'nvim-treesitter/playground'
end
