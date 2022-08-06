  require('indent_blankline').setup {
    char = '·',
    context_char = '│',
    context_highlight_list = { 'Conceal' },
    space_char_blankline = " ",
    show_current_context = true,
    show_current_context_start = false,
    filetype_exclude = { 'help', 'packer' },
    buftype_exclude = { 'terminal' }
  }
