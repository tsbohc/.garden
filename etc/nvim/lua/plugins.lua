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
  -- TODO i'm sold on comment.nvim, so... this will go
  use { 'echasnovski/mini.nvim', branch = 'stable' }
  require('mini.comment').setup {
    mappings = {
      comment = 'mc',
      comment_line = 'mcc',
      textobject = 'mc'
    }
  }
  -- require('mini.tabline').setup {
  --   show_icons = false
  -- }

  use { 'nvim-telescope/telescope.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function() require('paq.telescope_') end
  }

  -- {{{
  -- use { 'romgrk/barbar.nvim',
  --   config = function()
  --     vim.g.bufferline = {
  --       animation = false,
  --       icons = false,
  --       icon_separator_active = '▎',
  --       icon_separator_inactive = '▎',
  --       icon_close_tab = '×',
  --       icon_close_tab_modified = '+',
  --       icon_pinned = '車',
  --     }
  --   end
  -- }

  -- use { 'akinsho/bufferline.nvim',
  --   config = function()
  --     require('bufferline').setup {
  --       highlights = {
  --         fill = { guibg = { attribute = 'bg', highlight = 'Pmenu' } },
  --         background =  { guibg = { attribute = 'bg', highlight = 'Pmenu' } },
  --         tab =  { guibg = { attribute = 'bg', highlight = 'Pmenu' } },
  --         separator =  { guibg = { attribute = 'bg', highlight = 'Pmenu' } },
  --         tab_selected =  { gui = 'underline' },
  --         pick =  { gui = 'underline' },
  --       },
  --       options = {
  --         indicator_icon = '▏',
  --         buffer_close_icon = '×',
  --         modified_icon = '+',
  --         close_icon = 'X',
  --         left_trunc_marker = '<',
  --         right_trunc_marker = '>',
  --
  --         diagnostics = false,
  --         show_buffer_icons = false,
  --         show_close_icon = false,
  --       }
  --     }
  --   end
  -- }
  -- }}}

  use { 'noib3/nvim-cokeline',
    config = function()
      local get_hex = require('cokeline/utils').get_hex
      local is_picking_focus = require('cokeline/mappings').is_picking_focus
      local is_picking_close = require('cokeline/mappings').is_picking_close

      require('cokeline').setup({
        default_hl = {
          focused = {
            fg = get_hex('Normal', 'fg'),
            bg = get_hex('Normal', 'bg'),
          },
          unfocused = {
            fg = get_hex('Comment', 'fg'),
            bg = get_hex('Pmenu', 'bg'),
          },
        },

        components = {
          --{ text = function(buffer) return (buffer.index ~= 1) and '▏ ' or ' ' end },
          { text = '▏ ' },
          {
            text = function(buffer) return buffer.unique_prefix end,
            hl = {
              fg = get_hex('Comment', 'fg'),
              style = 'italic',
            },
          },
          {
            text = function(buffer)
              if buffer.filename == '[No Name]' then
                return '<new> '
              else
                return buffer.filename .. ' '
              end
            end
          },
          {
            text = function(buffer)
              return (is_picking_focus() or is_picking_close()) and buffer.pick_letter or '×'
            end,
            hl = {
              fg = function(buffer)
                return (is_picking_focus() or is_picking_close()) and get_hex('Normal', 'fg') or get_hex('Comment', 'fg')
              end
            },
            delete_buffer_on_left_click = true
          },
          { text = '  ' }
        },
      })
    end,
  }

  -- whichkey maybe?

  -- themedev
  use 'nvim-treesitter/playground'
end
