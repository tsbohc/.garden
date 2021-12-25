local tsconfigs = require 'nvim-treesitter.configs'

tsconfigs.setup {
  ensure_installed = 'maintained',
  sync_install = false,
  highlight = {
    enable = true
  }
}
