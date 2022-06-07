require('indent_blankline').setup {
  char = '·',
  --context_char = '·',
  --context_highlight_list = { 'Comment' },
  space_char_blankline = " ",
  show_current_context = false,
  show_current_context_start = false,
  filetype_exclude = { 'help', 'packer' },
  buftype_exclude = { 'terminal' }
}
