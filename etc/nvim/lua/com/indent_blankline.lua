return {
  'lukas-reineke/indent-blankline.nvim',
  config = function()
    local ok, indent_blakline = pcall(require, 'indent_blankline')
    if not ok then return end
    indent_blankline.setup {
      char = '·',
      --context_char = '·',
      --context_highlight_list = { 'Comment' },
      space_char_blankline = " ",
      show_current_context = false,
      show_current_context_start = false,
      filetype_exclude = { 'help', 'packer' },
      buftype_exclude = { 'terminal' }
    }
  end
}
