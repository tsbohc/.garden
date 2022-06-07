local telescope = require 'telescope'
local ki = require 'lib.ki'

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
  },
}

require('telescope').load_extension('fzf')

local function t(module, opts_override)
  local opts = {
    -- prompt_title = false,
    results_title = false,
    preview_title = false,
    sorting_strategy = "descending",
    layout_strategy = "bottom_pane",
    layout_config = {
      anchor = 'S',
      height = 15,
      width = 100,
      prompt_position = "bottom",
      --preview_height = 15,
      preview_width = 0.5,
      preview_cutoff = 50,
      --mirror = true,
    },
    borderchars = {
      prompt =  { ' ', ' ', '░', ' ', ' ', ' ', '░', '░' },
      results = { '╌', ' ', ' ', ' ', '+', '╌', ' ', ' ' },
      preview = { '╌', ' ', ' ', ' ', '╌', '+', ' ', ' ' },
    },
    --   prompt =  { ' ', '█', ' ', ' ', ' ', '█', '█', ' ' },
    --   preview = { ' ', '█', ' ', ' ', ' ', '█', '█', ' ' },
    --   results = { ' ', '█', '▄', ' ', ' ', '█', '█', '▄' },
    prompt_prefix = '  ',
    selection_caret = '› ',

  }
  if opts_override then
    opts = vim.tbl_deep_extend('force', opts_override, opts)
  end
  require('telescope.builtin')[module](opts)
end

ki.n('<leader>tf', function() t('find_files') end, { 'silent' })
ki.n('<leader>gr', function() t('lsp_references') end, { 'silent' })
ki.n('<leader>gd', function() t('lsp_definitions') end, { 'silent' })
ki.n('<leader>th', function() t('help_tags') end, { 'silent' })
ki.n('<leader>tj', function() t('jumplist') end, { 'silent' })
ki.n('<leader>tg', function() t('live_grep') end, { 'silent' })
ki.n('<leader>ts', function() t('lsp_document_symbols') end, { 'silent' })
ki.n('<leader>td', function() t('find_files', { cwd = '~/.garden' }) end, { 'silent' })

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
