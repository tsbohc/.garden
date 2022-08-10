local telescope = require('telescope')
local actions = require('telescope.actions')

local ki = require('lib.ki')

telescope.setup {
   extensions = {
      fzf = {
         fuzzy = true,                    -- false will only do exact matching
         override_generic_sorter = true,  -- override the generic sorter
         override_file_sorter = true,     -- override the file sorter
         case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
      }
   },
   defaults = {
      borderchars = {
         prompt =  { '─', '│', ' ', '│', '┌', '┐', '│', '│' },
         results = { '─', '│', '─', '│', '├', '┤', '┘', '└' },
         preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
      },
      prompt_title = false,
      mappings = {
         i = {
            ['<Tab>'] = actions.move_selection_next,
            ['<S-Tab>'] = actions.move_selection_previous,
            ['<c-n>'] = actions.preview_scrolling_down,
            ['<c-e>'] = actions.preview_scrolling_up,
            -- ['<return>'] = actions.file_vsplit,
         },
         n = {
            ['n'] = actions.move_selection_next,
            ['e'] = actions.move_selection_previous,
            ['N'] = actions.preview_scrolling_down,
            ['E'] = actions.preview_scrolling_up,
            -- ['<return>'] = actions.file_vsplit,
         }
      }
   },
}

require('telescope').load_extension('fzf')

local function t(module, opts_override)
   local opts = {
      -- prompt_title = false,
      results_title = false,
      preview_title = false,
      sorting_strategy = "ascending",
      layout_strategy = "bottom_pane",
      layout_config = {
         scroll_speed = 5,
         anchor = 'S',
         height = 16,
         width = 0.999,
         prompt_position = "top",
         preview_width = 0.66,
         preview_cutoff = 1,
         --mirror = true,
      },
      borderchars = {
         -- prompt =  { '═', '║', '3', '║', '╔', '╗', '7', '8' },
         -- results = { 'a', '│', '═', '║', 'e', 'f', '╛', '╚' },
         -- preview = { '═', '║', '═', '│', '╒', '╣', '╝', '╘' },

         -- ═ ║ ╒ ╓ ╔ ╕ ╖ ╗ ╘ ╙ ╚ ╛ ╜ ╝ ╞ ╟ ╠ ╡ ╢ ╣ ╤ ╥ ╦ ╧ ╨ ╩ ╪ ╫ ╬
         -- ╔ ╗ ╚ ╝
         -- prompt =  { '═', '║', '3', '║', '╔', '╗', '7', '8' },
         -- results = { 'a', ' ', '═', '║', 'e', 'f', '═', '╚' },
         -- preview = { ' ', '║', '═', ' ', ' ', '║', '╝', '═' },

         prompt =  { '═', ' ', '3', ' ', '═', '═', '7', '8' },
         results = { 'a', ' ', '═', ' ', 'e', 'f', '═', '═' },
         preview = { ' ', ' ', '═', ' ', ' ', ' ', '═', '═' },
      -- prompt =  { '1', '2', '3', '4', '5', '6', '7', '8' },
      -- results = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h' },
      -- preview = { '!', '@', '#', '$', '%', '^', '&', '*' },
      },
      prompt_prefix = '  ',
      selection_caret = '  ',

   }
   if opts_override then
      opts = vim.tbl_deep_extend('force', opts_override, opts)
   end
   require('telescope.builtin')[module](opts)
end

-- ivy
-- local function t(module, opts)
--    require('telescope.builtin')[module](require('telescope.themes').get_ivy(opts))
-- end
   local woo = 1

   ki.n('<leader>t?', function() t('builtin') end, { 'silent' })
   ki.n('<leader>tf', function() t('find_files') end, { 'silent' })

   ki.n('<leader>tr', function() t('lsp_references', {
      trim_text = true
   }) end, { 'silent' })
   ki.n('<leader>td', function() t('lsp_definitions', {
      trim_text = true
   }) end, { 'silent' })
   ki.n('<leader>ts', function() t('lsp_document_symbols') end, { 'silent' })
   ki.n('<leader>ti', function() t('diagnostics', {
      no_unlisted = true, -- only for listed buffers
      no_sign = true, -- less clutter
   }) end, { 'silent' })

   ki.n('<leader>th', function() t('help_tags') end, { 'silent' })
   ki.n('<leader>tm', function() t('man_pages') end, { 'silent' })

   ki.n('<leader>tk', function() t('keymaps') end, { 'silent' })
   ki.n('<leader>tj', function() t('jumplist') end, { 'silent' })
   ki.n('<leader>tg', function() t('live_grep') end, { 'silent' })
   ki.n('<leader>tt', function() t('find_files', { cwd = '~' }) end, { 'silent' })
   ki.n('<leader>tc', function() t('find_files', { cwd = '~/.garden/etc/nvim/' }) end, { 'silent' })

   -- sorting_strategy = "ascending",
   -- layout_strategy = "vertical",
   -- layout_config = {
      --   anchor = 'S',
      --   height = 0.5,
      --   width = 100,
      --   prompt_position = 'bottom',
      --   --preview_cutoff = 120, prompt_position = "bottom"
      -- },



      -- local function t(module, opts_override)
         --   local opts = {
            --     -- prompt_title = false,
            --     results_title = false,
            --     preview_title = false,
            --     sorting_strategy = "ascending",
            --     layout_strategy = "vertical",
            --     layout_config = {
               --       anchor = 'S',
               --       height = 30,
               --       width = 116,
               --       preview_height = 15,
               --       --mirror = true,
               --       --preview_cutoff = 220,
               --       prompt_position = "top"
               --     },
               --     border = true,
               --     -- borderchars = { '▄', '█', '▀', '█', '▄', '▄', '▀', '▀' },
               --     borderchars = {
                  --      prompt =  { '╌', ' ', '╌', ' ', ' ', ' ', ' ', ' ' },
                  --      results = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
                  --      preview = { '╌', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
                  --     },
                  --     -- borderchars = {
                     --     --   -- right and bottom shadow
                     --     --   prompt =  { ' ', '█', ' ', ' ', ' ', '█', '█', ' ' },
                     --     --   preview = { ' ', '█', ' ', ' ', ' ', '█', '█', ' ' },
                     --     --   results = { ' ', '█', '▄', ' ', ' ', '█', '█', '▄' },
                     --     -- },
                     --     prompt_prefix = '  ',
                     --     selection_caret = '› ',
                     --
                     --   }
                     --   if opts_override then
                     --     opts = vim.tbl_deep_extend('force', opts_override, opts)
                     --   end
                     --   require('telescope.builtin')[module](opts)
                     -- end
