return function(use) -- personal
   use { '~/code/slate', requires = 'rktjmp/lush.nvim' }
   use { '~/code/limestone', requires = 'rktjmp/lush.nvim' }

   use {
      'nvim-treesitter/nvim-treesitter',
      -- commit = '668de0951a36ef17016074f1120b6aacbe6c4515',
      config = function() require('paq.treesitter_') end
   }

   use {
      'neovim/nvim-lspconfig',
      requires = 'williamboman/nvim-lsp-installer',
      config = function() require('lsp') end
   }

   use {
      'jose-elias-alvarez/null-ls.nvim',
      requires = { "nvim-lua/plenary.nvim" },
      config = function()
         local null_ls = require('null-ls')
         null_ls.setup({
            diagnostics_format = "#{m} #{c}",
            sources = {
               null_ls.builtins.diagnostics.shellcheck,
               null_ls.builtins.diagnostics.fish,
               -- null_ls.builtins.diagnostics.proselint
               -- null_ls.builtins.diagnostics.vale
            },
         })
      end
   }

   use {
      'lervag/vimtex'
   }
   vim.g.vimtex_view_method = 'zathura'

   use {
      'hrsh7th/nvim-cmp',
      requires = {
         { 'hrsh7th/cmp-path' },
         { 'hrsh7th/cmp-cmdline' },
         { 'hrsh7th/cmp-buffer' },
         { 'hrsh7th/cmp-nvim-lua' },
         { 'hrsh7th/cmp-nvim-lsp' },
         { 'L3MON4D3/LuaSnip', requires = 'saadparwaiz1/cmp_luasnip' },
      },
      config = function() require('paq.cmp_') end
   }

   vim.g.nvim_tree_show_icons = {
      git = 1,
      folders = 1,
      files = 0,
      folder_arrows = 1
   }

   vim.g.nvim_tree_icon_padding = '' -- just arrows, no icons

   vim.g.nvim_tree_icons = {
      folder = {
         arrow_open = '▼',
         arrow_closed = '▷',
         -- default = '■',
         -- open = '◪',
         -- empty = '□',
         -- empty_open = '□',
         default = '',
         open = '',
         empty = '',
         empty_open = '',
      }
   }

   use {
      'kyazdani42/nvim-tree.lua',
      config = function()
         require('nvim-tree').setup {}
      end,
   }

   use { 'simrat39/symbols-outline.nvim',
      config = function()
      end,
   }

   vim.g.symbols_outline = {
      highlight_hovered_item = false,
      position = 'right',
      auto_preview = false,
      width = 50,
   }

   -- use { 'ggandor/lightspeed.nvim' }
   -- vim.cmd [[
   --    noremap f f
   --    noremap F F
   --    noremap t t
   --    noremap T T
   --    noremap s s
   --    noremap S S
   --    noremap x x
   --    noremap X X
   --    noremap t <Plug>Lightspeed_s
   --    noremap T <Plug>Lightspeed_S
   -- ]]
   -- require('lightspeed').setup {
   --    exit_after_idle_msec = { unlabeled = 1000, labeled = 1000 },
   --    -- TODO: look into this. i don't really understand what 'auto-jump' means
   --    -- either. this seems to work pretty well though.
   --    safe_labels = {
   --       -- '1', '2', '3', '4', '5', '6', '7', '8', '9'
   --       'n', 'e', 's', 'i', 'r', 'o', 'a',
   --       'k', 'v', 'm', 'c',
   --       'l', 'p', 'u', 'f'
   --    },
   --    labels = {
   --       -- '1', '2', '3', '4', '5', '6', '7', '8', '9'
   --       'n', 'e', 's', 'i', 'r', 'o', 'a',
   --       'k', 'v', 'm', 'c',
   --       'l', 'p', 'u', 'f'
   --    }
   -- }

   use {
      'rlane/pounce.nvim',
      config = function()
         vim.cmd [[
            nmap t <cmd>Pounce<CR>
            nmap T <cmd>PounceRepeat<CR>
         ]]

            -- vmap t <cmd>Pounce<CR>
            -- omap t <cmd>Pounce<CR>
         require('pounce').setup {
        -- accept_keys = "JFKDLSAHGNUVRBYTMICEOXWPQZ",
           accept_keys = "NTESIRKVHDOAMCLPUFYWXZQBGJ",
           -- accept_keys = "NTESIROAKVMC",
           accept_best_key = "<enter>",
           multi_window = true,
           debug = false,
         }
      end,
   }

   use {
      'lukas-reineke/indent-blankline.nvim',
      config = function() require('paq.indent_blankline_') end
   }

   use {
      'lewis6991/gitsigns.nvim',
      requires = 'nvim-lua/plenary.nvim',
      config = function() require('paq.gitsigns_') end
   }

  -- TODO i'm sold on comment.nvim, so... this will go
  use { 'echasnovski/mini.nvim', branch = 'stable' }
  require('mini.comment').setup {
     mappings = {
        comment = 'mc',
        comment_line = 'mcc',
        textobject = 'mc'
     }
  }

  use {
     'nvim-telescope/telescope.nvim',
     requires = {
        { 'nvim-lua/plenary.nvim' },
        { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
     },
     config = function() require('paq.telescope_') end
  }

  -- use {
  --    'windwp/nvim-autopairs',
  --    config = function()
  --       require('nvim-autopairs').setup {
  --       }
  --    end
  -- }

  use { 'ray-x/lsp_signature.nvim' }

  use { 'svban/YankAssassin.vim' }

  use {
     'ur4ltz/surround.nvim',
     config = function()
        require('surround').setup {
           mappings_style = 'sandwich'
        }
     end
  }

  use {
     'noib3/nvim-cokeline',
      config = function()
         local get_hex = require('cokeline/utils').get_hex
         local is_picking_focus = require('cokeline/mappings').is_picking_focus
         local is_picking_close = require('cokeline/mappings').is_picking_close

         require('cokeline').setup({
            show_if_buffers_are_at_least = 2,

            default_hl = {
               fg = function(buffer)
                  return buffer.is_focused and get_hex('Normal', 'fg') or get_hex('Comment', 'fg')
               end,
               bg = function(buffer)
                  return buffer.is_focused and get_hex('Normal', 'bg') or get_hex('Pmenu', 'bg')
               end
            },

            components = {
               --{ text = function(buffer) return (buffer.index ~= 1) and '▏ ' or ' ' end },
               { text = ' ' },
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
               { text = ' '}
            },
         })
      end,
   }

   -- themedev
   use 'nvim-treesitter/playground'
end
