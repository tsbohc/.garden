require 'lib/IndexAsMethod'

return IndexAsMethod (index, value) ->
  get_type = (index) ->
    if pcall(-> return vim.api.nvim_get_option(index))
      return 'o'
    elseif pcall(-> return vim.api.nvim_win_get_option(0, index))
      return 'wo'
    elseif pcall(-> return vim.api.nvim_buf_get_option(0, index))
      return 'bo'
    else
      return 'none'

  t = get_type(index)
  if t == 'none'
    if index\sub(1, 2) == 'no'
      index = index\sub(3)
      t = get_type index

      vim[t][index] = false
      return
    else
      print 'option not found', t, index
      return

  if value
    vim[t][index] = value
  else
    vim[t][index] = true
