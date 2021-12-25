local telescope = require 'telescope'
local ki = require 'lib.ki'

-- local my_theme = require('telescope.themes').get_dropdown({
--   borderchars = {
--     { '─', '│', '─', '│', '┌', '┐', '┘', '└'},
--     prompt = {"─", "│", " ", "│", '┌', '┐', "│", "│"},
--     results = {"─", "│", "─", "│", "├", "┤", "┘", "└"},
--     preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└'},
--   },
--   width = 0.8,
--   previewer = false,
--   prompt_title = false
-- })
--
-- local function ts(p)
--   require('telescope')[p](opts)
-- end

telescope.setup {
  -- pickers = {
  --   find_files = {
  --     theme = "ivy",
  --   }
  -- },
  defaults = {
    --borderchars = { '▄', '█', '▀', '█', '▄', '▄', '▀', '▀' },
    -- borderchars = { '╌', '┊', '╌', '┊', '┏', '┓', '┛', '┗' },
    -- borderchars = { '╌', '┊', '╌', '┊', '┌', '┐', '┘', '└' },
    borderchars = {
      prompt =  { '─', '│', ' ', '│', '┌', '┐', '│', '│' },
      results = { '─', '│', '─', '│', '├', '┤', '┘', '└' },
      preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
    },
    prompt_title = false,
    -- winblend = 3,
  },
}

local function t(module)
  local opts = {
    -- prompt_title = false,
    results_title = false,
    preview_title = false,
    sorting_strategy = "ascending",
    layout_strategy = "bottom_pane",
    layout_config = {
      anchor = 'S',
      height = 20,
      width = 100,
      preview_cutoff = 120,
      prompt_position = "top"
    },
    border = true,
    borderchars = {
      prompt =  { '╌', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
      results = { ' ', '|', ' ', '', ' ', ' ', ' ', ' ' },
      preview = { ' ', '', ' ', ' ', ' ', ' ', ' ', ' ' },
    },
    prompt_prefix = '  ',
    selection_caret = '› ',

  }
  require('telescope.builtin')[module](opts)
end

ki.n('<leader><leader>', function() t('find_files') end)
ki.n('gr', function() t('lsp_references') end)
ki.n('gd', function() t('lsp_definitions') end)



-- sorting_strategy = "ascending",
-- layout_strategy = "vertical",
-- layout_config = {
--   anchor = 'S',
--   height = 0.5,
--   width = 100,
--   prompt_position = 'bottom',
--   --preview_cutoff = 120, prompt_position = "bottom"
-- },
