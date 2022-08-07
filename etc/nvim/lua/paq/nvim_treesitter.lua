local tsconfigs = require 'nvim-treesitter.configs'

tsconfigs.setup {
   ensure_installed = 'all',
   sync_install = false,
   indent = {
      enable = true,
   },
   highlight = {
      enable = true,
   },
   matchup = {
      enable = true,
   },
   incremental_selection = {
      enable = true,
      keymaps = {
         init_selection = "<cr>",
         node_incremental = "<cr>",
         scope_incremental = "<c-q>",
         node_decremental = "<bs>",
      },
   },
   textobjects = {
      move = {
         enable = true,
         set_jumps = true,
         goto_next_start = {
            [')'] = '@block.outer'
         },
         goto_previous_start = {
            ['('] = '@block.outer'
         }
      }
   }
}
