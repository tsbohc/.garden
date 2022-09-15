return {
  'nvim-treesitter/nvim-treesitter',

   config = function()
      local ok, tsconfigs = pcall(require, 'nvim-treesitter.configs')
      if not ok then return end
      tsconfigs.setup {
         ensure_installed = 'all',
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
   end
}
