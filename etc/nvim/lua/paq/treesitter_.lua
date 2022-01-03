local tsconfigs = require 'nvim-treesitter.configs'

tsconfigs.setup {
   ensure_installed = 'maintained',
   sync_install = false,
   indent = {
      entable = true,
   },
   highlight = {
      enable = true,
   },
   incremental_selection = {
      enable = true,
      keymaps = {
         init_selection = "<cr>",
         node_incremental = "<cr>",
         scope_incremental = "<tab>",
         node_decremental = "<s-tab>",
      },
   },
}
